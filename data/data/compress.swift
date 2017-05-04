//
//  compress.swift
//  data
//
//  Created by Adam Fowler on 04/05/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

import Compression
import Foundation

public class DataCompress {
    
    /// Compresses data. This function allocates all the buffers required to do the work
    /// - parameters:
    ///     - src: uncompressed data
    ///     - algorithm: compression algorithm used
    /// - returns: compressed data buffer or nil if there was an error
    public static func compress(src: Data, algorithm: Algorithm) -> Data? {
        let scratchBufferSize = getEncodeScratchBufferSize(algorithm: algorithm)
        var scratchBuffer = Data(count:scratchBufferSize)
        var dest = Data(count:src.count + scratchBuffer.count)
        
        return compress(src:src, dest:&dest, scratchBuffer:&scratchBuffer, algorithm:algorithm)
    }
    
    /// Compresses data. This function takes all the buffers required to do the work in as parameters
    /// - parameters:
    ///     - src: uncompressed data
    ///     - dest: buffer to save compressed data into
    ///     - scratchBuffer: scratch buffer used by compress process
    ///     - algorithm: compression algorithm used
    /// - returns: compressed data buffer or nil if there was an error
    public static func compress(src: Data, dest: inout Data, scratchBuffer: inout Data, algorithm: Algorithm) -> Data? {
        let dest_size = dest.withUnsafeMutableBytes { destBytes in
            scratchBuffer.withUnsafeMutableBytes { scratchBufferBytes in
                src.withUnsafeBytes { srcBytes in
                    compression_encode_buffer(destBytes, dest.count, srcBytes, src.count, scratchBufferBytes, algorithm.compression_algorithm)
                }
            }
        }
        if dest_size > 0 {
            dest.removeSubrange(dest_size..<dest.count)
        } else {
            print("Error: failed to compress data")
            return nil
        }
        return dest
    }
    
    /// Decompresses data. This function allocates all the buffers required to do the work. The function requires a
    /// destination buffer as it assumes the user has a better idea of the size of the decompressed buffer
    /// - parameters:
    ///     - src: compressed data
    ///     - dest: buffer to save decompressed data into
    ///     - algorithm: compression algorithm used
    /// - returns: decompressed data buffer or nil if there was an error
    public static func decompress(src: Data, dest: inout Data, algorithm: Algorithm) -> Data? {
        let scratchBufferSize = getDecodeScratchBufferSize(algorithm: algorithm)
        var scratchBuffer = Data(count:scratchBufferSize)
        
        return decompress(src: src, dest: &dest, scratchBuffer: &scratchBuffer, algorithm: algorithm)
    }
    
    /// Decompresses data. This function takes all the buffers required to do the work in as parameters
    /// - parameters:
    ///     - src: compressed data
    ///     - dest: buffer to save decompressed data into
    ///     - scratchBuffer: scratch buffer used by decompress process
    ///     - algorithm: compression algorithm used
    /// - returns: decompressed data buffer or nil if there was an error
    public static func decompress(src: Data, dest: inout Data, scratchBuffer: inout Data, algorithm: Algorithm) -> Data? {
        let dest_size = dest.withUnsafeMutableBytes { destBytes in
            scratchBuffer.withUnsafeMutableBytes { scratchBufferBytes in
                src.withUnsafeBytes { srcBytes in
                    compression_decode_buffer(destBytes, dest.count, srcBytes, src.count, scratchBufferBytes, algorithm.compression_algorithm)
                }
            }
        }
        if dest_size > 0 {
            dest.removeSubrange(dest_size..<dest.count)
        } else {
            print("Error: failed to decompress data")
            return nil
        }
        return dest
    }
    
    
    /// Returns the size of scratch buffer required to encode specified compression algorithm
    /// - parameter algorithm: compression algorithm
    /// - returns: size of scratch buffer required
    public static func getEncodeScratchBufferSize(algorithm: Algorithm) -> Int {
        return compression_encode_scratch_buffer_size(algorithm.compression_algorithm)
    }
    
    /// Returns the size of scratch buffer required to decode specified compression algorithm
    /// - parameter algorithm: compression algorithm
    /// - returns: size of scratch buffer required
    public static func getDecodeScratchBufferSize(algorithm: Algorithm) -> Int {
        return compression_decode_scratch_buffer_size(algorithm.compression_algorithm)
    }
    
    /// Compression algorithms available to DataCompress
    public enum Algorithm {
        case lz4
        case zlib
        case lzma
        case lzfse
        
        var compression_algorithm: compression_algorithm {
            switch self {
            case .lz4: return COMPRESSION_LZ4
            case .zlib: return COMPRESSION_ZLIB
            case .lzma: return COMPRESSION_LZMA
            case .lzfse: return COMPRESSION_LZFSE
            }
        }
    }
    
}

/// Class for doing a streamed compression or decompression. You can either stream source data or destination buffers
/// This class does not support the Data class as we cannot guarantee the existence of Unsafe buffers between initialisation
/// and process
public class DataCompressStream {
    
    /// Initialise class for streaming source data
    /// - parameters:
    ///     - dest: pointer to destination buffer
    ///     - count: size of destination buffer
    ///     - operation: .compress or .decompress
    ///     - algorithm: compression algorithm to use
    public init?(dest: UnsafeMutablePointer<UInt8>, count: Int, operation: Operation, algorithm : DataCompress.Algorithm) {
        stream = UnsafeMutablePointer<compression_stream>.allocate(capacity: 1).pointee
        let status = initStream(operation: operation, algorithm: algorithm)
        if status == false { return nil }
        
        self.dest = dest
        stream.dst_ptr = dest
        stream.dst_size = count
    }
    
    /// Initialise class for streaming destination data
    /// - parameters:
    ///     - src: pointer to source buffer
    ///     - count: size of source buffer
    ///     - operation: .compress or .decompress
    ///     - algorithm: compression algorithm to use
    public init?(src: UnsafePointer<UInt8>, count: Int, operation: Operation, algorithm : DataCompress.Algorithm) {
        stream = UnsafeMutablePointer<compression_stream>.allocate(capacity: 1).pointee
        let status = initStream(operation: operation, algorithm: algorithm)
        if status == false { return nil }
        
        self.src = src
        stream.src_ptr = src
        stream.src_size = count
    }
    
    deinit {
        compression_stream_destroy(&stream)
    }
    
    ///init compression stream object
    func initStream(operation: Operation, algorithm : DataCompress.Algorithm) -> Bool {
        let status = compression_stream_init(&stream, operation.compression_stream_operation, algorithm.compression_algorithm)
        return status == COMPRESSION_STATUS_OK
    }
    
    ///supply some more source data to process. Class needs to have been initialised to stream source data
    /// - parameters:
    ///     - src: pointer to new source buffer
    ///     - count: size of new source buffer
    /// - returns: Returns status of streaming .ok, .end or .error
    public func process(src: UnsafePointer<UInt8>, count: Int) -> Status {
        guard dest != nil else { return .error }

        stream.src_ptr = src
        stream.src_size = count
        let status = compression_stream_process(&stream, 0)
        
        switch(status) {
        case COMPRESSION_STATUS_OK: return .ok
        case COMPRESSION_STATUS_END: return .end
        case COMPRESSION_STATUS_ERROR: return .error
        default: return .error
        }
    }
    
    ///supply a destination buffer for process to write to. Class needs to have been initialised to stream destination data
    /// - parameters:
    ///     - dest: pointer to new destination buffer
    ///     - count: size of new destination buffer
    /// - returns: Returns status of streaming .ok, .end or .error
    public func process(dest: UnsafeMutablePointer<UInt8>, count: Int) -> Status {
        guard src != nil else { return .error }
        
        stream.dst_ptr = dest
        stream.dst_size = count
        let status = compression_stream_process(&stream, Int32(COMPRESSION_STREAM_FINALIZE.rawValue))
        
        switch(status) {
        case COMPRESSION_STATUS_OK: return .ok
        case COMPRESSION_STATUS_END: return .end
        case COMPRESSION_STATUS_ERROR: return .error
        default: return .error
        }
    }
    
    public enum Status {
        case ok
        case end
        case error
    }

    public enum Operation {
        case compress
        case decompress
        
        var compression_stream_operation: compression_stream_operation {
            switch self {
            case .compress: return COMPRESSION_STREAM_ENCODE
            case .decompress: return COMPRESSION_STREAM_DECODE
            }
        }
    }

    var dest : UnsafeMutablePointer<UInt8>?
    var src : UnsafePointer<UInt8>?
    var stream : compression_stream
}

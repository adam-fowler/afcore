//
//  dataTests.swift
//  dataTests
//
//  Created by Adam Fowler on 04/05/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

import XCTest
@testable import afcore

class dataTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func createRandomDataBlock(count: Int) -> Data {
        var data = Data(count: count)
        for i in 0..<count {
            data[i] = UInt8(arc4random_uniform(256))
        }
        return data
    }
    
    func compareData(_ a: Data, _ b: Data) -> Bool {
        var equal = true
        for i in 0..<a.count {
            if a[i] != b[i] { equal = false }
        }
        return equal
    }
    
    func testAES() {
        let data = createRandomDataBlock(count:1024)
        let crypted = AES.encrypt(data: data, key: "thisisthetestkey")!
        let decrypted = AES.decrypt(cryptData: crypted, key: "thisisthetestkey")!
        XCTAssert(compareData(data, decrypted))
    }
    
    func testDataCompress() {
        let data = createRandomDataBlock(count:4096)
        var decompressed = Data(count:4096)
        let compressed = DataCompress.compress(src: data, algorithm: .lz4)!
        decompressed = DataCompress.decompress(src: compressed, dest: &decompressed, algorithm: .lz4)!
        XCTAssert(compareData(data, decompressed))
        
    }
    
    func streamSourceDecompress(src : UnsafePointer<UInt8>, srcCount: Int, dest : UnsafeMutablePointer<UInt8>, destCount: Int) -> Bool {
        var status = DataCompressStream.Status.ok
        let stream = DataCompressStream(dest:dest, count:destCount, operation:.decompress, algorithm: .lz4)
        if let stream = stream {
            var bytes = 0
            while true {
                status = stream.process(src:src+bytes, count:min(256, srcCount-bytes))
                if status == .error { print("Error"); break }
                if status == .end { break }
                bytes += 256
            }
        }
        return status == DataCompressStream.Status.end
    }
    
/*    func testDataCompressStreamSource() {
        let data = createRandomDataBlock(count:4096)
        var decompressed = Data(count:4096)
        let compressed = DataCompress.compress(src: data, algorithm: .lz4)!

        let success = decompressed.withUnsafeMutableBytes { decompressedBytes in
            compressed.withUnsafeBytes { compressedBytes in
                streamSourceDecompress(src: compressedBytes, srcCount: compressed.count, dest: decompressedBytes, destCount: decompressed.count)
            }
        }

        XCTAssert(success)
        XCTAssert(compareData(data, decompressed))
    }*/
    
/*    func streamDestCompress(src : UnsafePointer<UInt8>, srcCount: Int, dest : inout Data, block : inout Data) -> Bool {
        var status = DataCompressStream.Status.ok
        let stream = DataCompressStream(src:src, count:srcCount, operation:.compress, algorithm: .lz4)
        if let stream = stream {
            while true {
                status = block.withUnsafeMutableBytes { blockBytes in
                    stream.process(dest:blockBytes, count:block.count)
                }
                dest.append(block)
                if status == .error { print("Error"); break }
                if status == .end { break }
            }
        }
        return status == DataCompressStream.Status.end
    }*/
    
/*    func testDataCompressStreamDest() {
        let data = createRandomDataBlock(count:4096)
        var compressed = Data()
        var block = Data(count:256)
        
        let success = data.withUnsafeBytes { dataBytes in
            streamDestCompress(src: dataBytes, srcCount: data.count, dest: &compressed, block: &block)
        }
        XCTAssert(success)
        
        var decompressed = Data(count:4096)
        decompressed = DataCompress.decompress(src: compressed, dest: &decompressed, algorithm: .lz4)!
        XCTAssert(compareData(data, decompressed))

    }*/
}

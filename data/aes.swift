//
//  aes.swift
//  utils
//  requires CommonCrypto. Module project created from https://github.com/sergejp/CommonCrypto
//  Created by Adam Fowler on 02/05/2017.
//  Code based on http://stackoverflow.com/documentation/swift/7026/aes-encryption#t=201705021358094334689
//

import Foundation

#if REQUIRE_AES
// AES code requires CommonCrypto library. You can find module project here  https://github.com/sergejp/CommonCrypto. I haven't included it in the 
// project for the simple reason I don't want to drag encryption code into projects that don't need it.
import CommonCrypto

/// class wrapping the CommonCrypto implementations of AES
/// To use this you also need the CommonCrypto framework which wraps up the C library
public class AES {

    /// Encrypt data with CBC 256 bit key AES. IV data is randomly generated and prefixed to the crypted data
    /// - parameters:
    ///     - data: Data to be encrypted
    ///     - key: Encryption key
    /// - returns: Encrypted data
    public static func encrypt(data:Data, key:String) -> Data? {
        let keyData = sha256Hash(key)!
        let keyLength = size_t(kCCKeySizeAES256)
        let ivLength = size_t(kCCKeySizeAES256)
        let options = CCOptions(kCCOptionPKCS7Padding)
        let cryptLength  = size_t(data.count + keyLength + ivLength)
        var cryptData = Data(count:cryptLength)
        
        // construct IV data
        let status = cryptData.withUnsafeMutableBytes {cryptBytes in SecRandomCopyBytes(kSecRandomDefault, Int(ivLength), cryptBytes); }
        if (status != 0) {
            print("IV Error, errno: \(status)")
            return nil
        }
        
        var numBytesEncrypted :size_t = 0
        
        let cryptStatus = cryptData.withUnsafeMutableBytes {cryptBytes in
            data.withUnsafeBytes {dataBytes in
                keyData.withUnsafeBytes {keyBytes in
                    CCCrypt(CCOperation(kCCEncrypt),
                            CCAlgorithm(kCCAlgorithmAES),
                            options,
                            keyBytes, keyLength,
                            cryptBytes,     // IV data
                            dataBytes, data.count,
                            cryptBytes + ivLength, cryptLength,
                            &numBytesEncrypted)
                }
            }
        }
        
        if cryptStatus == Int32(kCCSuccess) {
            cryptData.removeSubrange(ivLength + numBytesEncrypted..<cryptData.count)
        } else {
            print("Error: \(cryptStatus)")
        }
        
        return cryptData;
    }

    /// Decrypt data generated with CBC 256 bit key AES. IV data get be found prefixed to the encrypted data
    /// - parameters:
    ///     - cryptData: Data to be decrypted
    ///     - key: Encryption key
    /// - returns: Unencrypted data
    public static func decrypt(cryptData:Data, key:String) -> Data? {
        let keyData = sha256Hash(key)!
        let keyLength = size_t(kCCKeySizeAES256)
        let ivLength = size_t(kCCKeySizeAES256)
        let options = CCOptions(kCCOptionPKCS7Padding)
        let cryptLength  = size_t(cryptData.count)
        var data = Data(count:cryptLength)
        
        var numBytesEncrypted :size_t = 0
        
        let cryptStatus = data.withUnsafeMutableBytes {dataBytes in
            cryptData.withUnsafeBytes {cryptBytes in
                keyData.withUnsafeBytes {keyBytes in
                    CCCrypt(CCOperation(kCCDecrypt),
                            CCAlgorithm(kCCAlgorithmAES),
                            options,
                            keyBytes, keyLength,
                            cryptBytes,     // IV data
                            cryptBytes+ivLength, cryptData.count-ivLength,
                            dataBytes, cryptLength,
                            &numBytesEncrypted)
                }
            }
        }
        
        if cryptStatus == Int32(kCCSuccess) {
            data.removeSubrange(numBytesEncrypted..<data.count)
            
        } else {
            print("Error: \(cryptStatus)")
            return nil
        }
        
        return data
    }

    static func sha256Hash(_ string: String) -> Data? {
        let len = Int(CC_SHA256_DIGEST_LENGTH)
        let data = string.data(using:.utf8)!
        var hash = Data(count:len)
        
        let _ = hash.withUnsafeMutableBytes {hashBytes in
            data.withUnsafeBytes {dataBytes in
                CC_SHA256(dataBytes, CC_LONG(data.count), hashBytes)
            }
        }
        return hash
    }
    
}

#endif // REQUIRE_AES

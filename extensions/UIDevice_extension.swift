//
//  UIDevice_extension.swift
//  Viewfinder
//
//  Created by Adam Fowler on 06/04/2017.
//  Code from http://stackoverflow.com/questions/26028918/ios-how-to-determine-the-current-iphone-device-model-in-swift
//

import UIKit

public enum Model : String {
    case simulator   = "simulator/sandbox",
    iPod1            = "iPod 1",
    iPod2            = "iPod 2",
    iPod3            = "iPod 3",
    iPod4            = "iPod 4",
    iPod5            = "iPod 5",
    iPod6            = "iPod 6",
    
    iPhone4          = "iPhone 4",
    iPhone4S         = "iPhone 4S",
    iPhone5          = "iPhone 5",
    iPhone5S         = "iPhone 5S",
    iPhone5C         = "iPhone 5C",
    iPhone6          = "iPhone 6",
    iPhone6plus      = "iPhone 6 Plus",
    iPhone6S         = "iPhone 6S",
    iPhone6Splus     = "iPhone 6S Plus",
    iPhoneSE         = "iPhone SE",
    iPhone7          = "iPhone 7",
    iPhone7plus      = "iPhone 7 Plus",
    iPhone8          = "iPhone 8",
    iPhone8plus      = "iPhone 8 Plus",
    iPhoneX          = "iPhone X",
    iPhoneXS         = "iPhone XS",
    iPhoneXSmax      = "iPhone XS Max",
    iPhoneXR         = "iPhone XR",

    iPad2            = "iPad 2",
    iPad3            = "iPad 3",
    iPad4            = "iPad 4",
    iPad5            = "iPad 5",
    iPad6            = "iPad 6",
    iPadMini1        = "iPad Mini 1",
    iPadMini2        = "iPad Mini 2",
    iPadMini3        = "iPad Mini 3",
    iPadMini4        = "iPad Mini 4",
    iPadAir1         = "iPad Air 1",
    iPadAir2         = "iPad Air 2",
    iPadPro9_7       = "iPad Pro 9.7\"",
    iPadPro10_5      = "iPad Pro 10.5\"",
    iPadPro12_9_1      = "iPad Pro 12.9\" 1",
    iPadPro12_9_2      = "iPad Pro 12.9\" 2",
    iPadPro12_9_3      = "iPad Pro 12.9\" 3",
    iPadPro11_1       = "iPadPro 11\"",

    unrecognized     = "?unrecognized?"
}

public enum Processor : Int {
    case none = 0
    case a4
    case a5
    case a5x
    case a6
    case a6x
    case a7
    case a8
    case a8x
    case a9
    case a9x
    case a10
    case a10x
    case a11
    case a12
    case a12x
}

public extension UIDevice {
    
    public var hasNotch: Bool { let system = self.systemType; return system == .iPhoneX || system == .iPhoneXS || system == .iPhoneXSmax || system == .iPhoneXR}
    /// iPhone model type. Gets model name from systemInfo and converts to a more human readable version
    public var systemType: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        var modelMap : [ String : Model ] = [
            "i386"       : .simulator,
            "x86_64"     : .simulator,
            "iPod1,1"    : .iPod1,
            "iPod2,1"    : .iPod2,
            "iPod3,1"    : .iPod3,
            "iPod4,1"    : .iPod4,
            "iPod5,1"    : .iPod5,
            "iPod7,1"    : .iPod6,
            
            "iPhone3,1"  : .iPhone4,
            "iPhone3,2"  : .iPhone4,
            "iPhone3,3"  : .iPhone4,
            "iPhone4,1"  : .iPhone4S,
            "iPhone5,1"  : .iPhone5,
            "iPhone5,2"  : .iPhone5,
            "iPhone5,3"  : .iPhone5C,
            "iPhone5,4"  : .iPhone5C,
            "iPhone6,1"  : .iPhone5S,
            "iPhone6,2"  : .iPhone5S,
            "iPhone7,1"  : .iPhone6plus,
            "iPhone7,2"  : .iPhone6,
            "iPhone8,1"  : .iPhone6S,
            "iPhone8,2"  : .iPhone6Splus,
            "iPhone8,4"  : .iPhoneSE,
            "iPhone9,1"  : .iPhone7,
            "iPhone9,2"  : .iPhone7plus,
            "iPhone9,3"  : .iPhone7,
            "iPhone9,4"  : .iPhone7plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,2" : .iPhone8plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,4" : .iPhone8,
            "iPhone10,5" : .iPhone8plus,
            "iPhone10,6" : .iPhoneX,
            "iPhone11,2" : .iPhoneXS,
            "iPhone11,4" : .iPhoneXSmax,
            "iPhone11,6" : .iPhoneXSmax,
            "iPhone11,8" : .iPhoneXR,

            "iPad2,1"    : .iPad2,
            "iPad2,2"    : .iPad2,
            "iPad2,3"    : .iPad2,
            "iPad2,4"    : .iPad2,
            "iPad3,1"    : .iPad3,
            "iPad3,2"    : .iPad3,
            "iPad3,3"    : .iPad3,
            "iPad3,4"    : .iPad4,
            "iPad3,5"    : .iPad4,
            "iPad3,6"    : .iPad4,
            "iPad2,5"    : .iPadMini1,
            "iPad2,6"    : .iPadMini1,
            "iPad2,7"    : .iPadMini1,
            "iPad4,1"    : .iPadAir1,
            "iPad4,2"    : .iPadAir2,
            "iPad4,4"    : .iPadMini2,
            "iPad4,5"    : .iPadMini2,
            "iPad4,6"    : .iPadMini2,
            "iPad4,7"    : .iPadMini3,
            "iPad4,8"    : .iPadMini3,
            "iPad4,9"    : .iPadMini3,
            "iPad5,1"    : .iPadMini4,
            "iPad5,2"    : .iPadMini4,
            "iPad6,3"    : .iPadPro9_7,
            "iPad6,4"    : .iPadPro9_7,
            "iPad6,7"    : .iPadPro12_9_1,
            "iPad6,8"    : .iPadPro12_9_1,
            "iPad6,11"   : .iPad5,
            "iPad6,12"   : .iPad5,
            "iPad7,1"    : .iPadPro12_9_2,
            "iPad7,2"    : .iPadPro12_9_2,
            "iPad7,3"    : .iPadPro10_5,
            "iPad7,4"    : .iPadPro10_5,
            "iPad7,5"    : .iPad6,
            "iPad7,6"    : .iPad6,
            "iPad8,1"    : .iPadPro11_1,
            "iPad8,2"    : .iPadPro11_1,
            "iPad8,3"    : .iPadPro11_1,
            "iPad8,4"    : .iPadPro11_1,
            "iPad8,5"    : .iPadPro12_9_3,
            "iPad8,6"    : .iPadPro12_9_3,
            "iPad8,7"    : .iPadPro12_9_3,
            "iPad8,8"    : .iPadPro12_9_3
]
        
        if let model = modelMap[modelCode ?? ""] {
            return model
        }
        return Model.unrecognized
    }
    
    public var processor : Processor {
        var processorMap : [Model : Processor] = [
            .iPod4 : .a4,
            .iPod5 : .a5,
            .iPod6 : .a8,
            
            .iPhone4 : .a4,
            .iPhone4S : .a5,
            .iPhone5 : .a6,
            .iPhone5C : .a6,
            .iPhone5S : .a7,
            .iPhone6 : .a8,
            .iPhone6plus : .a8,
            .iPhone6S : .a9,
            .iPhone6Splus : .a9,
            .iPhoneSE : .a9,
            .iPhone7 : .a10,
            .iPhone7plus : .a10,
            .iPhone8 : .a11,
            .iPhone8plus : .a11,
            .iPhoneX : .a11,
            .iPhoneXS : .a12,
            .iPhoneXSmax : .a12,
            .iPhoneXR : .a12,

            /*            .iPad1 : .a4,*/
            .iPad2 : .a5,
            .iPad3 : .a5x,
            .iPad4 : .a6x,
            .iPad5 : .a9,
            .iPad6 : .a10,
            .iPadMini1 : .a5,
            .iPadMini2 : .a7,
            .iPadMini3 : .a7,
            .iPadMini4 : .a8,
            .iPadAir1 : .a7,
            .iPadAir2 : .a8x,
            .iPadPro9_7 : .a9x,
            .iPadPro10_5 : .a10x,
            .iPadPro12_9_1 : .a9x,
            .iPadPro12_9_2 : .a10x,
            .iPadPro12_9_3 : .a12x,
            .iPadPro11_1 : .a12x
        ]
        return processorMap[systemType] ?? .none
    }
}

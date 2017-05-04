//
//  Enum_conversion.swift
//  extensions
//
//  Created by Adam Fowler on 15/04/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

import UIKit
import AVFoundation

extension UIDeviceOrientation {
    public var videoOrientation: AVCaptureVideoOrientation? {
        switch self {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeRight
        case .landscapeRight: return .landscapeLeft
        default: return nil
        }
    }
    public var imageOrientation: UIImageOrientation? {
        switch self {
        case .portrait: return .right
        case .portraitUpsideDown: return .left
        case .landscapeLeft: return .up
        case .landscapeRight: return .down
        default: return nil
        }
    }
}


extension UIInterfaceOrientation {
    public var videoOrientation: AVCaptureVideoOrientation? {
        switch self {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeLeft
        case .landscapeRight: return .landscapeRight
        default: return nil
        }
    }
}

extension UIViewAnimationCurve {
    public var animationOption: UIViewAnimationOptions {
        switch self {
        case .easeInOut: return .curveEaseInOut
        case .easeIn: return .curveEaseIn
        case .easeOut: return .curveEaseOut
        case .linear: return .curveLinear
        }
    }
}


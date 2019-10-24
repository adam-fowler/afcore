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
    /// Convert from UIDeviceOrientation to AVCaptureVideoOrientation
    public var videoOrientation: AVCaptureVideoOrientation? {
        switch self {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeRight
        case .landscapeRight: return .landscapeLeft
        default: return nil
        }
    }
    /// Convert from UIDeviceOrientation to UIImageOrientation
    public var imageOrientation: UIImage.Orientation? {
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
    /// Convert from UIInterfaceOrientation to AVCaptureVideoOrientation
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

extension UIView.AnimationCurve {
    /// Convert from UIViewAnimationCurve to UIViewAnimationOptions
    public var animationOption: UIView.AnimationOptions {
        switch self {
        case .easeInOut: return .curveEaseInOut
        case .easeIn: return .curveEaseIn
        case .easeOut: return .curveEaseOut
        case .linear: return .curveLinear
        default: return .curveEaseInOut
        }
    }
}


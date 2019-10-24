//
//  UIBarButtonSystemItem_extension.swift
//  extensions
//
//  Created by Adam Fowler on 15/04/2017
//  Code from http://stackoverflow.com/questions/21187885/use-uibarbuttonitem-icon-in-uibutton
//

import UIKit

extension UIBarButtonItem.SystemItem {
    
    /// Return UIImage used for bar button system icons.
    /// Warning: do not use this extension if you care about what is in the toolbar at that point
    /// - returns: icon image
    public var image: UIImage? {
        get {
            let tempItem = UIBarButtonItem(barButtonSystemItem: self, target: nil, action: nil)
            
            // add to toolbar and render it
            UIToolbar().setItems([tempItem], animated: false)
            
            // got image from real uibutton
            if let itemView = tempItem.value(forKey: "view") as? UIView {
                for view in itemView.subviews {
                    if let button = view as? UIButton, let imageView = button.imageView {
                        UIToolbar().setItems([], animated: false)
                        return imageView.image
                    }
                }
            }
            UIToolbar().setItems([], animated: false)
            return nil
        }
    }
}


//
//  DebugVariableView.swift
//  utils
//
//  Created by Adam Fowler on 02/05/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

import UIKit

/// Protocol for Debug Variables
protocol DebugVariableDisplay {
    /// return name of variable
    func getName() -> String
    
    /// return value of variable as a string
    func getValue() -> String
}

/// Generic class for Debug variable display. It uses a function closure to get the value to display.
public class DebugVariable<T> : DebugVariableDisplay {
    public typealias Value = T
    
    /// initialise class
    /// - parameter name: name of variable to display
    /// - parameter get: function returning value of variable
    public init(name: String, get : @escaping () -> Value) {
        self.name = name
        self.getter = get
    }
    func getName() -> String { return name }
    func getValue() -> String { return String(describing: getter()) }
    
    var getter : () -> Value
    let name : String
}

/// Class to create a UIView that contains a debug variable watch window.
public class DebugVariableView {
    
    /// Initialise class.
    /// - parameter parent: Parent UIView to add debug variable view to
    /// - parameter frame: Rectangle defining position and size of debug view on screen
    public init(parent: UIView, frame: CGRect) {
        #if DEBUG
            view = UIView(frame: frame)
            view.backgroundColor = UIColor(red:0.0,green:0.0,blue:0.0,alpha:0.5)
            parent.addSubview(view!)
            view.isHidden = true
        #endif
    }
    
    /// Call this from your View Controller version of viewWillAppear. It creates all the labels required for displaying
    /// the debug variables and makes the view visible. You should have added all your DebugVariables to the View before 
    /// this point
    public func viewWillAppear() {
        #if DEBUG
            if DebugVariableView.displayDebug == false {
                return
            }
            createLabels()
            //update debug parameters params every 1 second
            timer = Timer.scheduledTimer(timeInterval:0.1, target:self, selector:#selector(self.updateLabels), userInfo:nil, repeats:true)
            updateLabels()
            view.isHidden = false
        #endif
    }
    
    /// Call this from your View Controller version of viewWillDisappear. Hides the view, deletes all the debug variable labels
    /// and kills the update timer
    public func viewWillDisappear() {
        #if DEBUG
            view.isHidden = true
            timer?.invalidate()
            removeLabels()
        #endif
    }
    
    /// Add a variable to the debug variable view
    /// - parameter variable: Debug variable to add
    public func addVariable<T>(_ variable: DebugVariable<T>) {
        #if DEBUG
            variables.append(variable)
        #endif
    }
    
    func createLabels() {
        guard variables.count > 0 else {view.isHidden = true; return}
        
        let width = view.frame.size.width - 12
        let height = view.frame.size.height - 8
        let labelHeight : CGFloat = 18
        let numLabels = Int(height / labelHeight)
        var maxWidth : CGFloat = 0
        
        // create name labels
        for i in 0..<min(numLabels,variables.count) {
            let nameLabel = UILabel(frame: CGRect(x:4, y:4 + CGFloat(i)*labelHeight, width:width/2, height:labelHeight))
            nameLabel.text = variables[i].getName()
            nameLabel.font = nameLabel.font.withSize(12)
            nameLabel.textColor = UIColor.white
            let size = nameLabel.sizeThatFits(nameLabel.frame.size)
            if size.width > maxWidth {
                maxWidth = size.width
            }
            nameLabels.append(nameLabel)
            view.addSubview(nameLabel)
        }
        
        // create value labels
        for i in 0..<min(numLabels,variables.count) {
            let valueLabel = UILabel(frame: CGRect(x:maxWidth+8, y:4 + CGFloat(i)*labelHeight, width:width-maxWidth, height:labelHeight))
            valueLabel.font = valueLabel.font.withSize(12)
            valueLabel.textColor = UIColor.white
            valueLabels.append(valueLabel)
            view.addSubview(valueLabel)
        }
        
        // resize view based on labels
        var bb = CGRect.null
        for subview in view.subviews {
            bb = bb.union(subview.frame)
        }
        bb = bb.insetBy(dx: -4, dy: -4)
        bb.origin.x += view.frame.origin.x
        bb.origin.y += view.frame.origin.y
        view.frame = bb
    }
    
    func removeLabels() {
        for label in nameLabels {
            label.removeFromSuperview()
        }
        for label in valueLabels {
            label.removeFromSuperview()
        }
        nameLabels.removeAll()
        valueLabels.removeAll()
    }
    
    @objc func updateLabels() {
        for i in 0..<min(nameLabels.count,variables.count) {
            valueLabels[i].text = variables[i].getValue()
        }
    }
    
    var variables : [DebugVariableDisplay] = []
    var timer : Timer?
    var nameLabels : [UILabel] = []
    var valueLabels : [UILabel] = []
    var view : UIView!
    
    public static var displayDebug = false
}

// UIViewController extension to add debugView variable
private var key: Void?

extension UIViewController {
    public var debugView: DebugVariableView? {
        get {
            return objc_getAssociatedObject(self, &key) as? DebugVariableView
        }
        
        set {
            objc_setAssociatedObject(self,
                                     &key, newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

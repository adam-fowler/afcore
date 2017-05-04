//
//  DebugViewController.swift
//  utils
//
//  Created by Adam Fowler on 02/05/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

import UIKit

protocol DebugWidgetDisplay {
    func getName() -> String
    func getValue() -> String
}

public class DebugWidget<T> : DebugWidgetDisplay {
    public typealias Value = T
    public init(name: String, get : @escaping () -> Value) {
        self.name = name
        self.getter = get
    }
    func getName() -> String { return name }
    func getValue() -> String { return String(describing: getter()) }
    
    var getter : () -> Value
    let name : String
}

public class DebugView {
    public init(parent: UIView, frame: CGRect) {
        #if DEBUG
            view = UIView(frame: frame)
            view.backgroundColor = UIColor(red:0.0,green:0.0,blue:0.0,alpha:0.5)
            parent.addSubview(view!)
            view.isHidden = true
        #endif
    }
    
    public func viewWillAppear() {
        #if DEBUG
            if DebugView.displayDebug == false {
                return
            }
            createLabels()
            //update debug parameters params every 1 second
            timer = Timer.scheduledTimer(timeInterval:0.1, target:self, selector:#selector(self.updateLabels), userInfo:nil, repeats:true)
            updateLabels()
            view.isHidden = false
        #endif
    }
    
    public func viewWillDisappear() {
        #if DEBUG
            view.isHidden = true
            timer?.invalidate()
            removeLabels()
        #endif
    }
    
    func createLabels() {
        guard widgets.count > 0 else {view.isHidden = true; return}
        
        let width = view.frame.size.width - 12
        let height = view.frame.size.height - 8
        let labelHeight : CGFloat = 18
        let numLabels = Int(height / labelHeight)
        var maxWidth : CGFloat = 0
        
        // create name labels
        for i in 0..<min(numLabels,widgets.count) {
            let nameLabel = UILabel(frame: CGRect(x:4, y:4 + CGFloat(i)*labelHeight, width:width/2, height:labelHeight))
            nameLabel.text = widgets[i].getName()
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
        for i in 0..<min(numLabels,widgets.count) {
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
        for i in 0..<min(nameLabels.count,widgets.count) {
            valueLabels[i].text = widgets[i].getValue()
        }
    }
    
    public func addWidget<T>(_ widget: DebugWidget<T>) {
        #if DEBUG
            widgets.append(widget)
        #endif
    }
    
    var widgets : [DebugWidgetDisplay] = []
    var timer : Timer?
    var nameLabels : [UILabel] = []
    var valueLabels : [UILabel] = []
    var view : UIView!
    
    public static var displayDebug = false
}

// UIViewController extension to add debugView variable
private var key: Void?

extension UIViewController {
    public var debugView: DebugView? {
        get {
            return objc_getAssociatedObject(self, &key) as? DebugView
        }
        
        set {
            objc_setAssociatedObject(self,
                                     &key, newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

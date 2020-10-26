//
//  File.swift
//  
//
//  Created by 游宗諭 on 2020/10/26.
//

import UIKit

public extension StepSlider {
    @IBInspectable var maximunValue: Int {
        get {
            core.maximunValue
        }
        set {
            core.maximunValue = newValue
            setNeedsLayout()
        }
    }
    @IBInspectable var minimunValue: Int {
        get {
            core.minimunValue
        }
        set {
            core.minimunValue = newValue
            setNeedsLayout()
        }
    }
    @IBInspectable var  value: Double  {
        get {
            core.value
        }
        set {
            core.value = newValue
            viewData.animateLayouts = true
            setNeedsLayout()
        }
    }
    @IBInspectable var trackHeight: CGFloat {
        get {
            viewData.trackHeight
        }
        set {
            viewData.trackHeight = newValue
            setNeedsLayout()
        }
    }
    @IBInspectable var  nodeRadius: CGFloat  {
        get {
            viewData.nodeRadius
        }
        set {
            viewData.nodeRadius = newValue
            setNeedsLayout()
        }
    }
    
    @IBInspectable var  thumbRadius:CGFloat {
        get {
            viewData.thumbRadius
        }
        set {
            viewData.thumbRadius = newValue
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var isDotsInteractionEnabled:Bool {
        get {
            viewData.isDotsInteractionEnabled
        }
        set {
            viewData.isDotsInteractionEnabled = newValue
        }
    }
    
      var  trackColor: UIColor {
        get {
            viewData.trackColor
        }
        set {
            viewData.trackColor = newValue
            setNeedsLayout()
        }
    }
    
     var  thumbColor:  UIColor {
        get {
            viewData.thumbColor
        }
        set {
            viewData.thumbColor = newValue
            setNeedsLayout()
        }
    }
    var  thumbImage:  UIImage? {
        get {
            viewData.thumbImage
        }
        set {
            viewData.thumbImage = newValue
            setNeedsLayout()
        }
    }
    
     var labelFont: UIFont  {
        get {
            viewData.labelFont
        }
        set {
            viewData.labelFont = newValue
            setNeedsLayout()
        }
    }
    @IBInspectable var  labelColor: UIColor! {
        get {
            viewData.labelColor
        }
        set {
            viewData.labelColor = newValue
            setNeedsLayout()
        }
    }
    @IBInspectable var labelOffset: CGFloat {
        get {
            viewData.labelOffset
        }
        set {
            viewData.labelOffset = newValue
            setNeedsLayout()
        }
    }
    var  orientation: TextOrientation  {
        get {
            viewData.orientation
        }
        set {
            viewData.orientation = newValue
            setNeedsLayout()
        }
    }
    var  autoAdjustLabel: Bool  {
        get {
            viewData.autoAdjustLabel
        }
        set {
            viewData.autoAdjustLabel = newValue
            setNeedsLayout()
        }
    }
    var  enableHapticFeedback: Bool {
        get {
            viewData.enableHapticFeedback
        }
        set {
            viewData.enableHapticFeedback = newValue
        }
    }
    
    
}

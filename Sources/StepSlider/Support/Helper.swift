//
//  File.swift
//  
//
//  Created by 游宗諭 on 2020/10/18.
//

import Foundation

#if os(macOS)
import Cocoa
public typealias APPControl = NSControl
public typealias APPSlider = NSSlider
public typealias APPColor = NSColor
public typealias APPRect = NSRect
public typealias APPGradient = NSGradient
public typealias APPBezierPath = NSBezierPath
public typealias APPImage = NSImage
public typealias APPFont = NSFont
#elseif os(iOS)
import UIKit
public typealias APPControl = UIControl
public typealias APPColor = UIColor
public typealias APPSlider = UISlider
public typealias APPRect = CGRect
public typealias APPImage = UIImage
public typealias APPGradient = CGGradient
public typealias APPBezierPath = UIBezierPath
public typealias APPFont = UIFont
public typealias Rect = CGRect
public typealias Touch = UITouch
let screenScale = UIScreen.main.scale
#endif

import QuartzCore
func withoutCAAnimation(code: () ->Void)
{
    CATransaction.begin()
    CATransaction.setValue( kCFBooleanTrue, forKey: kCATransactionDisableActions)
    code()
    CATransaction.commit()
}

class Node {
    internal init(shapeLayer: CAShapeLayer, labelNode: CATextLayer? = nil) {
        self.shapeLayer = shapeLayer
        self.textLayer = labelNode
    }
    
    let shapeLayer: CAShapeLayer
    var textLayer: CATextLayer?
    var x = 0.0, y = 0.0
}

import UIKit
extension CGFloat {
    var float: Float {Float(self)}
}

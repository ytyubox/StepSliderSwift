//
//  File.swift
//  
//
//  Created by 游宗諭 on 2020/10/26.
//

import UIKit

struct StepSliderViewInfo {
    var trackHeight: CGFloat = 4
    var  nodeRadius: CGFloat = 5
    var  thumbRadius:CGFloat = 12.5
    var  trackColor: UIColor! = .init(white: 0.41, alpha: 1)
    var  thumbColor:  UIColor! = .white
    var  thumbImage:  UIImage?
    
    var isDotsInteractionEnabled:Bool = true
    
    public var labelFont: UIFont = .systemFont(ofSize: 15)
    public var  labelColor: UIColor!
    public var labelOffset: CGFloat = 20
    public var  orientation: StepSlider.TextOrientation = .down
    public var  autoAdjustLabel: Bool = true
    public var  enableHapticFeedback: Bool = true
    internal var nodeList:[Node] = []
    internal var nodeImages: Dictionary <UIControl.State.RawValue, UIImage> = [:]
    internal var animateLayouts: Bool = true
    internal var maxRadius: CGFloat { max(nodeRadius, thumbRadius) }
    internal var diff: CGFloat { sqrt(max(0, pow(nodeRadius, 2) - pow(trackHeight / 2, 2))) }
    internal var contentSize: CGSize = .zero
}

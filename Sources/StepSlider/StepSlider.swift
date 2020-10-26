//
//  StepSliderHeader.swift
//  StepSliderSwift
//
//  Created by 游宗諭 on 2020/6/9.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import StepSliderCore
import UIKit
@IBDesignable
open class StepSlider: UIControl {
    internal let core = StepSliderCore()
    internal lazy var touchData: TouchData = TouchData()
    internal var viewData: StepSliderViewInfo = StepSliderViewInfo()
    internal var _selectFeedback: FeedbackGenerator = FeedbackGenerator()
    public enum TextOrientation {
        case down, up
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        generalSetup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        generalSetup()
    }
    public var labels: [String] = []
    internal private(set) lazy var track: CAShapeLayer = CAShapeLayer(layer: layer)
    internal private(set) lazy var thumb: CAShapeLayer = CAShapeLayer(layer: layer)
    internal var nodeList:[Node] = []
}
public extension StepSlider {
    
    func setIndex(index: Int, animated: Bool)  {
        viewData.animateLayouts = animated
        value = Double(index)
    }
}


// MARK: - Init helper
internal
extension StepSlider {
    func generalSetup()
    {
        thumb.contentsScale = screenScale
        layer.addSublayer(thumb)
        layer.addSublayer(track)
        viewData.contentSize = bounds.size
        thumbColor = UIColor.white
        layoutLayersAnimated(false)
        setNeedsLayout()
    }
}


extension StepSlider {
    public override var intrinsicContentSize: CGSize
    {
        return viewData.contentSize
    }
}


// MARK: - Draw

extension StepSlider {
    static var minWidth:CGFloat = 44
    static var minHeight:CGFloat = 44
    
    func layoutLayersAnimated(_ animated:Bool)
    {
        let maxRadius = viewData.maxRadius
        let targetValue = roundingIndex()
        let diff = targetValue - value
        let left:Bool = diff < 0
        let width = bounds.size.width
        let height = bounds.size.height
        let contentWidth:CGFloat  = width - 2 * maxRadius
        let stepWidth:CGFloat     = contentWidth / CGFloat(maximunValue - 1)
        
        let sliderHeight = max(maxRadius, trackHeight / 2.0) * 2.0
        let labelsHeight = labelHeightWithMaxWidth(stepWidth) + labelOffset
        let totalHeight:CGFloat   = sliderHeight + labelsHeight
        
        do {
            let width = max(Self.minWidth, bounds.size.width)
            let height = max(Self.minHeight, totalHeight)
            viewData.contentSize = CGSize(width: width, height: height)
            contentSizeChangedUpdateIntrinsicContentSize()
        }
        
        
        var contentFrameY = (height - totalHeight) / 2.0
        
        if (orientation == .up && labels.count > 0) {
            contentFrameY += labelsHeight
        }
        
        let contentFrame = CGRect(
            x: maxRadius,
            y: contentFrameY,
            width: contentWidth,
            height: sliderHeight)
        
        let circleFrameSide:CGFloat = nodeRadius * 2.0
        let sliderDiameter:CGFloat  = thumbRadius * 2.0
        
        let oldPosition:CGPoint = thumb.position
        let oldPath:CGPath?   = track.path
        
        let labelsY:CGFloat = orientation == .up
            ? (bounds.size.height - totalHeight) / 2.0
            : (contentFrame.maxY + labelOffset)
        
        if (!animated) {
            CATransaction.begin()
            CATransaction.setValue(
                kCFBooleanTrue,
                forKey:kCATransactionDisableActions)
        }
        
        thumb.path     = nil
        thumb.contents = nil
        
        if let image = thumbImage {
            thumb.frame.size = CGSize(
                width: max(image.size.width, 44.0),
                height: max(image.size.height, 44.0))
            
            thumb.contents = image.cgImage
            thumb.contentsGravity = CALayerContentsGravity.center
        } else {
            let sliderFrameSide :CGFloat = max(thumbRadius * 2.0, 44.0)
            let sliderDrawRect :CGRect  = CGRect(
                x: (sliderFrameSide - sliderDiameter) / 2.0,
                y: (sliderFrameSide - sliderDiameter) / 2.0,
                width: sliderDiameter,
                height: sliderDiameter)
            
            thumb.frame.size = CGSize(width: sliderFrameSide, height: sliderFrameSide)
                
            thumb.path = UIBezierPath(
                roundedRect: sliderDrawRect,
                cornerRadius: sliderFrameSide)
                .cgPath
            
            thumb.fillColor = thumbColor.cgColor
        }
        thumb.position = CGPoint(x: contentFrame.origin.x + stepWidth * CGFloat(value),
                                 y: contentFrame.midY)
        
        if (animated) {
            let  basicSliderAnimation:CABasicAnimation = CABasicAnimation(keyPath: "position")
            basicSliderAnimation.duration = CATransaction.animationDuration()
            basicSliderAnimation.fromValue = NSValue(cgPoint: oldPosition)
            thumb.add(basicSliderAnimation, forKey: "position")
        }
        track.frame = CGRect(x: contentFrame.origin.x,
                             y: contentFrame.midY - trackHeight / 2.0,
                             width: contentFrame.size.width,
                             height: trackHeight)
        track.path            = makeMinimunTrackPath()
        track.backgroundColor = trackColor.cgColor
        track.fillColor       = tintColor.cgColor
        
        if (animated) {
            let basicTrackAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
            basicTrackAnimation.duration = CATransaction.animationDuration()
            basicTrackAnimation.fromValue = (oldPath)
            track.add(basicTrackAnimation, forKey: "path")
        }
        
        
        cleanupLayersOverMaximunValue()
        let labelWidth = nodeList.first?.textLayer?.bounds.size.width ?? 0
        let currentWidth:CGFloat = labelWidth * (autoAdjustLabel ? 2 : 1)
        if ((currentWidth > 0 && currentWidth != stepWidth) || !(labels.count > 0)) {
            removeLabelLayers()
        }
        
        var animationTimeDiff:TimeInterval = 0
        if (diff > 0) {
            animationTimeDiff = (left
                                  ? CATransaction.animationDuration()
                                  : -CATransaction.animationDuration()) / Double(diff)
        }
        var animationTime:TimeInterval = left
            ? animationTimeDiff
            : CATransaction.animationDuration() + animationTimeDiff
        let circleAnimation:CGFloat      = circleFrameSide / track.frame.size.width
        
        for i in 0..<maximunValue {
            let node:CAShapeLayer = nodeForIndex(index: i)
            let  size = CGSize(
            width: roundForTextDrawing(stepWidth),
            height: labelsHeight - labelOffset)
            let label:CATextLayer? = labelForIndex(index: i,
                                                  size: size)
            
            
            node.bounds.size   = CGSize(width: circleFrameSide, height: circleFrameSide)
            node.position = CGPoint(x: contentFrame.origin.x + stepWidth * CGFloat(i), y: contentFrame.midY)
            
            let nodeImage:CGImage? = self.getNodeImage(node)
            if (nodeImage == nil) {
                node.path = UIBezierPath(roundedRect: node.bounds, cornerRadius: circleFrameSide / 2).cgPath
                node.contents = nil
            } else {
                node.path = nil
            }
            
            label?.position        = CGPoint(x: contentFrame.origin.x + stepWidth * CGFloat(i), y: labelsY)
            label?.foregroundColor = labelColor?.cgColor
            
            if (animated) {
                if let nodeImage = nodeImage {
                    let oldImage:CGImage = node.contents as! CGImage
                    
                    if (oldImage != nodeImage) {
                        animateNodeChanges(
                            node,
                            keyPath:"contents",
                            beginTime:animationTime,
                            duration:TimeInterval(circleAnimation),
                            from:oldImage,
                            to:nodeImage)
                        animationTime += animationTimeDiff
                    }
                } else {
                    let newColor: CGColor? = getNodeColor(node)
                    let oldColor: CGColor? = node.fillColor
                    
                    if (newColor == oldColor) {
                        animateNodeChanges(
                            node,
                            keyPath:"fillColor",
                            beginTime:animationTime,
                            duration:TimeInterval(circleAnimation),
                            from:oldColor,
                            to:newColor)
                        animationTime += animationTimeDiff
                    }
                }
            } else {
                if let nodeImage = nodeImage {
                    node.contents = nodeImage
                } else {
                    node.fillColor = getNodeColor(node)
                }
            }
            
        }
        
        if (!animated) {
            CATransaction.commit()
        }
        
        thumb.removeFromSuperlayer()
        layer.addSublayer(thumb)
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        layoutLayersAnimated(true)
        viewData.animateLayouts = false
    }
}
// MARK: - Helper


extension StepSlider {
    static let kTrackAnimation = "kTrackAnimation"
    // MARK: - Helpers
    
    func
    animateNodeChanges(
        _ node: CAShapeLayer,
        keyPath:String,
        beginTime:TimeInterval,
        duration:TimeInterval,
        from fromValue: Any?,
        to toValue: Any?
    )
    {
        let basicNodeAnimation = CABasicAnimation(keyPath: StepSlider.kTrackAnimation)
        
        basicNodeAnimation.fillMode  = .backwards
        basicNodeAnimation.beginTime = CACurrentMediaTime() + beginTime
        basicNodeAnimation.duration  = CATransaction.animationDuration() * duration
        basicNodeAnimation.keyPath   = keyPath
        basicNodeAnimation.fromValue = fromValue
        basicNodeAnimation.toValue   = toValue
        
        node.add(basicNodeAnimation, forKey: Self.kTrackAnimation)
        node.setValue(basicNodeAnimation.toValue, forKey: basicNodeAnimation.keyPath!)
    }
    
    func cleanupLayersOverMaximunValue()
    {
        if (nodeList.count > maximunValue) {
            
            for i in maximunValue..<nodeList.count  {
                nodeList[i].shapeLayer.removeFromSuperlayer()
                nodeList[i].textLayer?.removeFromSuperlayer()
            }
        }
    }
    
    func labelHeightWithMaxWidth(_ maxWidth:CGFloat) -> CGFloat {
        guard !labels.isEmpty else {
            return 0
        }
        var labelHeight: CGFloat = 0
        let maxRadius = viewData.maxRadius
        for i in labels.indices {
            let size: CGSize
            if (autoAdjustLabel && (i == 0 || i == labels.count - 1)) {
                size = CGSize(
                    width: roundForTextDrawing(maxWidth) / 2 + maxRadius,
                    height: CGFloat.greatestFiniteMagnitude)
            } else {
                size = CGSize(width: roundForTextDrawing(maxWidth), height: CGFloat.greatestFiniteMagnitude)
            }
            
            let height:CGFloat =
                labels[i].boundingRect(
                    with: size,
                    options:.usesLineFragmentOrigin,
                    attributes:[NSAttributedString.Key.font : labelFont],
                    context:nil)
                .size.height
            labelHeight = max(ceil(height), labelHeight)
        }
        return labelHeight
        
    }
    
    
    //
    func makeMinimunTrackPath() -> CGPath
    {
        var fillRect:CGRect = track.bounds
        fillRect.size.width = thumbPosition()
        
        return UIBezierPath(rect: fillRect).cgPath
    }
    ///  return _sliderCircleLayer.position.x - maxRadius;
    func thumbPosition() -> CGFloat
    {
        return thumb.position.x - viewData.maxRadius
    }
    
    func getNodePosition(_ node:CAShapeLayer) -> CGFloat
    {
        return node.position.x - viewData.maxRadius
    }
    
    func calculateIndex() -> CGFloat
    {
        let width = track.bounds.size.width
        if width == 0 {return 0}
        return thumbPosition() / ( width / CGFloat(maximunValue - 1))
    }
    func roundingIndex() -> Double {
        return Double(round(calculateIndex()))
    }
    
    func nodeIsSeleceted(_ node:CAShapeLayer) -> Bool
    {
        return thumbPosition() + viewData.diff >= getNodePosition(node)
    }
}

// MARK: - Track node
extension StepSlider {
    
    func getNodeColor(_ node:CAShapeLayer) -> CGColor
    {
        return nodeIsSeleceted(node)
            ? tintColor.cgColor
            : trackColor.cgColor
    }
    
    func getNodeImage(_ node:CAShapeLayer) -> CGImage?
    {
        return nodeImageForState(
            nodeIsSeleceted(node)
                ? .selected
                : .normal
        )?.cgImage
    }
    
    func setNodeImage(image:UIImage ,for state: UIControl.State)
    {
        viewData.nodeImages[state.rawValue] = image
        setNeedsLayout()
    }
    
    func nodeImageForState(_ state:UIControl.State) -> UIImage?
    {
        return viewData.nodeImages[state.rawValue] ?? viewData.nodeImages[State.normal.rawValue]
    }
    
}

// MARK: - Texts

extension StepSlider {
    
    func makeTextLayer(_ size:CGSize, index:Int) -> CATextLayer
    {
        precondition(nodeList.indices.contains(index))
        if let textLayer = nodeList[index].textLayer {
            return textLayer
        }
        let (size, anchorPoint, alignmentMode) = layerComponents(size: size, index: index)
        
        let textLayer:CATextLayer = CATextLayer()
        textLayer.alignmentMode =  alignmentMode
        textLayer.isWrapped     = true
        textLayer.contentsScale = screenScale
        textLayer.anchorPoint   = anchorPoint
        textLayer.font     = labelFont.cgFont
        textLayer.fontSize = labelFont.pointSize
        textLayer.string = labels[index]
        textLayer.bounds.size = CGSize(width: size.width, height: size.height)
        
        layer.addSublayer(textLayer)
        nodeList[index].textLayer =  textLayer
        
        return textLayer
    }
    
    func removeLabelLayers()
    {
        for node in nodeList {
            node.textLayer?.removeFromSuperlayer()
            node.textLayer = nil
        }
    }
    
    
    func roundForTextDrawing(_ value: CGFloat) -> CGFloat
    {
        return floor(value * screenScale) / screenScale
    }
    
    @available(*,unavailable)
    func setLabels(labels: [String])
    {
        precondition(labels.count != 1, "Labels count can not be equal to 1!")
        precondition(labels.count == maximunValue-minimunValue+1)
        
        self.labels = labels
        maximunValue = labels.count
        
        removeLabelLayers()
        sendActions(for: .valueChanged)
    }
    
}


// MARK: - Helper
fileprivate
extension StepSlider {
    func nodeForIndex(index: Int) -> CAShapeLayer {
        let shape:CAShapeLayer
        if (index < nodeList.count) {
            shape = nodeList[index].shapeLayer
        } else {
            shape = CAShapeLayer( layer: layer)
            shape.actions?["fillColor"] = nil
            
            layer.addSublayer(shape)
            
            nodeList.append(Node(shapeLayer: shape))
        }
        return shape
    }
    func labelForIndex(index: Int, size: @autoclosure () -> CGSize) -> CATextLayer? {
        if (labels.count > 0) {
            return makeTextLayer(size(), index: index)
        }
        return nil
    }
  
    func contentSizeChangedUpdateIntrinsicContentSize() {
        if (bounds.size.equalTo(viewData.contentSize) == false) {
            if (constraints.count > 0) {
                invalidateIntrinsicContentSize()
            } else {
                frame.size = viewData.contentSize
            }
        }
    }
    private func layerComponents(size: CGSize, index: Int) -> (CGSize, CGPoint, CATextLayerAlignmentMode) {
        let maxRadius = viewData.maxRadius
        var size = size
        var anchorPoint:CGPoint = CGPoint(x: 0.5, y: 0)
        var alignmentMode = CATextLayerAlignmentMode.center
        
        if (autoAdjustLabel) {
            if (index == 0) {
                alignmentMode = CATextLayerAlignmentMode.left
                size.width = size.width / 2 + maxRadius
                anchorPoint.x = maxRadius / size.width
            } else if (index == labels.count - 1) {
                alignmentMode = CATextLayerAlignmentMode.right
                size.width = size.width / 2 + maxRadius
                anchorPoint.x = 1 - maxRadius / size.width
            }
        }
        return (size, anchorPoint, alignmentMode)
    }
}
extension UIFont {
    var cgFont:CGFont? {
        return CGFont.init(fontName as CFString)
    }
}

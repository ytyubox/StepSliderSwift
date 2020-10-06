//
//  SteperSlider.swift
//  StepSliderSwift
//
//  Created by 游宗諭 on 2020/6/9.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import UIKit
import QuartzCore
private func withoutCAAnimation(code: () ->Void)
{
    CATransaction.begin()
    CATransaction.setValue( kCFBooleanTrue, forKey: kCATransactionDisableActions)
    code()
    CATransaction.commit()
}
// MARK: - Init helper
internal
extension StepSlider {
    func generalSetup()
    {
        self.addLayers()
        maxCount = 4
        trackColor = UIColor.init(white: 0.41, alpha: 1)
        sliderCircleColor = UIColor.white
        self.updateMaxRadius()
        self.layoutLayersAnimated(false)
        self.setNeedsLayout()
    }
    
    func addLayers()
    {
        dotsInteractionEnabled = true
        _trackCirclesArray = []
        _trackLabelsArray  = []
        _trackCircleImages = [:]
        
        _trackLayer = CAShapeLayer(layer: layer)
        _sliderCircleLayer = CAShapeLayer(layer: layer)
        _sliderCircleLayer.contentsScale = UIScreen.main.scale
        
        self.layer.addSublayer(_sliderCircleLayer)
        self.layer.addSublayer(_trackLayer)
        
        labelFont = UIFont.systemFont(ofSize: 15)
        contentSize = self.bounds.size
    }
    
}


extension StepSlider {
    public override var intrinsicContentSize: CGSize
    {
        return contentSize
    }
}


// MARK: - Draw

extension StepSlider {
    
    public override func prepareForInterfaceBuilder()
    {
        self.updateMaxRadius()
        super.prepareForInterfaceBuilder()
    }
    
    
    func layoutLayersAnimated(_ animated:Bool)
    {
        let indexDiff:Int = Int(abs(round(self.indexCalculate()) - CGFloat(self.index)))
        let left:Bool = (Int(round(self.indexCalculate())) - self.index) < 0
        
        let contentWidth:CGFloat  = self.bounds.size.width - 2 * maxRadius
        let stepWidth:CGFloat     = contentWidth / CGFloat(self.maxCount - 1)
        
        let sliderHeight:CGFloat  = fmax((maxRadius), (self.trackHeight / 2.0)) * 2.0
        let labelsHeight:CGFloat  = self.labelHeightWithMaxWidth(stepWidth) + self.labelOffset
        let totalHeight:CGFloat   = sliderHeight + labelsHeight
        
        contentSize = CGSize(width: fmax(44.0, self.bounds.size.width), height: fmax(44.0, totalHeight))
        if (!self.bounds.size.equalTo(contentSize)) {
            if (self.constraints.count > 0) {
                self.invalidateIntrinsicContentSize()
            } else {
                var newFrame:CGRect = self.frame
                newFrame.size = contentSize
                self.frame = newFrame
            }
        }
        
        var contentFrameY:CGFloat = (self.bounds.size.height - totalHeight) / 2.0
        
        if (self.labelOrientation == .up && self.labels.count > 0) {
            contentFrameY += labelsHeight
        }
        
        let contentFrame:CGRect = CGRect(x: maxRadius, y: contentFrameY, width: contentWidth, height: sliderHeight)
        
        let circleFrameSide:CGFloat = self.trackCircleRadius * 2.0
        let sliderDiameter:CGFloat  = self.sliderCircleRadius * 2.0
        
        let oldPosition:CGPoint = _sliderCircleLayer.position
        let oldPath:CGPath?   = _trackLayer.path
        
        let labelsY:CGFloat = self.labelOrientation == .up
            ? (self.bounds.size.height - totalHeight) / 2.0
            : (contentFrame.maxY + self.labelOffset)
        
        if (!animated) {
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey:kCATransactionDisableActions)
        }
        
        _sliderCircleLayer.path     = nil
        _sliderCircleLayer.contents = nil
        
        if ((self.sliderCircleImage) != nil) {
            _sliderCircleLayer.frame    = CGRect(
                x: 0.0,
                y: 0.0,
                width: fmax(self.sliderCircleImage!.size.width, 44.0),
                height: fmax(self.sliderCircleImage!.size.height, 44.0))
            _sliderCircleLayer.contents = self.sliderCircleImage?.cgImage
            _sliderCircleLayer.contentsGravity = CALayerContentsGravity.center
        } else {
            let sliderFrameSide :CGFloat = fmax(self.sliderCircleRadius * 2.0, 44.0)
            let sliderDrawRect :CGRect  = CGRect(
                x: (sliderFrameSide - sliderDiameter) / 2.0,
                y: (sliderFrameSide - sliderDiameter) / 2.0,
                width: sliderDiameter,
                height: sliderDiameter)
            
            _sliderCircleLayer.frame     = CGRect(
                x: 0.0,
                y: 0.0,
                width: sliderFrameSide,
                height: sliderFrameSide)
            _sliderCircleLayer.path      = UIBezierPath(roundedRect: sliderDrawRect,
                cornerRadius: sliderFrameSide).cgPath
                
    
            _sliderCircleLayer.fillColor = self.sliderCircleColor.cgColor
        }
        _sliderCircleLayer.position = CGPoint(x: contentFrame.origin.x + stepWidth * CGFloat(self.index),
                                              y: contentFrame.midY)
        
        if (animated) {
            let  basicSliderAnimation:CABasicAnimation = CABasicAnimation(keyPath: "position")
            basicSliderAnimation.duration = CATransaction.animationDuration()
            basicSliderAnimation.fromValue = NSValue(cgPoint: oldPosition)
            _sliderCircleLayer.add(basicSliderAnimation, forKey: "position")
        }
        
        _trackLayer.frame = CGRect(x: contentFrame.origin.x,
                                   y: contentFrame.midY - self.trackHeight / 2.0,
                                   width: contentFrame.size.width,
                                   height: self.trackHeight)
        _trackLayer.path            = self.fillingPath()
        _trackLayer.backgroundColor = self.trackColor.cgColor
        _trackLayer.fillColor       = self.tintColor.cgColor
        
        if (animated) {
            let basicTrackAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
            basicTrackAnimation.duration = CATransaction.animationDuration()
            basicTrackAnimation.fromValue = (oldPath)
            _trackLayer.add(basicTrackAnimation, forKey: "path")
        }
        
        
        _trackCirclesArray = self.clearExcessLayers(layers: _trackCirclesArray)
        
        let currentWidth:CGFloat = self.adjustLabel
            ? (_trackLabelsArray.first?.bounds.size.width ?? 0) * 2
            :  _trackLabelsArray.first?.bounds.size.width ?? 0
        if ((currentWidth > 0 && currentWidth != stepWidth) || !(self.labels.count > 0)) {
            self.removeLabelLayers()
        }
        
        var animationTimeDiff:TimeInterval = 0
        if (indexDiff > 0) {
            animationTimeDiff = (left
                ? CATransaction.animationDuration()
                : -CATransaction.animationDuration()) / Double(indexDiff)
        }
        var animationTime:TimeInterval = left
            ? animationTimeDiff
            : CATransaction.animationDuration() + animationTimeDiff
        let circleAnimation:CGFloat      = circleFrameSide / _trackLayer.frame.size.width
        
        for i in 0..<self.maxCount {
            let trackCircle:CAShapeLayer
            var trackLabel:CATextLayer?
            
            if (self.labels.count > 0) {
                trackLabel = self.textLayerWithSize(CGSize(width: self.roundForTextDrawing(stepWidth),height: labelsHeight - self.labelOffset), index: Int(i))
            }
            
            if (i < _trackCirclesArray.count) {
                trackCircle = _trackCirclesArray[Int(i)]
            } else {
                trackCircle = CAShapeLayer( layer: layer)
                trackCircle.actions?["fillColor"] = nil
                
                self.layer.addSublayer(trackCircle)
                
                _trackCirclesArray.append(trackCircle)
            }
            
            
            trackCircle.bounds   = CGRect(x: 0.0, y: 0.0, width: circleFrameSide, height: circleFrameSide)
            trackCircle.position = CGPoint(x: contentFrame.origin.x + stepWidth * CGFloat(i), y: contentFrame.midY)
            
            let trackCircleImage:CGImage? = self.trackCircleImage(trackCircle)
            if (trackCircleImage == nil) {
                trackCircle.path = UIBezierPath(roundedRect: trackCircle.bounds, cornerRadius: circleFrameSide / 2).cgPath
                trackCircle.contents = nil
            } else {
                trackCircle.path = nil
            }
            
            trackLabel?.position        = CGPoint(x: contentFrame.origin.x + stepWidth * CGFloat(i), y: labelsY)
            trackLabel?.foregroundColor = self.labelColor.cgColor
            
            if (animated) {
                if let trackCircleImage = trackCircleImage {
                    let oldImage:CGImage = trackCircle.contents as! CGImage
                    
                    if (oldImage != trackCircleImage) {
                        self.animateTrackCircleChanges(
                            trackCircle,
                            keyPath:"contents",
                            beginTime:animationTime,
                            duration:TimeInterval(circleAnimation),
                            from:oldImage,
                            to:trackCircleImage)
                        animationTime += animationTimeDiff
                    }
                } else {
                    let newColor: CGColor? = self.trackCircleColor(trackCircle)
                    let oldColor: CGColor? = trackCircle.fillColor
                    
                    if (newColor == oldColor) {
                        self.animateTrackCircleChanges(
                            trackCircle,
                            keyPath:"fillColor",
                            beginTime:animationTime,
                            duration:TimeInterval(circleAnimation),
                            from:oldColor,
                            to:newColor)
                        animationTime += animationTimeDiff
                    }
                }
            } else {
                if let trackCircleImage = trackCircleImage {
                    trackCircle.contents = trackCircleImage
                } else {
                    trackCircle.fillColor = self.trackCircleColor(trackCircle)
                }
            }
            
        }
        
        if (!animated) {
            CATransaction.commit()
        }
        
        _sliderCircleLayer.removeFromSuperlayer()
        self.layer.addSublayer(_sliderCircleLayer)
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutLayersAnimated(true)
        animateLayouts = false
    }
}
// MARK: - Helper


extension StepSlider {
    static let kTrackAnimation = "kTrackAnimation"
    // MARK: - Helpers
    
    func
        animateTrackCircleChanges(
        _ trackCircle: CAShapeLayer,
        keyPath:String,
        beginTime:TimeInterval,
        duration:TimeInterval,
        from fromValue: Any?,
        to toValue: Any?
    )
    {
        let basicTrackCircleAnimation = CABasicAnimation(keyPath: StepSlider.kTrackAnimation)
        
        basicTrackCircleAnimation.fillMode  = .backwards
        basicTrackCircleAnimation.beginTime = CACurrentMediaTime() + beginTime
        basicTrackCircleAnimation.duration  = CATransaction.animationDuration() * duration
        basicTrackCircleAnimation.keyPath   = keyPath
        basicTrackCircleAnimation.fromValue = fromValue
        basicTrackCircleAnimation.toValue   = toValue
        
        trackCircle.add(basicTrackCircleAnimation, forKey: Self.kTrackAnimation)
        trackCircle.setValue(basicTrackCircleAnimation.toValue, forKey: basicTrackCircleAnimation.keyPath!)
    }
    
    func clearExcessLayers(layers:Array<CAShapeLayer>) -> Array<CAShapeLayer>
        
    {
        if (layers.count > self.maxCount) {
            
            for i in Int(self.maxCount)..<layers.count  {
                layers[i].removeFromSuperlayer()
            }
            
            return Array(layers[0..<Int(self.maxCount)])
        }
        
        return layers
    }
    
    func labelHeightWithMaxWidth(_ maxWidth:CGFloat) -> CGFloat {
        
        if (self.labels.count != 0) {
            var  labelHeight: CGFloat = 0
            
            for i in 0..<labels.count {
                var size: CGSize
                if (self.adjustLabel && (i == 0 || i == self.labels.count - 1)) {
                    size = CGSize(width: self.roundForTextDrawing(maxWidth) / 2 + maxRadius,
                                  height: CGFloat.greatestFiniteMagnitude)
                } else {
                    size = CGSize(width: self.roundForTextDrawing(maxWidth), height: CGFloat.greatestFiniteMagnitude)
                }
                
                let height:CGFloat =
                    self.labels[i].boundingRect(
                        with: size,
                        options:.usesLineFragmentOrigin,
                        attributes:[NSAttributedString.Key.font : self.labelFont],
                        context:nil)
                        .size.height
                labelHeight = fmax(ceil(height), labelHeight)
            }
            return labelHeight
        }
        
        return 0
    }
    //
    //    /*
    //     Calculate distance from trackCircle center to point where circle cross track line.
    //     */
    func updateDiff()
    {
        diff = sqrt(fmax(0.0, pow(self.trackCircleRadius, 2.0) - pow(self.trackHeight / 2.0, 2.0)))
    }
    
    func updateMaxRadius()
    {
        maxRadius = fmax(self.trackCircleRadius, self.sliderCircleRadius)
    }
    
    func updateIndex()
    {
        precondition(self.maxCount > 1, "Elements count must be greater than 1!")
        if (index > (self.maxCount - 1)) {
            index = Int(self.maxCount - 1)
            self.sendActions(for: .valueChanged)
        }
    }
    //
    func fillingPath() -> CGPath
    {
        var fillRect:  CGRect     = _trackLayer.bounds
        fillRect.size.width = self.sliderPosition()
        
        return UIBezierPath(rect: fillRect).cgPath
    }
    ///  return _sliderCircleLayer.position.x - maxRadius;
    func sliderPosition() -> CGFloat
    {
        return _sliderCircleLayer.position.x - maxRadius
    }
    
    func trackCirclePosition(_ trackCircle:CAShapeLayer) -> CGFloat
    {
        return trackCircle.position.x - maxRadius
    }
    
    ///
    ///```objective-c
    ///- (CGFloat)indexCalculate
    /// {
    ///    return self.sliderPosition / (_trackLayer.bounds.size.width / (self.maxCount - 1));
    ///}
    ///```
    ///
    func indexCalculate() -> CGFloat
    {
        let width = _trackLayer.bounds.size.width
        if width == 0 {return 0}
        return self.sliderPosition() / ( width / CGFloat(self.maxCount - 1))
    }
    
    func trackCircleIsSeleceted(_ trackCircle:CAShapeLayer) -> Bool
    {
        return self.sliderPosition() + diff >= self.trackCirclePosition(trackCircle)
    }
}

// MARK: - Track circle
extension StepSlider {
    
    
    func trackCircleColor(_ trackCircle:CAShapeLayer) -> CGColor
    {
        return self.trackCircleIsSeleceted(trackCircle)
            ? self.tintColor.cgColor
            : self.trackColor.cgColor
    }
    
    func trackCircleImage(_ trackCircle:CAShapeLayer) -> CGImage?
    {
        return trackCircleImageForState(
            self.trackCircleIsSeleceted(trackCircle)
                ? .selected
                : .normal
        )?.cgImage
    }
    
    func _setTrackCircleImage(image:UIImage ,for state: UIControl.State)
    {
        _trackCircleImages[state.rawValue] = image
        self.setNeedsLayout()
    }
    
    func trackCircleImageForState(_ state:UIControl.State) -> UIImage?
    {
        return _trackCircleImages[state.rawValue] ?? _trackCircleImages[State.normal.rawValue]
    }
    
}


// MARK: - Touches

extension StepSlider {
    
    
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer:UIGestureRecognizer) -> Bool
    {
        guard gestureRecognizer is UIPanGestureRecognizer else  {
            return false
        }
        let  position:CGPoint = gestureRecognizer.location(in: self)
        return !self.bounds.contains(position)
        
        
    }
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        
        startTouchPosition = touch.location(in: self)
        startSliderPosition = _sliderCircleLayer.position
        
        if (self.enableHapticFeedback && !ProcessInfo.processInfo.isLowPowerModeEnabled) {
            _selectFeedback = UIImpactFeedbackGenerator()
        }
        
        _selectFeedback?.prepare()
        if (_sliderCircleLayer.frame.contains(startTouchPosition)) {
            return true
        } else if (self.isDotsInteractionEnabled) {
            for i in 0 ..< _trackCirclesArray.count {
                let dot:CALayer = _trackCirclesArray[i]
                
                let dotRadiusDiff:CGFloat = 22 - self.trackCircleRadius
                let frameToCheck:CGRect = dotRadiusDiff > 0
                    ? dot.frame.insetBy(dx: -dotRadiusDiff, dy: -dotRadiusDiff)
                    : dot.frame
                
                if (frameToCheck.contains(startTouchPosition)) {
                    let  oldIndex: UInt = UInt(index)
                    
                    index = i
                    
                    if (oldIndex != index) {
                        self.sendActions(for: .valueChanged)
                        _selectFeedback!.impactOccurred()
                        _selectFeedback!.prepare()
                    }
                    animateLayouts = true
                    self.setNeedsLayout()
                    return false
                }
            }
            return false
        }
        return false
    }
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let position:CGFloat = startSliderPosition.x - (startTouchPosition.x - touch.location(in: self).x)
        let limitedPosition:CGFloat = fmin(fmax(maxRadius, position), self.bounds.size.width - maxRadius)
        
        withoutCAAnimation{
            self._sliderCircleLayer.position = CGPoint(
                x: limitedPosition,
                y: self._sliderCircleLayer.position.y)
            self._trackLayer.path = self.fillingPath()
            
            let index = Int((self.sliderPosition() + self.diff) / (self._trackLayer.bounds.size.width / CGFloat(self.maxCount - 1)))
            if (self.index != index) {
                for trackCircle in self._trackCirclesArray {
                    let  trackCircleImage:CGImage? = self.trackCircleImage(trackCircle)
                    
                    if let trackCircleImage = trackCircleImage {
                        trackCircle.contents = trackCircleImage
                    } else {
                        trackCircle.fillColor = self.trackCircleColor(trackCircle)
                    }
                }
                self.index = index
                self.sendActions(for: .valueChanged)
                self._selectFeedback?.impactOccurred()
                self._selectFeedback?.prepare()
            }
        }
        
        return true
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        self.endTouches()
    }
    public override func cancelTracking(with event: UIEvent?) {
        self.endTouches()
    }
    
    func endTouches()
    {
        let newIndex = Int(round(self.indexCalculate()))
        
        if (newIndex != index) {
            index = Int(newIndex)
            self.sendActions(for: .valueChanged)
        }
        
        animateLayouts = true
        self.setNeedsLayout()
        _selectFeedback = nil
    }
    
}


// MARK: - Texts

extension StepSlider {
    
    
    func
        textLayerWithSize(_ size:CGSize, index:Int) -> CATextLayer
    {
        var size = size
        if (index >= _trackLabelsArray.count) {
            let trackLabel:CATextLayer = CATextLayer()
            
            var anchorPoint:CGPoint = CGPoint(x: 0.5, y: 0)
            var alignmentMode = CATextLayerAlignmentMode.center
            
            if (self.adjustLabel) {
                if (index == 0) {
                    alignmentMode = CATextLayerAlignmentMode.left
                    size.width = size.width / 2 + maxRadius
                    anchorPoint.x = maxRadius / size.width
                } else if (index == self.labels.count - 1) {
                    alignmentMode = CATextLayerAlignmentMode.right
                    size.width = size.width / 2 + maxRadius
                    anchorPoint.x = 1 - maxRadius / size.width
                }
            }
            
            trackLabel.alignmentMode =  alignmentMode
            trackLabel.isWrapped     = true
            trackLabel.contentsScale = UIScreen.main.scale
            trackLabel.anchorPoint   = anchorPoint
            
            let fontName:CFString = self.labelFont.fontName as CFString
            
            let  fontRef: CGFont? = CGFont(fontName)
            
            trackLabel.font     = fontRef
            trackLabel.fontSize = self.labelFont.pointSize
            
            trackLabel.string = self.labels[index]
            trackLabel.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            self.layer.addSublayer(trackLabel)
            _trackLabelsArray.append(trackLabel)
            
            return trackLabel
        } else {
            return _trackLabelsArray[index]
        }
    }
    func removeLabelLayers()
    {
        for label in _trackLabelsArray {
            label.removeFromSuperlayer()
        }
        _trackLabelsArray.removeAll(keepingCapacity: true)
    }
    
    
    func roundForTextDrawing(_ value: CGFloat) -> CGFloat
    {
        return floor(value * UIScreen.main.scale) / UIScreen.main.scale
    }
}

// MARK: - Access methods
extension StepSlider {
    
    
    
    func _setIndex(index:Int, animated:Bool)
    {
        animateLayouts = animated
        self.index = index
    }
    public override var tintColor: UIColor! {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    func setLabels(labels: Array<String> )
    {
        precondition(labels.count != 1, "Labels count can not be equal to 1!")
        if (self.labels != labels) {
            self.labels = labels
            
            if (self.labels.count > 0) {
                maxCount = UInt(labels.count)
                
            }
            
            self.updateIndex()
            self.removeLabelLayers()
            self.setNeedsLayout()
        }
    }
    
    func setMaxCount(_ maxCount:UInt) {
        
        if (self.maxCount != maxCount && self.labels.count != 0) {
            self.maxCount = maxCount
            
            self.updateIndex()
            self.setNeedsLayout()
        }
    }
    
}

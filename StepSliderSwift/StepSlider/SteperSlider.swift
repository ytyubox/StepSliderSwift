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

internal
extension StepSlider {
    func addLayers()
    {
        dotsInteractionEnabled = true
        _trackCirclesArray =
            []
        _trackLabelsArray  = []
        _trackCircleImages = [:]
        
        _trackLayer = CAShapeLayer()
        _sliderCircleLayer = CAShapeLayer()
        _sliderCircleLayer.contentsScale = UIScreen.main.scale
        
        self.layer.addSublayer(_sliderCircleLayer)
        self.layer.addSublayer(_trackLayer)
        
        labelFont = UIFont.systemFont(ofSize: 15)
        contentSize = self.bounds.size
    }
    func generalSetup()
    {
        self.addLayers()
        
        if (maxCount == 0) {
            maxCount = 4
        }
        if (trackHeight == 0) {
            trackHeight = 4
        }
        if (trackCircleRadius == 0) {
            trackCircleRadius = 5
        }
        if (sliderCircleRadius == 0) {
            sliderCircleRadius = 12.5
        }
        if (labelOffset == 0) {
            labelOffset = 20
        }
        if (trackColor == nil) {
            trackColor = UIColor.init(white: 0.41, alpha: 1)
        }
        if (sliderCircleColor == nil) {
            sliderCircleColor = UIColor.white
        }
        if (labelColor != nil) {
            labelColor = UIColor.white
        }
        
        self.updateMaxRadius()
        self.setNeedsLayout()
    }
    
}


extension StepSlider {
    public override var intrinsicContentSize: CGSize
    {
        return contentSize
    }
}


// MARK: - Draw


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
        assert(self.maxCount > 1, "Elements count must be greater than 1!")
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
    
    func sliderPosition() -> CGFloat
    {
        return _sliderCircleLayer.position.x - maxRadius
    }
    
    func trackCirclePosition(_ trackCircle:CAShapeLayer) -> CGFloat
    {
        return trackCircle.position.x - maxRadius
    }
    
    func indexCalculate() -> CGFloat
    {
        return self.sliderPosition() / (_trackLayer.bounds.size.width / CGFloat(self.maxCount - 1))
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
                ? .selected//UIControlStateSelected
                : .normal
        )
            .cgImage
    }
    
    func setTrackCircleImage(_ image:UIImage ,forState state: UIControl.Event)
    {
        _trackCircleImages[state.rawValue] = image
        self.setNeedsLayout()
    }
    
    func trackCircleImageForState(_ state:UIControl.State) -> UIImage
    {
        return _trackCircleImages[state.rawValue] ?? _trackCircleImages[State.normal.rawValue]!
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

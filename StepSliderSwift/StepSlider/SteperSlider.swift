//
//  SteperSlider.swift
//  StepSliderSwift
//
//  Created by 游宗諭 on 2020/6/9.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import UIKit
import QuartzCore
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
    
    func roundForTextDrawing(_ value: CGFloat) -> CGFloat
    {
        return floor(value * UIScreen.main.scale) / UIScreen.main.scale
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
        basicTrackCircleAnimation.beginTime = CACurrentMediaTime() + beginTime;
        basicTrackCircleAnimation.duration  = CATransaction.animationDuration() * duration
        basicTrackCircleAnimation.keyPath   = keyPath;
        basicTrackCircleAnimation.fromValue = fromValue;
        basicTrackCircleAnimation.toValue   = toValue;
        
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
        
        return layers;
    }
    
    func labelHeightWithMaxWidth(_ maxWidth:CGFloat) -> CGFloat {
        
        if (self.labels.count != 0) {
            var  labelHeight: CGFloat = 0
            
            for i in 0..<labels.count {
                var size: CGSize
                if (self.adjustLabel && (i == 0 || i == self.labels.count - 1)) {
                    size = CGSize(width: self.roundForTextDrawing(maxWidth) / 2 + maxRadius,
                                  height: CGFloat.greatestFiniteMagnitude);
                } else {
                    size = CGSize(width: self.roundForTextDrawing(maxWidth), height: CGFloat.greatestFiniteMagnitude);
                }
                
                let height:CGFloat =
                    self.labels[i].boundingRect(
                        with: size,
                        options:.usesLineFragmentOrigin,
                        attributes:[NSAttributedString.Key.font : self.labelFont],
                        context:nil)
                        .size.height
                labelHeight = fmax(ceil(height), labelHeight);
            }
            return labelHeight;
        }
        
        return 0;
    }
    //
    //    /*
    //     Calculate distance from trackCircle center to point where circle cross track line.
    //     */
         func updateDiff()
        {
            diff = sqrt(fmax(0.0, pow(self.trackCircleRadius, 2.0) - pow(self.trackHeight / 2.0, 2.0)));
        }
    
        func updateMaxRadius()
        {
            maxRadius = fmax(self.trackCircleRadius, self.sliderCircleRadius);
        }
    
        func updateIndex()
        {
            assert(self.maxCount > 1, "Elements count must be greater than 1!")
            if (index > (self.maxCount - 1)) {
                index = Int(self.maxCount - 1);
                self.sendActions(for: .valueChanged)
            }
        }
    //
    //    - (CGPathRef)fillingPath
    //    {
    //        CGRect fillRect     = _trackLayer.bounds;
    //        fillRect.size.width = self.sliderPosition;
    //
    //        return [UIBezierPath bezierPathWithRect:fillRect].CGPath;
    //    }
    //
    //    - (CGFloat)sliderPosition
    //    {
    //        return _sliderCircleLayer.position.x - maxRadius;
    //    }
    //
    //    - (CGFloat)trackCirclePosition:(CAShapeLayer *)trackCircle
    //    {
    //        return trackCircle.position.x - maxRadius;
    //    }
    //
    //    - (CGFloat)indexCalculate
    //    {
    //        return self.sliderPosition / (_trackLayer.bounds.size.width / (self.maxCount - 1));
    //    }
    //
    //    - (BOOL)trackCircleIsSeleceted:(CAShapeLayer *)trackCircle
    //    {
    //        return self.sliderPosition + diff >= [self trackCirclePosition:trackCircle];
    //    }
}

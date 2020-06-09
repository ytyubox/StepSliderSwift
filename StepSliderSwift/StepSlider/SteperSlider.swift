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
    
    func updateMaxRadius()
    {
        maxRadius = max(self.trackCircleRadius, self.sliderCircleRadius)
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
        basicTrackCircleAnimation.beginTime = CACurrentMediaTime() + beginTime;
        basicTrackCircleAnimation.duration  = CATransaction.animationDuration() * duration
        basicTrackCircleAnimation.keyPath   = keyPath;
        basicTrackCircleAnimation.fromValue = fromValue;
        basicTrackCircleAnimation.toValue   = toValue;
        
        //
        //        [trackCircle addAnimation:basicTrackCircleAnimation forKey:kTrackAnimation];
        //        [trackCircle setValue:basicTrackCircleAnimation.toValue forKey:basicTrackCircleAnimation.keyPath];
    }
    
    //    - (NSMutableArray *)clearExcessLayers:(NSMutableArray *)layers
    //    {
    //        if (layers.count > self.maxCount) {
    //
    //            for (NSUInteger i = self.maxCount; i < layers.count; i++) {
    //                [layers[i] removeFromSuperlayer];
    //            }
    //
    //            return [[layers subarrayWithRange:NSMakeRange(0, self.maxCount)] mutableCopy];
    //        }
    //
    //        return layers;
    //    }
    //
    //    - (CGFloat)labelHeightWithMaxWidth:(CGFloat)maxWidth
    //    {
    //        if (self.labels.count) {
    //            CGFloat labelHeight = 0.f;
    //
    //            for (NSUInteger i = 0; i < self.labels.count; i++) {
    //                CGSize size;
    //                if (self.adjustLabel && (i == 0 || i == self.labels.count - 1)) {
    //                    size = CGSizeMake([self roundForTextDrawing:maxWidth / 2.f + maxRadius], CGFLOAT_MAX);
    //                } else {
    //                    size = CGSizeMake([self roundForTextDrawing:maxWidth], CGFLOAT_MAX);
    //                }
    //
    //                CGFloat height = [self.labels[i] boundingRectWithSize:size
    //                                                              options:NSStringDrawingUsesLineFragmentOrigin
    //                                                           attributes:@{NSFontAttributeName : self.labelFont}
    //                                                              context:nil].size.height;
    //                labelHeight = fmax(ceil(height), labelHeight);
    //            }
    //            return labelHeight;
    //        }
    //
    //        return 0;
    //    }
    //
    //    /*
    //     Calculate distance from trackCircle center to point where circle cross track line.
    //     */
    //    - (void)updateDiff
    //    {
    //        diff = sqrtf(fmaxf(0.f, powf(self.trackCircleRadius, 2.f) - pow(self.trackHeight / 2.f, 2.f)));
    //    }
    //
    //    - (void)updateMaxRadius
    //    {
    //        maxRadius = fmaxf(self.trackCircleRadius, self.sliderCircleRadius);
    //    }
    //
    //    - (void)updateIndex
    //    {
    //        NSAssert(self.maxCount > 1, @"Elements count must be greater than 1!");
    //        if (_index > (self.maxCount - 1)) {
    //            _index = self.maxCount - 1;
    //            [self sendActionsForControlEvents:UIControlEventValueChanged];
    //        }
    //    }
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

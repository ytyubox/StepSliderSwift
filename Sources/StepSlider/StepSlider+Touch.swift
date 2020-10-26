//
//  File.swift
//  
//
//  Created by 游宗諭 on 2020/10/18.
//

import UIKit
extension StepSlider {
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let point = touch.location(in: self)
        return beginTracking(point)
    }
    
    
    
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        continueTracking(touch.location(in: self))
        return true
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        endTouches()
    }
    public override func cancelTracking(with event: UIEvent?) {
        endTouches()
    }
    
    
    private func expendFrameIfNeed(frame: CGRect) -> CGRect {
        let dotRadiusDiff:CGFloat = touchData.touchPaddingArea - nodeRadius
        let frameToCheck:CGRect =
            dotRadiusDiff > 0
            ? frame.insetBy(dx: -dotRadiusDiff, dy: -dotRadiusDiff)
            : frame
        return frameToCheck
    }
    private func beginTracking(_ point: CGPoint) -> Bool {
        touchData.startTouchPosition = point
        touchData.startSliderPosition = thumb.position
        _selectFeedback.readyForAction()
        // continue track because it's on thumb
        if (isPointOnThumb(point)) {
            return true
        }
        guard isDotsInteractionEnabled else {return false}
        for (i,node) in nodeList.enumerated() {
            let frameToCheck:CGRect = expendFrameIfNeed(frame: node.shapeLayer.frame)
            if (frameToCheck.contains(point)) {
                let  oldIndex: Int = Int(value)
                value = Double(i)
                
                if (oldIndex == Int(value)) {
                    sendActions(for: .valueChanged)
                    nodeList.forEach(updateNode)
                    _selectFeedback.sendAction()
                }
                viewData.animateLayouts = true
                setNeedsLayout()
                break
            }
        }
        return false
        
    }
    private func continueTracking(_ point: CGPoint) {
        
        let position:CGFloat = touchData.startSliderPosition.x - (touchData.startTouchPosition.x - point.x)
        let limitedPosition:CGFloat = min(max(viewData.maxRadius, position), bounds.size.width - viewData.maxRadius)
        withoutCAAnimation{
            thumb.position.x = limitedPosition
            track.path = makeMinimunTrackPath()
            
            let index = Int((thumbPosition() + viewData.diff) / (track.bounds.size.width / CGFloat(maximunValue - 1)))
            
            if (Int(value) == index) {
                return
            }
            nodeList.forEach(updateNode)
            value = Double(index)
            sendActions(for: .valueChanged)
            _selectFeedback.sendAction()
            _selectFeedback.readyForAction()
        }
    }
    private func endTouches()
    {
        let newIndex = Double(round(calculateIndex()))
        
        if (newIndex != value) {
            value = Double(newIndex)
            sendActions(for: .valueChanged)
        }
        
        viewData.animateLayouts = true
        setNeedsLayout()
    }
    private func isPointOnThumb(_ point: CGPoint) -> Bool {
        thumb.frame.contains(point)
    }
    private func updateNode(node: Node) {
        if let nodeImage:CGImage = self.getNodeImage(node.shapeLayer) {
            node.shapeLayer.contents = nodeImage
        } else {
            node.shapeLayer.fillColor = getNodeColor(node.shapeLayer)
        }
    }
}

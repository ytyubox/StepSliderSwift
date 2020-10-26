import UIKit

struct TouchData {
    var nodeRadius:CGFloat = 5
    var touchPaddingArea:CGFloat = 22
    var enableHapticFeedback = true
    var isDotsInteractionEnabled = true
    var startTouchPosition: CGPoint = .zero
    var startSliderPosition: CGPoint = .zero
    
    func expendFrameIfNeed(frame: CGRect) -> CGRect {
        let dotRadiusDiff:CGFloat = touchPaddingArea - nodeRadius
        let frameToCheck:CGRect =
            dotRadiusDiff > 0
            ? frame.insetBy(dx: -dotRadiusDiff, dy: -dotRadiusDiff)
            : frame
        return frameToCheck
    }
}

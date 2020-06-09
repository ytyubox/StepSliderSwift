//
//  StepSliderHeader.swift
//  StepSliderSwift
//
//  Created by 游宗諭 on 2020/6/9.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import UIKit


public class StepSlider:UIControl {
    
    public enum StepSliderTextOrientation {
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
    
    @IBInspectable public var maxCount: UInt = 0
    
    /**
     *  Currnet selected dot index.
     */
    @IBInspectable public var  index: Int = 0
    
    
    /**
     *  Height of the slider track.
     */
    @IBInspectable public var trackHeight: CGFloat = 4
    
    /**
     *  Radius of the default dots on slider track.
     */
    @IBInspectable public var  trackCircleRadius: CGFloat = 5
    
    /**
     *  Radius of the slider main wheel.
     */
    @IBInspectable public var  sliderCircleRadius:CGFloat = 12.5
    
    /**
     *  A Boolean value that determines whether user interaction with dots are ignored. Default value is `YES`.
     */
    //(nonatomic, getter=isDotsInteractionEnabled)
    @IBInspectable public var  dotsInteractionEnabled: Bool = true
    
    
    /**
     *  Color of the slider slider.
     */
    @IBInspectable public var  trackColor: UIColor! = nil
    
    /**
     *  Color of the slider main wheel.
     */
    @IBInspectable public var  sliderCircleColor:  UIColor! = nil
    
    /**
     *  Image for slider main wheel.
     */
    @IBInspectable public var  sliderCircleImage:  UIImage?
    
    /**
     *  Text for labels that will be show near every dot.
     *  Note: If `labels` array not empty set `maxCount` to labels count.
     */
    public var labels: Array<String> = []
    
    /**
     *  Font of dot labels.
     *  Can not be `IBInspectable`. http://openradar.appspot.com/21889252
     */
    public var labelFont: UIFont?
    
    /**
     *  Color of dot labels.
     */
    @IBInspectable public var  labelColor: UIColor!
    
    /**
     *  Offset between slider and labels.
     */
    @IBInspectable public var labelOffset: CGFloat = 20
    
    /**
     *  Current vertical orientatons of dot labels.
     */
    public var  labelOrientation: StepSliderTextOrientation = .down
    
    /**
     *  If `YES` adjust first and last labels to StepSlider frame. And change alingment to left and right.
     *  Otherwise label position is same as trackCircle, and aligment always is center.
     */
    @IBInspectable public var  adjustLabel: Bool = true
    
    /**
     *  Generate haptic feedback when value was changed. Ignored if low power mode is turned on.
     *  Default value is `false`.
     */
    @IBInspectable public var  enableHapticFeedback: Bool
        = true
    
    /**
     *  Set the `index` property to parameter value.
     *
     *  @param index    The index, that you wanna to be selected.
     *  @param animated `YES` to animate changing of the `index` property.
     */
    public func setIndex(index: Int, animated: Bool)  {
        
    }
    
    //    internal
    //    var _state: _State
    /**
     *  Sets the image to use for track circle for the specified state.
     *  Currently supported only `UIControlStateNormal` and `UIControlStateSelected`.
     *
     *  @param image The image to use for the specified state.
     *  @param state The state that uses the specified image.
     */
    func setTrackCircleImage(image:UIImage, for state : UIControl.State) {
        
    }
    //    struct _State {
    var _trackLayer: CAShapeLayer = CAShapeLayer()
    var _sliderCircleLayer: CAShapeLayer = CAShapeLayer()
    var _trackCirclesArray: Array<CAShapeLayer> = []
    var _trackLabelsArray: Array<CATextLayer> = []
    var _trackCircleImages: Dictionary <Int, UIImage> = [:]
    var _selectFeedback: UIImpactFeedbackGenerator?
    var animateLayouts: Bool = true
    var maxRadius: CGFloat = 0
    var diff: CGFloat = 0
    var startTouchPosition: CGPoint = .zero
    var startSliderPosition: CGPoint = .zero
    var contentSize: CGSize = .zero
    //    }
}


//
//  CustomStepSlider.swift
//  StepSliderTests
//
//  Created by Caio Zullo on 26/10/2020.
//

import UIKit

@IBDesignable
public class CustomStepSlider: UIControl {
    private(set) lazy var slider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .systemBlue
        slider.maximumTrackTintColor = .darkGray
        addSubview(slider)
        
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: slider.trailingAnchor),
            slider.topAnchor.constraint(equalTo: topAnchor),
            bottomAnchor.constraint(equalTo: slider.bottomAnchor),
        ])
        
        return slider
    }()
    
    @IBInspectable
    public var maximumSteps: UInt {
        get { UInt(slider.maximumValue) + 1 }
        set {
            slider.maximumValue = Float(newValue) - 1
            addTrackCircles()
        }
    }
    
    @IBInspectable
    public var step: UInt {
        get { UInt(round(slider.value)) }
        set {
            slider.value = Float(newValue)
            updateTrackCircles()
        }
    }
    
    private var _trackCirclesArray = [CAShapeLayer]()
    
    private func addTrackCircles() {
        _trackCirclesArray.forEach { $0.removeFromSuperlayer() }
        _trackCirclesArray.removeAll()
        
        for step in 0..<maximumSteps {
            let lastStep = maximumSteps-1
            let circleFrameSide = CGFloat(10)
            let stepWidth = bounds.size.width / CGFloat(maximumSteps-1)
            let circleX = stepWidth * CGFloat(step)
            let circleY = bounds.midY
                        
            let circleXOffset: CGFloat
            if step == 0 {
                circleXOffset = circleFrameSide/2
            } else if step == lastStep {
                circleXOffset = -circleFrameSide/2
            } else {
                circleXOffset = 0
            }
            
            let trackCircle = CAShapeLayer(layer: layer)
            trackCircle.bounds = CGRect(x: 0.0, y: 0.0, width: circleFrameSide, height: circleFrameSide)
            trackCircle.position = CGPoint(x: circleXOffset+circleX, y: circleY)
            trackCircle.fillColor = slider.maximumTrackTintColor?.cgColor
            trackCircle.path = UIBezierPath(roundedRect: trackCircle.bounds, cornerRadius: circleFrameSide/2).cgPath
            
            layer.insertSublayer(trackCircle, below: slider.layer)
            _trackCirclesArray.append(trackCircle)

        }
    }
    
    private func updateTrackCircles() {
        let direction = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute)
        let circles = direction == .rightToLeft ? _trackCirclesArray.reversed() : _trackCirclesArray
        
        circles.enumerated().forEach { index, circle in
            circle.fillColor = (index > step) ?
                slider.maximumTrackTintColor?.cgColor :
                slider.minimumTrackTintColor?.cgColor
        }
    }
    
    @objc private func sliderValueChanged() {
        if !slider.isTracking {
            slider.setValue(Float(step), animated: true)
        }
        updateTrackCircles()
        sendActions(for: .valueChanged)
    }
}

//
//  CustomStepSlider.swift
//  StepSliderTests
//
//  Created by Caio Zullo on 26/10/2020.
//

import UIKit

@IBDesignable
public class CustomStepSlider: UIControl {
    private(set) lazy var _slider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .systemBlue
        slider.maximumTrackTintColor = .darkGray
        addSubview(slider)
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            trailingAnchor.constraint(equalTo: slider.trailingAnchor, constant: 0),
            slider.topAnchor.constraint(equalTo: topAnchor),
            bottomAnchor.constraint(equalTo: slider.bottomAnchor),
        ])
        
        return slider
    }()
    
    @IBInspectable
    public var maximumSteps: UInt {
        get { UInt(_slider.maximumValue) + 1 }
        set {
            _slider.maximumValue = Float(newValue) - 1
            _addTrackCircles()
        }
    }
    
    @IBInspectable
    public var step: UInt {
        get { UInt(round(_slider.value)) }
        set {
            _slider.value = Float(newValue)
            _updateTrackCircles()
        }
    }
    
    private var _trackCirclesArray = [CAShapeLayer]()
    var nodeWidth:CGFloat = 10
    var nodeCenterOffSet:CGFloat {nodeWidth / 2}
    private func _addTrackCircles() {
        _trackCirclesArray.forEach { $0.removeFromSuperlayer() }
        _trackCirclesArray.removeAll()
        
        for step in 0..<maximumSteps {
            let lastStep = maximumSteps-1
            let stepWidth = bounds.size.width / CGFloat(maximumSteps-1)
            let circleX = stepWidth * CGFloat(step)
            let circleY = bounds.midY
                        
            let circleXOffset: CGFloat
            if step == 0 {
                circleXOffset = nodeWidth/2
            } else if step == lastStep {
                circleXOffset = -nodeWidth/2
            } else {
                circleXOffset = 0
            }
            
            let trackCircle = CAShapeLayer(layer: layer)
            trackCircle.bounds = CGRect(x: 0.0, y: 0.0, width: nodeWidth, height: nodeWidth)
            trackCircle.position = CGPoint(x: circleXOffset+circleX, y: circleY)
            trackCircle.fillColor = _slider.maximumTrackTintColor?.cgColor
            trackCircle.path = UIBezierPath(roundedRect: trackCircle.bounds, cornerRadius: nodeWidth/2).cgPath
            
            layer.insertSublayer(trackCircle, below: _slider.layer)
            _trackCirclesArray.append(trackCircle)

        }
    }
    
    private func _updateTrackCircles() {
        let direction = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute)
        let circles = direction == .rightToLeft ? _trackCirclesArray.reversed() : _trackCirclesArray
        
        circles.enumerated().forEach { index, circle in
            circle.fillColor = (index > step) ?
                _slider.maximumTrackTintColor?.cgColor :
                _slider.minimumTrackTintColor?.cgColor
        }
    }
    
    @objc private func sliderValueChanged() {
        if !_slider.isTracking {
            _slider.setValue(Float(step), animated: true)
            sendActions(for: .valueChanged)
            _updateTrackCircles()
        }
        if _slider.value.isBefore5() {
            sendActions(for: .valueChanged)
            _updateTrackCircles()
        }
    }
}


private extension BinaryFloatingPoint {
    func isBefore5() -> Bool {
        abs(Float(Int(self)) - Float(self)) < 0.5
        
    }
}

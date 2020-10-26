//
//  ViewController.swift
//  StepSliderSwift
//
//  Created by 游宗諭 on 2020/6/9.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import UIKit
import StepSlider

class ViewController: UIViewController {
    
    var selectValue:Double = 0 {
        didSet {
               self.label.text = "Selected index: \(self.selectValue)"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
      
    }
    var targetColor: ReferenceWritableKeyPath<StepSlider, UIColor>? 
    var targetButton:UIButton?
    func reset() {
        sliderView.labels = (1...sliderView.maximunValue).map(\.description)
        selectValue = self.sliderView?.value ?? 0
    }
    @IBOutlet weak var label: UILabel!
    @IBOutlet var sliderView:StepSlider!
    
    @IBAction func changeValue(sender:StepSlider) {
        sliderView.value = sender.value
        sender.value = sliderView.value
    }
    
    @IBAction func programChangeValue(sender: UIStepper) {
        sliderView.value = sender.value
    }
    @IBAction func changeMax(sender: UIStepper) {
        sliderView.maximunValue = Int(sender.value)
        sender.minimumValue = Double(sliderView.minimunValue + 1)
    }
    @IBAction func changeMin(sender: UIStepper) {
        sliderView.minimunValue = Int(sender.value)
        sender.maximumValue = Double(sliderView.maximunValue - 1)
    }
    @IBAction func thumbColor(sender: UIButton) {
        targetColor = \.thumbColor
        showcolorPicker(sender: sender)
    }
    @IBAction func thumbRadius(sender: UISlider) {
        sliderView.thumbRadius = CGFloat(sender.value)
    }
    @IBAction func trackColor(sender: UIButton) {
        targetColor = \.trackColor
        showcolorPicker(sender: sender)
    }
    @IBAction func nodeRaidus(sender: UISlider) {
        sliderView.nodeRadius = CGFloat(sender.value)
    }
    @IBAction func trackHeight(sender: UISlider) {
        sliderView.trackHeight = CGFloat(sender.value)
    }
    @IBAction func changeTrackCircleImage(sender:UIButton) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addTextField { (text) in
        }
        alert.addAction(UIAlertAction(title: "change", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .destructive, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    @IBAction func toggleLabels(sender:UISwitch) {
        
    }
    @IBAction func labelsFont(sender: UIStepper) {
        sliderView.labelFont = .systemFont(ofSize: CGFloat(sender.value))
    }
    @IBAction func labelsColor(sender: UIButton) {
        targetColor = \.labelColor
        showcolorPicker(sender: sender)
    }
    @IBAction func labelsOffset(sender: UISlider) {
        sliderView.labelOffset = CGFloat(sender.value)
    }
    func showcolorPicker(sender: UIButton) {
        targetButton = sender
        let vc = UIColorPickerViewController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
}

extension ViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        sliderView[keyPath: targetColor!] = color
        targetColor = nil
        targetButton?.setTitleColor(color, for: .normal)
        targetButton = nil
        
    }
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        
    }
}

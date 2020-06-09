//
//  ViewController.swift
//  StepSliderSwift
//
//  Created by 游宗諭 on 2020/6/9.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var selectValue = 0 {
        didSet {
               self.label.text = "Selected index: \(self.selectValue)"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectValue = self.sliderView?.index ?? 0
        
    }
    @IBOutlet weak var label: UILabel!
    @IBOutlet var sliderView:StepSlider!
    
    @IBAction func changeValue(sender:StepSlider) {
        
    }
    @IBAction func changeIndex(sender: UIButton) {
        
    }
    @IBAction func changeMaxIndex(sender: UIButton) {
        
    }
    @IBAction func changeTintColor(sender: UIButton) {
        
    }
    @IBAction func changeSliderCircleColor(sender: UIButton) {
        
    }
    @IBAction func changeSliderCircleRadius(sender: UIButton) {
        
    }
    @IBAction func changeTrackColor(sender: UIButton) {
        
    }
    @IBAction func changeTrackCircleRaidus(sender: UIButton) {
        
    }
    @IBAction func changeTrackHeight(sender: UIButton) {
        
    }
    @IBAction func changeTrackCircleImage(sender:UIButton ) {
        
    }
    @IBAction func toggleLabels(sender:UIButton) {
        
    }
    @IBAction func changeLabelsFont(sender: UIButton) {
        
    }
    @IBAction func changeLabelsColor(sender: UIButton) {
        
    }
    @IBAction func changeLabelsOffset(sender: UIButton) {
        
    }
    @IBAction func changeLabelsOrientation(sender: UIButton) {
        
    }
    @IBAction func adjustLabels(sender:UIButton) {
        
    }
    
}


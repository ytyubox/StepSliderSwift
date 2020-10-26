//
//  File.swift
//  
//
//  Created by 游宗諭 on 2020/10/12.
//

import Foundation
import XCTest
import StepSlider

class StepSliderSPY: StepSlider {
    
}
class Client {
    internal init(expect: XCTestExpectation = XCTestExpectation()) {
        self.expect = expect
    }
    
    let expect:XCTestExpectation
    var receivedEvent = [Int]()
    @objc func sliderChangedValue(_ sender: StepSlider) {
        receivedEvent.append(Int(sender.value))
        expect.fulfill()
    }
}


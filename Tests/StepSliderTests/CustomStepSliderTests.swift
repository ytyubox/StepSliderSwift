//
//  CustomStepSliderTests.swift
//  StepSliderTests
//
//  Created by Caio Zullo on 26/10/2020.
//

import XCTest

class CustomStepSlider {
    let slider = UISlider()
    var maximumSteps: UInt {
        get { UInt(slider.maximumValue) + 1 }
        set {
            slider.maximumValue = Float(newValue) - 1
        }
    }
    var step: UInt {
        get { UInt(slider.value) }
        set {
            slider.value = Float(newValue)
        }
    }
}

class CustomStepSliderTests: XCTestCase {

    func test_defaultValues() {
        let sut = CustomStepSlider()
        
        XCTAssertEqual(sut.maximumSteps, 2, "max steps")
        XCTAssertEqual(sut.step, 0, "current steps")
        XCTAssertEqual(sut.slider.value, 0, "slider value")
        XCTAssertEqual(sut.slider.minimumValue, 0, "slider min value")
        XCTAssertEqual(sut.slider.maximumValue, 1, "slider max value")
    }
    
    func test_setMaximumSteps_updatesUnderlyingSlider() {
        let sut = CustomStepSlider()
        
        sut.maximumSteps = 5
        
        XCTAssertEqual(sut.maximumSteps, 5, "max steps")
        XCTAssertEqual(sut.step, 0, "current steps")
        XCTAssertEqual(sut.slider.value, 0, "slider value")
        XCTAssertEqual(sut.slider.minimumValue, 0, "slider min value")
        XCTAssertEqual(sut.slider.maximumValue, 4, "slider max value")
    }
    
    func test_setStep_updatesUnderlyingSlider() {
        let sut = CustomStepSlider()
        
        sut.maximumSteps = 4
        sut.step = 2
        
        XCTAssertEqual(sut.maximumSteps, 4, "max steps")
        XCTAssertEqual(sut.step, 2, "current steps")
        XCTAssertEqual(sut.slider.value, 2, "slider value")
        XCTAssertEqual(sut.slider.minimumValue, 0, "slider min value")
        XCTAssertEqual(sut.slider.maximumValue, 3, "slider max value")
    }
    
    func test_setStepOverMaximum_updatesUnderlyingSlider() {
        let sut = CustomStepSlider()
        
        sut.maximumSteps = 4
        sut.step = 4
        
        XCTAssertEqual(sut.maximumSteps, 4, "max steps")
        XCTAssertEqual(sut.step, 3, "current steps")
        XCTAssertEqual(sut.slider.value, 3, "slider value")
        XCTAssertEqual(sut.slider.minimumValue, 0, "slider min value")
        XCTAssertEqual(sut.slider.maximumValue, 3, "slider max value")
    }

}

//
//  CustomStepSliderTests.swift
//  StepSliderTests
//
//  Created by Caio Zullo on 26/10/2020.
//

import XCTest
@testable import StepSlider

class CustomStepSliderTests: XCTestCase {

    func test_defaultValues() {
        let sut = CustomStepSlider()
        
        XCTAssertEqual(sut.maximumSteps, 2, "max steps")
        XCTAssertEqual(sut.step, 0, "current steps")
        XCTAssertEqual(sut._slider.value, 0, "slider value")
        XCTAssertEqual(sut._slider.minimumValue, 0, "slider min value")
        XCTAssertEqual(sut._slider.maximumValue, 1, "slider max value")
    }
    
    func test_setMaximumSteps_updatesUnderlyingSlider() {
        let sut = CustomStepSlider()
        
        sut.maximumSteps = 5
        
        XCTAssertEqual(sut.maximumSteps, 5, "max steps")
        XCTAssertEqual(sut.step, 0, "current steps")
        XCTAssertEqual(sut._slider.value, 0, "slider value")
        XCTAssertEqual(sut._slider.minimumValue, 0, "slider min value")
        XCTAssertEqual(sut._slider.maximumValue, 4, "slider max value")
    }
    
    func test_setStep_updatesUnderlyingSlider() {
        let sut = CustomStepSlider()
        
        sut.maximumSteps = 4
        sut.step = 2
        
        XCTAssertEqual(sut.maximumSteps, 4, "max steps")
        XCTAssertEqual(sut.step, 2, "current steps")
        XCTAssertEqual(sut._slider.value, 2, "slider value")
        XCTAssertEqual(sut._slider.minimumValue, 0, "slider min value")
        XCTAssertEqual(sut._slider.maximumValue, 3, "slider max value")
    }
    
    func test_setStepOverMaximum_updatesUnderlyingSlider() {
        let sut = CustomStepSlider()
        
        sut.maximumSteps = 4
        sut.step = 4
        
        XCTAssertEqual(sut.maximumSteps, 4, "max steps")
        XCTAssertEqual(sut.step, 3, "current steps")
        XCTAssertEqual(sut._slider.value, 3, "slider value")
        XCTAssertEqual(sut._slider.minimumValue, 0, "slider min value")
        XCTAssertEqual(sut._slider.maximumValue, 3, "slider max value")
    }
    
    func test_setSliderValue_updatesStep() {
        let sut = CustomStepSlider()
        sut.maximumSteps = 4

        sut._slider.value = 1
        XCTAssertEqual(sut.step, 1, "current step")
        
        sut._slider.value = 2
        XCTAssertEqual(sut.step, 2, "current step")
    }
    
    func test_setSliderFraction_updatesStep() {
        let sut = CustomStepSlider()
        sut.maximumSteps = 4

        sut._slider.value = 0.4
        sut._slider.simulate(.valueChanged)
        XCTAssertEqual(sut.step, 0, "current step")
        XCTAssertEqual(sut._slider.value, 0, "slider value")

        sut._slider.value = 1.5
        sut._slider.simulate(.valueChanged)
        XCTAssertEqual(sut.step, 2, "current step")
        XCTAssertEqual(sut._slider.value, 2, "slider value")

        sut._slider.value = 2.6
        sut._slider.simulate(.valueChanged)
        XCTAssertEqual(sut.step, 3, "current step")
        XCTAssertEqual(sut._slider.value, 3, "slider value")
    }
    
    func test_setSliderValue_sendValueChangeEvents() {
        var eventCount = 0
        let sut = CustomStepSlider()
        sut.addAction(UIAction { _ in eventCount += 1 }, for: .valueChanged)

        sut._slider.simulate(.valueChanged)
        XCTAssertEqual(eventCount, 1)

        sut._slider.simulate(.valueChanged)
        XCTAssertEqual(eventCount, 2)
    }

}

private extension UIControl {
    func simulate(_ event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

//
//  CustomStepSliderTests.swift
//  StepSliderTests
//
//  Created by Caio Zullo on 26/10/2020.
//

import XCTest

class CustomStepSlider {
    let slider = UISlider()
    let maximumSteps = 2
    let step = 0
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

}

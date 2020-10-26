//
//  CustomStepSliderSnapshotTests.swift
//  StepSliderTests
//
//  Created by Caio Zullo on 26/10/2020.
//

import XCTest
@testable import StepSlider

class CustomStepSliderSnapshotTests: XCTestCase {

    func test_threeSteps() {
        let sut = CustomStepSlider(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        sut.maximumSteps = 3
        sut.backgroundColor = .systemBackground
        
        let snapshot = sut.snapshot(for: .init(size: sut.frame.size))
        assert(snapshot: snapshot, named: "three_steps")
    }
    
    func test_secondStep_outOfFour() {
        let sut = CustomStepSlider(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        sut.maximumSteps = 4
        sut.step = 1
        sut.backgroundColor = .systemBackground
        
        let snapshot = sut.snapshot(for: .init(size: sut.frame.size))
        assert(snapshot: snapshot, named: "second_step_out_of_four")
    }
    
    func test_fourthStep_outOfFive_rightToLeft() {
        let sut = CustomStepSlider(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        sut.semanticContentAttribute = .forceRightToLeft
        sut.maximumSteps = 5
        sut.step = 3
        sut.backgroundColor = .systemBackground
        
        let snapshot = sut.snapshot(for: .init(size: sut.frame.size, traitCollection: .init(layoutDirection: .rightToLeft)))
        assert(snapshot: snapshot, named: "fourth_step_out_of_five")
    }

}

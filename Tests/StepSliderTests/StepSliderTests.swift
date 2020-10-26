import XCTest
import UIKit
@testable import StepSlider

final class StepSliderSwiftTests: XCTestCase {
    func test_Slider_init() throws {
        let sut = _StepSlider()
        sut.backgroundColor = .red
        record(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "RewritedStepSlider")
    }
    func test_slider_snapshot() {
        let sut = StepSlider()
        record(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "Stepslider")
    }
}

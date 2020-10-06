import XCTest
@testable import StepSlider
final class stepSliderInternalTests: XCTestCase {
    func test_sliderLayoutLayersAnimaetd() throws {
        let sut = StepSlider()
        sut.layoutLayersAnimated(true)
    }

}

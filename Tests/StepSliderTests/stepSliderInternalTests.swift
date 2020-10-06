import XCTest
@testable import StepSlider
final class stepSliderInternalTests: XCTestCase {
    func test_slider_init_get_correct_default_value() throws {
        let sut = StepSlider()
        XCTAssertEqual(sut.maxCount, 4)
        XCTAssertEqual(sut.index, 0)
        XCTAssertEqual(sut.trackHeight, 4)
        XCTAssertEqual(sut.trackCircleRadius, 5)
        XCTAssertEqual(sut.sliderCircleRadius, 12.5)
        XCTAssertEqual(sut.dotsInteractionEnabled, true)
        XCTAssertEqual(sut.isDotsInteractionEnabled, true)
        XCTAssertEqual(sut.trackColor, .init(white: 0.41, alpha: 1))
        XCTAssertEqual(sut.sliderCircleColor, .white)
        XCTAssertEqual(sut.sliderCircleImage, .none)
        XCTAssertEqual(sut.labels, [])
        XCTAssertEqual(sut.labelFont, .systemFont(ofSize: 15))
        XCTAssertEqual(sut.labelColor, .none)
        XCTAssertEqual(sut.labelOffset, 20)
        XCTAssertEqual(sut.labelOrientation, .down)
        XCTAssertEqual(sut.adjustLabel, true)
        XCTAssertEqual(sut.enableHapticFeedback, true)
        #warning("No idea how to test _trackLayer on creation")
//        XCTAssertEqual(sut._trackLayer, CAShapeLayer())
        #warning("No idea how to test _sliderCircleLayer on creation")
//        XCTAssertEqual(sut._sliderCircleLayer, CAShapeLayer())
        XCTAssertEqual(sut._trackCirclesArray, [])
        XCTAssertEqual(sut._trackLabelsArray, [])
        XCTAssertEqual(sut._trackCircleImages, [:])
        XCTAssertEqual(sut._selectFeedback, nil)
        XCTAssertEqual(sut.animateLayouts, true)
        XCTAssertEqual(sut.maxRadius, 12.5)
        XCTAssertEqual(sut.diff, 0)
        XCTAssertEqual(sut.startTouchPosition, .zero)
        XCTAssertEqual(sut.startSliderPosition, .zero)
        XCTAssertEqual(sut.contentSize, .zero)
    }
    func test_slider_init_by_coder_will_give_back_a_instance() throws {
        let subject:StepSlider? = nil // StepSlider(coder: NSCoder())
        try XCTSkipIf(subject == nil, "no idea how to provide a coder to `StepSlider(coder:)`, with error message: *** -containsValueForKey: cannot be sent to an abstract object of class NSCoder: Create a concrete instance! (NSInvalidArgumentException)")
        _ = try XCTUnwrap(subject)
    }


}
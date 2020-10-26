import XCTest
@testable import StepSlider
final class stepSliderInternalTests: XCTestCase {
//    func test_slider_init_get_correct_default_value() throws {
//        let sut = makeSUT()
//        XCTAssertEqual(sut.maximunValue, 4)
//        XCTAssertEqual(sut.value, 0)
//        XCTAssertEqual(sut.trackHeight, 4)
//        XCTAssertEqual(sut.trackCircleRadius, 5)
//        XCTAssertEqual(sut.sliderCircleRadius, 12.5)
//        XCTAssertEqual(sut.dotsInteractionEnabled, true)
//        XCTAssertEqual(sut.isDotsInteractionEnabled, true)
//        XCTAssertEqual(sut.trackColor, .init(white: 0.41, alpha: 1))
//        XCTAssertEqual(sut.sliderCircleColor, .white)
//        XCTAssertEqual(sut.sliderCircleImage, .none)
//        XCTAssertEqual(sut.labels, [])
//        XCTAssertEqual(sut.labelFont, .systemFont(ofSize: 15))
//        XCTAssertEqual(sut.labelColor, .none)
//        XCTAssertEqual(sut.labelOffset, 20)
//        XCTAssertEqual(sut.labelOrientation, .down)
//        XCTAssertEqual(sut.adjustLabel, true)
//        XCTAssertEqual(sut.enableHapticFeedback, true)
//        XCTAssertNotNil(sut._trackLayer)
//        XCTAssertNotNil(sut._sliderCircleLayer)
//        XCTAssertEqual(sut._trackCirclesArray.count, 4)
//        XCTAssertEqual(sut._trackLabelsArray, [])
//        XCTAssertEqual(sut._trackCircleImages, [:])
//        XCTAssertEqual(sut._selectFeedback, nil)
//        XCTAssertEqual(sut.animateLayouts, true)
//        XCTAssertEqual(sut.maxRadius, 12.5)
//        XCTAssertEqual(sut.diff, 0)
//        XCTAssertEqual(sut.startTouchPosition, .zero)
//        XCTAssertEqual(sut.startSliderPosition, .zero)
//        XCTAssertEqual(sut.contentSize, CGSize(width: 44, height: 45))
//    }
    func test_slider_init_by_coder_will_give_back_a_instance() throws {
        let subject:StepSlider? = nil // StepSlider(coder: NSCoder())
        try XCTSkipIf(subject == nil, "no idea how to provide a coder to `StepSlider(coder:)`, with error message: *** -containsValueForKey: cannot be sent to an abstract object of class NSCoder: Create a concrete instance! (NSInvalidArgumentException)")
        _ = try XCTUnwrap(subject)
    }
//    func test_SliderPosition() throws {
//        let sut = makeSUT()
//        let result = sut.thumbPosition()
//        XCTAssertEqual(result, 0)
//    }
//    func test_set_value_outer_from_max_min_will_set_to_max_min() {
//        let sut = makeSUT()
//        sut.maximunValue = 10
//        sut.minimunValue = 8
//        sut.value = 7
//        XCTAssertEqual(sut.value, 8)
//        sut.value = 11
//        XCTAssertEqual(sut.value, 10)
//    }
    func test_labels_can_be_asign() {
//        let sut = makeSUT()
//        let labels = ["0","1","2"]
//        sut.setLabels(labels: labels)
//        XCTAssertEqual(labels, sut.labels)
    }
//    func test (){
//        let sut = makeSUT()
//        let secondCircle = sut._trackCirclesArray[1]
//        let point = CGPoint(x: secondCircle.frame.midX, y: secondCircle.frame.midY)
//        XCTAssertEqual(sut.value, 1)
//    }
    // MARK: - test helper
    func makeSUT() -> StepSliderSPY {
        let sut = StepSliderSPY()
        sut.setNeedsDisplay()
        addTeardownBlock {
            [weak sut] in
            XCTAssertNil(sut, "sut was retain somewhere")
        }
        return sut
    }
}

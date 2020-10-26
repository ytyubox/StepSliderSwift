//
//  StepSliderPresentorTests.swift
//  
//
//  Created by 游宗諭 on 2020/10/12.
//

import XCTest
@testable import StepSlider

class StepSliderPresentorTests: XCTestCase {
//    func test_indexCalculate() throws {
//        let sut = makeSUT()
//        let result = sut.calculateIndex()
//        XCTAssertEqual(result, 0)
//        sut.value = 1
//        XCTAssertEqual(sut.calculateIndex(), 1)
//    }
//    func test_change_index_will_not_emit_event() {
//        let sut = makeSUT()
//        let expect = XCTestExpectation()
//        let client = Client(expect: expect)
//        sut.addTarget(client, action: #selector(Client.sliderChangedValue), for: .valueChanged)
//        sut.value = 2
//        XCTAssertEqual(client.receivedEvent, [])
//        sut.sendActions(for: .valueChanged)
//        wait(for: [expect], timeout: 1)
//        XCTAssertEqual(client.receivedEvent, [2])
//    }
//    func test_touch_on_dot_will_emit_event() {
//        let sut = makeSUT()
//        let client = Client()
//        sut.addTarget(client, action: #selector(Client.sliderChangedValue), for: .valueChanged)
//        let frames =
//            [//CGRect(x: -9.5, y: -9.5, width: 44.0, height: 44.0),
//             CGRect(x: -17.833333333333336, y: -9.5, width: 44.0, height: 44.0),
//             CGRect(x: -26.166666666666668, y: -9.5, width: 44.0, height: 44.0),
//             CGRect(x: -34.5, y: -9.5, width: 44.0, height: 44.0),]
//        for frame in frames {
//            let shouldbegin = sut.beginTracking(CGPoint(x: frame.midX, y: frame.midY))
//            XCTAssertFalse(shouldbegin, "\(frame)")
//        }
//        XCTAssertFalse(client.receivedEvent.isEmpty)
//        
//        
//    }
//    // MARK: - test helper
//    func makeSUT() -> StepSliderSPY {
//        let sut = StepSliderSPY()
//        sut.setNeedsDisplay()
//        addTeardownBlock {
//            [weak sut] in
//            XCTAssertNil(sut, "sut was retain somewhere")
//        }
//        return sut
//    }

}

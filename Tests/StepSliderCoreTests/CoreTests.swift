import XCTest
@testable import StepSliderCore
final class CoreTests: XCTestCase {
    
    func test_set_value_will_limit_in_range() {
        let sut = makeSUT()
        sut.maximunValue = 10
        sut.minimunValue = 8
        sut.value = 7
        XCTAssertEqual(sut.value, 8)
        sut.value = 11
        XCTAssertEqual(sut.value, 10)
    }
    
    func test_setting_will_create_associate_nodes() throws {
        let sut = makeSUT()
        XCTAssertEqual(sut.maximunValue, 4)
        XCTAssertEqual(sut.minimunValue, 0)
        XCTAssertEqual(sut.nodes.count, 5)
        sut.minimunValue = 1
        sut.maximunValue = 4
        XCTAssertEqual(sut.nodes.count, 4)
    }
    func test_set_float_value_set_nearest_value() throws {
        let inputs:[Double] =  [0.5, 1.1, 2.8, 3.6]
        let expects:[Double] = [1,     1,   3,   4]
        for (i, e) in zip(inputs, expects) {
            let sut = makeSUT()
            sut.value = i
            XCTAssertEqual(e, sut.value, "\(i) should be \(e), but found \(sut.value)")
        }
    }
    
    func test_nodes_before_and_on_value_is_highlighted() throws {
        let sut = makeSUT()
        sut.value = 2
        let nodesStatus = sut.nodes.map(\.isHighLighted)
        XCTAssertEqual(nodesStatus, [true,true,true,false,false])
    }
    
    // MARK: - test helper
    private func makeSUT() -> StepSliderCore {
        let sut = StepSliderCore()
        addTeardownBlock {
            [weak sut] in
            XCTAssertNil(sut)
        }
        return sut
    }
}

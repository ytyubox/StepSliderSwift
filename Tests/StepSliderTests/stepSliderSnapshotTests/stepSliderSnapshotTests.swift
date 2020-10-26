//
//  File.swift
//  
//
//  Created by 游宗諭 on 2020/10/18.
//

import XCTest

class stepSliderSnapshotTests: XCTestCase {
    @available(iOS 12.0, *)
    func test() throws {
        let sut = StepSliderSPY()
        sut.frame = CGRect(x: 0, y: 0, width: 200, height: 44)
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "StepSlider")
    }
}

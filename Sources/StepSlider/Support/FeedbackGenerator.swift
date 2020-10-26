//
//  File.swift
//  
//
//  Created by 游宗諭 on 2020/10/26.
//

import UIKit

class FeedbackGenerator {
    #if os(iOS)
    private lazy var feedback = UISelectionFeedbackGenerator()
    #endif
    func readyForAction() {
        #if os(iOS)
        feedback.prepare()
        #endif
    }
    func sendAction() {
        #if os(iOS)
        feedback.selectionChanged()
        #endif
    }
    func canSendAction() -> Bool {
        #if os(iOS)
        return !ProcessInfo.processInfo.isLowPowerModeEnabled
        #else
        return false
        #endif
    }
}

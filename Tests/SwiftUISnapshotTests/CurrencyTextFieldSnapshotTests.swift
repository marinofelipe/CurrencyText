//
//  CurrencyTextFieldSnapshotTests.swift
//
//
//  Created by Marino Felipe on 24.04.21.
//

import Combine
import SwiftUI
import XCTest

import CurrencyFormatter
import CurrencyTextFieldTestSupport

import SnapshotTesting

@testable import CurrencyTextField

@available(iOS 13.0, *)
final class CurrencyTextFieldSnapshotTests: XCTestCase {
    final class FakeViewModel: ObservableObject {
        @Published
        var text: String = ""
    }

    @ObservedObject
    private var fakeViewModel = FakeViewModel()

    func test() {
        fakeViewModel.text = "2345569"
        CurrencyFormatter.TestCase.allCases.forEach { testCase in
            let sut = CurrencyTextField(
                configuration: .makeFixture(
                    textBinding: $fakeViewModel.text,
                    formatter: testCase.formatter
                )
            ).frame(width: 300, height: 80)

            assertSnapshot(
                matching: sut,
                as: .image,
                named: "\(testCase.rawValue)"
            )
        }
    }

    func testWithCustomTextFiledConfiguration() {
        fakeViewModel.text = "2345569"
        let sut = CurrencyTextField(
            configuration: .makeFixture(
                textBinding: $fakeViewModel.text,
                formatter: CurrencyFormatter.TestCase.withDecimals.formatter,
                textFieldConfiguration: { textField in
                    textField.borderStyle = .roundedRect
                    textField.textAlignment = .center
                    textField.font = .preferredFont(forTextStyle: .body)
                    textField.textColor = .brown
                }
            )
        ).frame(width: 300, height: 80)

        assertSnapshot(
            matching: sut,
            as: .image
        )
    }
}

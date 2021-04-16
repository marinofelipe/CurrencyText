//
//  CurrencyTextFieldFormatter.swift
//  
//
//  Created by Marino Felipe on 12.04.21.
//

import CurrencyFormatter

@available(iOS 13.0, *)
public struct CurrencyTextFieldFormatter {
    let formatter: CurrencyFormatter

    /// Text field clears its text when value value is equal to zero.
    let clearsWhenValueIsZero: Bool

    public init(
        formatter: CurrencyFormatter,
        clearsWhenValueIsZero: Bool = false
    ) {
        self.formatter = formatter
        self.clearsWhenValueIsZero = clearsWhenValueIsZero
    }

    func editingChangedUpdatedFormattedText(
        isEditing: Bool,
        currentText: String?
    ) -> String? {
        guard isEditing == false else { return currentText }

        guard let text = currentText else { return currentText }

        if text.representsZero && clearsWhenValueIsZero {
            return nil
        } else if
            let adjustedText = formatter.formattedStringAdjustedToFitAllowedValues(from: text),
            adjustedText != text
        {
            return adjustedText
        } else {
            return text
        }
    }

    func unformattedValue(for text: String) -> String? {
        formatter.unformatted(string: text)
    }

    func double(for text: String) -> Double? {
        formatter.double(from: text)
    }

    func getUpdatedFormattedText(
        for value: String?,
        previousValue: String?
    ) -> String? {
        guard let value = value else { return "" }

        var updatedText = value

        if value.count == 1 && previousValue.isNilOrEmpty {
            updatedText = formatter.initialText + value
        } else if value.count == 1 {
            updatedText.removeLast()

            if updatedText.isEmpty {
                return updatedText
            } else {
                return formatter.formattedStringWithAdjustedDecimalSeparator(
                    from: updatedText
                )
            }
        } else if value.isEmpty {
            return value
        }

        let previousValueRange = value.range(of: previousValue ?? "")
        let diff = value.replacingOccurrences(
            of: previousValue ?? "",
            with: "",
            options: .literal,
            range: previousValueRange
        )

        guard diff.isEmpty == false || previousValue == nil else { return previousValue }

        guard diff.hasNumbers || previousValue == nil else {
            return addingNegativeSymbolIfNeeded(
                diffText: diff,
                previousText: previousValue ?? "",
                isChangedIndexTheLowerBound: previousValueRange?.contains(
                    (previousValue ?? "").startIndex
                ) == false
            )
        }

        if updatedText.numeralFormat().count > formatter.maxDigitsCount {
            updatedText.removeLast()
        }

        return formatter.formattedStringWithAdjustedDecimalSeparator(from: updatedText) ?? ""
    }

    private func addingNegativeSymbolIfNeeded(
        diffText: String,
        previousText: String,
        isChangedIndexTheLowerBound: Bool
    ) -> String {
        if diffText == .negativeSymbol && previousText.isEmpty {
            return .negativeSymbol
        } else if isChangedIndexTheLowerBound
                    && diffText == .negativeSymbol
                    && previousText.contains(String.negativeSymbol) == false {
            return .negativeSymbol + previousText
        } else {
            return previousText
        }
    }
}

extension Collection where Element: Equatable {
    func doesNotContain(item: Element) -> Bool {
        contains(item) == false
    }
}

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        switch self {
        case let .some(value):
            return value.isEmpty
        case .none:
            return true
        }
    }
}

//
//  Fixtures+CurrencyFormatter.swift
//  
//
//  Created by Marino Felipe on 25.04.21.
//

#if canImport(CurrencyFormatter)
import CurrencyFormatter
#endif

public extension CurrencyFormatter {
    enum TestCase: String, CaseIterable {
        case noDecimals
        case withDecimals
        case withMinMaxValues
        case yenJapanese
        case germanEuro

        public var formatter: CurrencyFormatter {
            switch self {
            case .noDecimals:
                return .init {
                    $0.currency = .dollar
                    $0.locale = CurrencyLocale.englishUnitedStates
                    $0.hasDecimals = false
                }
            case .withDecimals:
                return .init {
                    $0.currency = .dollar
                    $0.locale = CurrencyLocale.englishUnitedStates
                    $0.hasDecimals = true
                }
            case .withMinMaxValues:
                return .init {
                    $0.maxValue = 300
                    $0.minValue = 10
                    $0.currency = .dollar
                    $0.locale = CurrencyLocale.englishUnitedStates
                    $0.hasDecimals = true
                }
            case .yenJapanese:
                return .init {
                    $0.currency = .yen
                    $0.locale = CurrencyLocale.japaneseJapan
                    $0.hasDecimals = true
                }
            case .germanEuro:
                return .init {
                    $0.currency = .euro
                    $0.locale = CurrencyLocale.germanGermany
                    $0.hasDecimals = true
                }
            }
        }
    }
}

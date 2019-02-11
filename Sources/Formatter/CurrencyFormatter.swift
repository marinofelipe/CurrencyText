//
//  CurrencyFormatter.swift
//  CurrencyText
//
//  Created by Felipe Lefèvre Marino on 1/27/19.
//

public protocol CurrencyFormatterProtocol {
    var numberFormatter: NumberFormatter! { get set }
    var maxDigitsCount: Int { get }
    var decimalDigits: Int { get }
    var maxValue: Double? { get }
    var minValue: Double? { get }
    var initialText: String { get }
    
    func string(from double: Double?) -> String?
    func unformatted(string: String) -> String?
    func double(from string: String) -> Double?
    func updatedFormattedString(from string: String) -> String?
}

public class CurrencyFormatter: CurrencyFormatterProtocol {
    
    /// Set the locale to retrieve the currency from
    /// You can pass a Swift type Locale or one of the
    /// Locales enum options - that encapsulates all available locales
    public var locale: LocaleConvertible {
        set { self.numberFormatter.locale = newValue.locale }
        get { return self.numberFormatter.locale }
    }
    
    /// Set the locale to retrieve the currency from
    /// You can pass a Swift type Locale or one of the
    /// Locales enum options - that encapsulates all available locales
    public var currency: Currency {
        set { numberFormatter.currencyCode = newValue.rawValue }
        get { return Currency(rawValue: numberFormatter.currencyCode) ?? .dollar }
    }
    
    /// The lowest number allowed as input
    /// This value is initially set to the text field text
    /// when defined
    public var minValue: Double? {
        set {
            guard let newValue = newValue else { return }
            numberFormatter.minimum = NSNumber(value: newValue)
        }
        get {
            if let minValue = numberFormatter.minimum {
                return Double(truncating: minValue)
            }
            return nil
        }
    }
    
    /// The highest number allowed as input
    /// The text field will not allow the user to increase the input
    /// value beyond it, when defined
    public var maxValue: Double? {
        set {
            guard let newValue = newValue else { return }
            numberFormatter.maximum = NSNumber(value: newValue)
        }
        get {
            if let maxValue = numberFormatter.maximum {
                return Double(truncating: maxValue)
            }
            return nil
        }
    }
    
    /// The number of decimal digits shown
    /// default is set to zero
    /// * Example: With decimal digits set to 3, if the value to represent is "1",
    /// the formatted text in the fractions will be ",001".
    /// Other than that with the value as 1, the formatted text fractions will be ",1".
    public var decimalDigits: Int {
        set {
            numberFormatter.minimumFractionDigits = newValue
            numberFormatter.maximumFractionDigits = newValue
        }
        get { return numberFormatter.minimumFractionDigits }
    }
    
    /// Set decimal numbers behavior.
    /// When set to true decimalDigits are automatically set to 2 (most currencies pattern),
    /// and the decimal separator is presented. Otherwise decimal digits are not shown and
    /// the separator gets hidden as well
    /// When reading it returns the current pattern based on the setup.
    /// Note: Setting decimal digits after, or alwaysShowsDecimalSeparator can overlap this definitios,
    /// and should be only done if you need specific cases
    public var hasDecimals: Bool {
        set {
            self.decimalDigits = newValue ? 2 : 0
            self.numberFormatter.alwaysShowsDecimalSeparator = newValue ? true : false
        }
        get { return decimalDigits != 0 }
    }
    
    /// Value that will be presented when the text field
    /// text values matches zero (0)
    public var zeroSymbol: String?
    
    /// Value that will be presented when the text field
    /// is empty. The default is "" - empty string
    public var nilSymbol: String = ""
    
    /// Encapsulated Number formatter - TODO:
    public var numberFormatter: NumberFormatter!
    
    /// Maximum allowed number of integers
    public var maxIntegers: Int? {
        set {
            guard let maxIntegers = newValue else { return }
            numberFormatter.maximumIntegerDigits = maxIntegers
        }
        get { return numberFormatter.maximumIntegerDigits }
    }
    
    /// Returns the maximium allowed number of numerical characters
    public var maxDigitsCount: Int {
        return numberFormatter.maximumIntegerDigits + numberFormatter.maximumFractionDigits
    }
    
    /// Initial
    public var initialText: String {
        return string(from: 0) ?? "0.0"
    }
    
    //MARK: - INIT
    
    /// Handler to initialize a new style.
    public typealias InitHandler = ((CurrencyFormatter) -> (Void))
    
    /// Initialize a new currency formatter with optional configuration handler callback.
    ///
    /// - Parameter handler: configuration handler callback.
    public init(_ handler: InitHandler? = nil) {
        numberFormatter = NumberFormatter()
        numberFormatter.alwaysShowsDecimalSeparator = false
        numberFormatter.numberStyle = .currency
        
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumIntegerDigits = 1
        
        handler?(self)
    }
}

// MARK: Format
extension CurrencyFormatter {
    
    
    /// Returns a currency string from a given double value.
    ///
    /// - Parameter double: the monetary amount.
    /// - Returns: formatted currency string.
    public func string(from double: Double?) -> String? {
        return numberFormatter.string(from: double)
    }
    
    /// Returns a double from a string that represents a numerical value.
    ///
    /// - Parameter string: string that describes the numerical value.
    /// - Returns: the value as a Double.
    public func double(from string: String) -> Double? {
        return NumberFormatter().number(from: string)?.doubleValue
    }
    
    /// Receives a currency formatted string and returns its
    /// numerical/unformatted representation.
    ///
    /// - Parameter string: currency formatted string
    /// - Returns: numerical representation
    public func unformatted(string: String) -> String? {
        return string.numeralFormat()
    }
}

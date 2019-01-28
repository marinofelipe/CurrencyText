//
//  CurrencyFormatter.swift
//  CurrencyText
//
//  Created by Felipe Lefèvre Marino on 1/27/19.
//

public protocol CurrencyFormatterProtocol {
    var numberFormatter: NumberFormatter! { get set }
    var maxDigitsCount: Int { get }
    func string(from double: Double?) -> String?
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
    /// when set
    public var minValue: NSNumber? {
        set { numberFormatter.minimum = newValue }
        get { return numberFormatter.minimum }
    }
    
    /// The highest number allowed as input
    /// The text field will not allow the user to increase the input
    /// value beyond it, when defined
    public var maxValue: NSNumber? {
        set { numberFormatter.maximum = newValue }
        get { return numberFormatter.maximum }
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
    
    //MARK: - INIT
    
    /// Handler to initialize a new style.
    public typealias InitHandler = ((CurrencyFormatter) -> (Void))
    
    /// Initialize a new currency formatter with optional configuration handler callback.
    ///
    /// - Parameter handler: configuration handler callback.
    public init(_ handler: InitHandler? = nil) {
        numberFormatter = NumberFormatter()
        numberFormatter.alwaysShowsDecimalSeparator = true
        numberFormatter.numberStyle = .currency
        
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumIntegerDigits = 1
        
        handler?(self)
    }
}

// MARK: Format
extension CurrencyFormatter {
    public func string(from double: Double?) -> String? {
        return numberFormatter.string(from: double)
    }
}

// TODO: See if would be better to use an specify monetary type
//extension CurrencyFormatter: CustomStringConvertible {
//    var description: String {
//        return numberFormatter.string(from: <#T##Double?#>)
//    }
//}

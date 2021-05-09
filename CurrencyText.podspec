Pod::Spec.new do |s|
  s.name         = "CurrencyText"
  s.version      = "2.2.0"
  s.summary      = "Currency text formatter for UIKit and SwiftUI text fields."
  s.description  = <<-DESC
                     Provides a CurrencyText formatter (CurrencyFormatter sub-spec).

                     It can be optionally used alongside `CurrencyUITextField` a custom
                     UITextFieldDelegate to format UITextField inputs in UIKit.
                     (CurrencyUITextField sub-spec).

                     Or used in a `CurrencyTextField` for the same functionality in SwiftUI.
                     (CurrencyTextField sub-spec).
                   DESC

  s.homepage     = "https://github.com/marinofelipe/CurrencyText"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Felipe Lefèvre Marino" => "felipemarino91@gmail.com" }
  s.source       = { :git => "https://github.com/marinofelipe/CurrencyText.git", :tag => "#{s.version}" }
  s.ios.deployment_target = '11.0'
  
  s.swift_version = "5.3"
  s.source_files  = "Sources/**/*.swift"
  s.exclude_files = "Sources/CurrencyTextFieldTestSupport/*.swift"
  
  s.subspec 'CurrencyFormatter' do |ss|
      ss.requires_arc = true
      ss.source_files = "Sources/Formatter"
  end

  s.subspec 'CurrencyUITextField' do |ss|
      ss.requires_arc = true
      ss.source_files = "Sources/UITextFieldDelegate"
      ss.dependency 'CurrencyText/CurrencyFormatter'
  end

  s.subspec 'CurrencyTextField' do |ss|
      ss.requires_arc = true
      ss.source_files = "Sources/SwiftUI"
      ss.dependency 'CurrencyText/CurrencyFormatter'
      ss.dependency 'CurrencyText/CurrencyUITextField'
  end
end

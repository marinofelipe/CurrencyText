Pod::Spec.new do |s|
  s.name         = "CurrencyText"
  s.version      = "2.1.2"
  s.summary      = "Currency text formatter that fits your UITextField subclass."

  s.homepage     = "https://github.com/marinofelipe/CurrencyText"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Felipe Lefèvre Marino" => "felipemarino91@gmail.com" }
  s.source       = { :git => "https://github.com/marinofelipe/CurrencyText.git", :tag => "#{s.version}" }
  s.ios.deployment_target = '9.0'
  
  s.swift_version = "5.0"
  s.source_files  = "Sources/**/*.swift"
  
  s.subspec 'CurrencyFormatter' do |ss|
      ss.requires_arc = true
      ss.source_files = "Sources/Formatter"
  end

  s.subspec 'CurrencyUITextField' do |ss|
      ss.requires_arc = true
      ss.source_files = "Sources/UITextFieldDelegate"
      ss.dependency 'CurrencyText/CurrencyFormatter'
  end
end

Pod::Spec.new do |s|
  s.name         = "CurrencyText"
  s.version      = "1.0.2"
  s.summary      = "Currency text field formatter that fits your UITextField subclassing."

  s.homepage     = "https://github.com/marinofelipe/CurrencyText"
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "Felipe Lefèvre Marino" => "felipemarino91@gmail.com" }

  s.source       = { :git => "https://github.com/marinofelipe/CurrencyText.git", :tag => "#{s.version}" }

  s.ios.deployment_target = '9.0'

  s.swift_version = "4.2"
  s.source_files  = "Sources/**/*.swift"
end

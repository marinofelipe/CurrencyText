Pod::Spec.new do |s|
  s.name         = "UICurrencyTextField"
  s.version      = "1.0.1"
  s.summary      = "Formats text field text as currency"

  s.homepage     = "https://github.com/marinofelipe/UICurrencyTextField"
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "Felipe Lefèvre Marino" => "felipemarino91@gmail.com" }

  s.source       = { :git => "https://github.com/marinofelipe/UICurrencyTextField.git", :tag => "#{s.version}" }

  s.ios.deployment_target = '8.0'

  s.swift_version = "5.0"
  s.source_files  = "Sources/**/*.swift"
end

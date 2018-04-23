Pod::Spec.new do |s|
  s.name         = "UICurrencyTextField"
  s.version      = "0.0.1"
  s.summary      = "Currency text field written in Swift"

  s.homepage     = "https://github.com/marinofelipe/UICurrencyTextField"
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "Felipe Lefèvre Marino" => "felipemarino91@gmail.com" }

  s.source       = { :git => "https://github.com/marinofelipe/UICurrencyTextField", :tag => "#{s.version}"


  s.source_files  = "Classes", "Classes/**/*.swift"
end

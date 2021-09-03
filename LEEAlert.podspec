Pod::Spec.new do |s|

s.name         = "LEEAlert"
s.version      = "1.5.1"
s.summary      = "优雅的Alert ActionSheet"

s.homepage     = "https://github.com/lixiang1994/LEEAlert"

s.license      = "MIT"

s.author       = { "LEE" => "18611401994@163.com" }

s.platform     = :ios
s.platform     = :ios, "8.0"

s.source       = { :git => "https://github.com/lixiang1994/LEEAlert.git", :tag => s.version}

s.source_files  = "LEEAlert/**/*.{h,m}"

s.requires_arc = true

end

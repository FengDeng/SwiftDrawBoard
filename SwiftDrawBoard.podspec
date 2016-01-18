Pod::Spec.new do |s|
s.name             = "SwiftDrawBoard"
s.version          = "0.0.5"
s.summary          = "绘图"
s.description      = <<-DESC

绘图

DESC
s.license = 'MIT'
s.author           = { "邓锋" => "704292743@qq.com" }
s.homepage         = "https://github.com/FengDeng/HA"
s.source           = { :git => "git@github.com:FengDeng/SwiftDrawBoard.git",:tag => s.version}
s.platform     = :ios, '8.0'
s.requires_arc = true

s.source_files = 'SwiftDrawBoard/**/*.swift'

s.frameworks = 'Foundation','UIKit'

s.dependency 'UIColor_Hex_Swift', '~> 1.8'
s.dependency 'MJExtension', '~> 3.0.7'

end

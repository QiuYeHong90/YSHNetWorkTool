#
# Be sure to run `pod lib lint YSHNetWorkTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YSHNetWorkTool'
  s.version          = '0.0.1'
  s.summary          = 'PUT DELETE 方法请求的封装 和 PPNetworkHelper 搭配使用'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/QiuYeHong90/YSHNetWorkTool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '秋叶红' => '793983383@qq.com' }
  s.source           = { :git => 'https://github.com/QiuYeHong90/YSHNetWorkTool.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'YSHNetWorkTool/Classes/**/*'
  
  # s.resource_bundles = {
  #   'YSHNetWorkTool' => ['YSHNetWorkTool/Assets/*.png']
  # }

#   s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'YYKit'
   s.dependency 'AFNetworking'
   
end

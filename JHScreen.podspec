#
# Be sure to run `pod lib lint JHScreen.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JHScreen'
  s.version          = '0.1.0'
  s.summary          = '在iOS中实现简单的录屏操作.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
使用截屏之后，拼接成视频的原理，来实现录屏效果。
                       DESC

  s.homepage         = 'https://github.com/huos3203/JHScreen'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'huo3203@hotmail.com' => '724987481@qq.com' }
  s.source           = { :git => 'https://github.com/huos3203/JHScreen.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'JHScreen/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JHScreen' => ['JHScreen/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

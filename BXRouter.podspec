#
# Be sure to run `pod lib lint BXRouter.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BXRouter"
  s.version          = "1.0.0"
  s.summary          = "BXRouter is a iOS viewController transiton library."
  s.description      = "BXRouter is a iOS viewController transiton library. We can use alias to jump viewController, which can dynamic config from remote server."
  s.homepage         = "https://github.com/iException/BXRouter"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "phoebus" => "shaozhengxingok@126.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/BXRouter.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'BXRouter' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'BaixingSDK'
end

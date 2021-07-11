#
# Be sure to run `pod lib lint AMGifGenerator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AMGifGenerator'
  s.version          = '0.1.1'
  s.summary          = 'Easy and light-weight GIF encoder / decoder for iOS / iPadOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is light-weight GIF Animation generator written in Swift 5.0.
You can generate animated GIF from Data object or several images.
And set it to UIImageView to see and play animation.
Generating from video is not supported.
                       DESC

  s.homepage         = 'https://github.com/asamoya/AMGifGenerator'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kaname ohara' => 'kaname.ohara@gmail.com' }
  s.source           = { :git => 'https://github.com/asamoya/AMGifGenerator.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.1'
  s.swift_version = '5.0'
  s.source_files = 'AMGifGenerator/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AMGifGenerator' => ['AMGifGenerator/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

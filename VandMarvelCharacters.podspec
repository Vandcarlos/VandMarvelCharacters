#
# Be sure to run `pod lib lint VandMarvelCharacters.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VandMarvelCharacters'
  s.version          = '1.0.1'
  s.summary          = 'Marvel characters features'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
The character features, like list, details and favorite
                       DESC

  s.homepage         = 'https://github.com/Vandcarlos/VandMarvelCharacters'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Vandcarlos' => 'vandcarlosjunior@gmai.com' }
  s.source           = { :git => 'https://github.com/Vandcarlos/VandMarvelCharacters.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_versions = '5.0'

  s.subspec 'Core' do |ss|
    ss.source_files = 'VandMarvelCharacters/Classes/Core/**/*'
    ss.dependency 'Realm'
    ss.dependency 'RealmSwift'
  end

  s.subspec 'Features' do |ss|
    ss.source_files = 'VandMarvelCharacters/Classes/Features/**/*'
    ss.dependency 'VandMarvelCharacters/Core'
    ss.dependency 'VandMarvelUIKit'
    ss.dependency 'SnapKit', '~> 5.0.0'
  end

  s.dependency 'VandMarvelAPI'

end

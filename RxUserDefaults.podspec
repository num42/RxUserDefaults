#
# Be sure to run `pod lib lint RxUserDefaults.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RxUserDefaults'
  s.version          = '0.1.0'
  s.summary          = 'Wrapper for userDefaults with RxSwift support.'

  s.description      = "<<-DESC
  Wrapper for userDefaults with RxSwift support.
                         DESC"

  s.homepage         = 'https://github.com/num42/RxUserDefaults'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE.txt' }
  s.author           = { 'David Kraus' => 'kraus.david.dev@gmail.com' }
  s.source           = { :git => 'https://github.com/<GITHUB_USERNAME>/RxUserDefaults.git', :tag => s.version.to_s }
 

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'RxUserDefaults/Classes/**/*'
  
  s.dependency 'RxSwift', '~> 3.0.0-rc.1'
end

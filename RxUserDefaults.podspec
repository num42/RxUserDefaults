#
# Be sure to run `pod lib lint RxUserDefaults.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RxUserDefaults'
  s.version          = '5.0.1'
  s.summary          = 'Wrapper for userDefaults with RxSwift support.'

  s.description      = "<<-DESC
  Wrapper for userDefaults with RxSwift support.
                         DESC"

  s.homepage         = 'https://github.com/num42/RxUserDefaults'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'David Kraus' => 'kraus.david.dev@gmail.com',
                         'Hans-Martin Schuller' => 'hm.schuller@gmail.com',
                         'Wolfgang Lutz' => 'wolfgang@lutz-wiesent.de' }
  s.source           = { :git => 'https://github.com/num42/RxUserDefaults.git', :tag => s.version.to_s }

  s.swift_versions = ['5.0']

  s.ios.deployment_target = '10.3'
  s.tvos.deployment_target = '10.2'

  s.source_files = 'Sources/**/*'

  s.dependency 'RxSwift', '~> 5.0'
  s.dependency 'RxCocoa', '~> 5.0'
end

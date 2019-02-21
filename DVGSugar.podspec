Pod::Spec.new do |s|
  s.name             = "DVGSugar"
  s.version          = "0.0.2"
  s.summary          = "Collection of usefull microclasses"
  s.homepage         = "http://denivip.ru/"
  s.license          = 'GPL'
  s.author           = { 'DENIVIP' => 'support@denivip.ru' }
  s.source           = { :git => "https://github.com/denivip/DVGSugar.git" }

  s.platform     = :ios
  s.requires_arc = true
  #s.ios.vendored_frameworks = '???.framework'
  #s.ios.resources = 'Assets/*'
  #s.ios.frameworks = 'UIKit'
  #s.dependency 'PSTAlertController'
  #s.public_header_files = ...
  s.source_files = 'ClassesCommon/*'

  s.module_name = 'DVGSugar'
end

Pod::Spec.new do |s|
  s.name             = "DVGSugar"
  s.version          = "0.0.10"
  s.summary          = "Collection of usefull microclasses"
  s.homepage         = "http://denivip.ru/"
  s.license          = 'GPL'
  s.author           = { 'DENIVIP' => 'support@denivip.ru' }
  s.source           = { :git => "https://github.com/denivip/DVGSugar.git" }

  s.platform     = :ios
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  #s.ios.vendored_frameworks = '???.framework'
  #s.ios.resources = 'Assets/*'
  #s.ios.frameworks = 'UIKit'
  s.dependency 'libextobjc'

  #s.public_header_files = ...
  s.source_files = 'ClassesCommon/*'

  s.module_name = 'DVGSugar'
end

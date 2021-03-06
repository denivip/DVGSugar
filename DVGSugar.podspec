Pod::Spec.new do |s|
  s.name             = "DVGSugar"
  s.version          = "0.0.20"
  s.summary          = "Collection of usefull microclasses"
  s.homepage         = "http://denivip.ru/"
  s.license          = 'GPL'
  s.author           = { 'DENIVIP' => 'support@denivip.ru' }
  s.source           = { :git => "https://github.com/denivip/DVGSugar.git" }

  s.module_name = 'DVGSugar'
  s.platform     = :ios
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  #s.ios.vendored_frameworks = '???.framework'
  #s.ios.resources = 'Assets/*'
  #s.ios.frameworks = 'UIKit'
  s.dependency 'libextobjc'

  # https://miqu.me/blog/2016/11/28/app-extensions-xcode-and-cocoapods-omg/
  s.default_subspec = 'Core'
  s.subspec 'Core' do |core|
    #core.public_header_files = 'ClassesCommon/*.{h}'
    core.source_files = 'ClassesCommon/*.{m,h}'
  end

  s.subspec 'AppExtension' do |ext|
    #ext.public_header_files = 'ClassesCommon/*.{h}'
    ext.source_files = 'ClassesCommon/*.{m,h}'
    # For app extensions, disabling code paths using unavailable API
    ext.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'COMPILE_FOR_EXTENSION=1' }
  end

end

Pod::Spec.new do |s|
  s.name             = 'Cocarde'
  s.version          = '1.0.0'
  s.license          = 'MIT'
  s.summary          = 'Collection of animated pre-loaders in Swift'
  s.homepage         = 'https://github.com/yannickl/Cocarde.git'
  s.social_media_url = 'https://twitter.com/yannickloriot'
  s.authors          = { 'Yannick Loriot' => 'contact@yannickloriot.com' }
  s.source           = { :git => 'https://github.com/yannickl/Cocarde.git', :tag => s.version }

  s.ios.deployment_target = '8.0'

  s.framework    = 'AVFoundation'
  s.source_files = 'Cocarde/**/*.swift'
  s.requires_arc = true
end

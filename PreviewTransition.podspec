Pod::Spec.new do |s|
  s.name         = 'PreviewTransition'
  s.version      = '1.1.4'
  s.summary      = 'Transition animation'
  s.license      = 'MIT'
  s.homepage     = 'https://github.com/Ramotion/preview-transition'
  s.author       = { 'Juri Vasylenko' => 'juri.v@ramotion.com' }
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/Ramotion/preview-transition.git', :tag => s.version.to_s }
  s.source_files  = 'PreviewTransition/**/*.swift'
  s.requires_arc = true
end

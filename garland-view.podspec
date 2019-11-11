Pod::Spec.new do |s|
  s.name         = 'garland-view'
  s.version      = '1.0.0'
  s.summary      = 'Collection view controller with left and right animated transition.'
  s.homepage     = 'https://github.com/Ramotion/garland-view'
  s.license      = 'MIT'
  s.authors = { 'Igor Kolpachkov' => 'igor.k@ramotion.com' }
  s.ios.deployment_target = '10.0'
  s.source       = { :git => 'https://github.com/Ramotion/garland-view.git', :tag => s.version.to_s }
  s.source_files  = 'Sources/*.swift'
end

Pod::Spec.new do |s|
  s.name         = 'TFOptionsKit'
  s.version      = '2.0.0'
  s.license      = { :type => 'MIT' }
  s.homepage     = 'https://github.com/thefarm/TFOptionsKit'
  s.authors      = { 'Mikael Grön' => 'mikael@thefarm.se', 'Fredrik Palm' => 'fredrik@thefarm.se' }
  s.summary      = 'Enables you to define target specific options in your project'
  s.source       = { :git => 'https://github.com/TheFarm/TFOptionsKit.git', :tag => '2.0.0' }
  s.source_files = 'TFOptionsKit/TFOptionsKit.{h,m}'
  s.requires_arc = true
end

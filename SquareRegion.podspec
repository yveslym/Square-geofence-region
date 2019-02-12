Pod::Spec.new do |s|
  s.name             = 'SquareRegion'
  s.version          = '1.0.3.2'
  s.summary          = 'powerful  and efficient, lightweight iOS square region location for Geofence, alternative to circular region'
 s.swift_version    = '4.2'
  s.description      = <<-DESC
square region geofence is a lightweight geofence pod that allows you to cfreate a squared region which is an alternative to circular region.
                       DESC
 
  s.homepage         = 'https://github.com/yveslym/Square-geofence-region'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '<Yves Songolo>' => '<yves.songolo@gmail.com>' }
  s.source           = { :git => 'https://github.com/yveslym/Square-geofence-region.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'
  s.source_files = 'SquareRegion/*.{swift,h,m}'
 
end
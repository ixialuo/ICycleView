Pod::Spec.new do |s|

  s.name         = "ICycleView"
  s.version      = "1.0.2"
  s.summary      = "用UICollectionView实现的轮播图，支持单张图片、自定义cell等"
  s.homepage     = "https://github.com/ixialuo/ICycleView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "ixialuo" => "ixialuo@gmail.com" }
  s.social_media_url   = "https://ixialuo.com"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/ixialuo/ICycleView.git", :tag => s.version }
  s.source_files  = "Sources/*.swift"
  s.requires_arc = true
  s.dependency "Kingfisher"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

end

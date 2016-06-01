Pod::Spec.new do |s|

  s.name         = "DJCollectionViewVM"
  s.version      = "0.0.1"
  s.summary      = "DJCollectionViewVM is a ViewModel implemention for UICollectionView"
  s.description  = <<-DESC
                   only for private use,DJCollectionViewVM is a ViewModel implemention for UICollectionView
                   DESC

  s.homepage     = "http://douzhongxu.com"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Dokay" => "dokay.dou@gmail.com" }
  s.platform     = :ios, "6.0"

  s.source       = { :git => "git@bitbucket.org:dokay_ios/djcollectionviewvm.git", :tag => "0.0.1" }

  s.source_files  = "Classes", "DJCollectionViewVM/Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

  s.public_header_files = "DJCollectionViewVM/Classes/**/*.h"

  s.requires_arc = true

end

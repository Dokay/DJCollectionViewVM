Pod::Spec.new do |s|

  s.name         = "DJCollectionViewVM"
  s.version      = "0.0.2"
  s.summary      = "DJCollectionViewVM is a ViewModel implementation for UICollectionView"
  s.description  = <<-DESC
                   only for private use,DJCollectionViewVM is a ViewModel implementation for UICollectionView
                   DESC

  s.homepage     = "https://github.com/Dokay"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Dokay" => "dokay.dou@gmail.com" }
  s.platform     = :ios, "6.0"

  s.source       = { :git => "https://github.com/Dokay/DJCollectionViewVM.git", :tag => s.version.to_s }

  s.source_files  = "Classes", "DJCollectionViewVM/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

  s.public_header_files = "DJCollectionViewVM/**/*.h"

  s.requires_arc = true

end

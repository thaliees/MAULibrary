Pod::Spec.new do |spec|

  spec.name             = "MAULibrary"
  spec.version          = "1.2.2"
  spec.summary          = "Authentication and consumption library for the Profuturo MAU services"
  spec.static_framework = true
  spec.description      = "Authentication (UI) and consumption (functions calls) library for the Profuturo MAU services"
  spec.source           = { :git => "https://github.com/Profuturo-Afore/ios-gestion-autenticacion-universal-framework.git", :tag => "#{spec.version}" }
  spec.homepage         = "https://github.com/Profuturo-Afore/ios-gestion-autenticacion-universal-framework"
  spec.author           = { "Ángel Eduardo Domínguez Delgado" => "adomingd@everis.com" }
  spec.license          = "MIT"
  spec.platform         = :ios, "13.2"
  spec.swift_version    = "5.3"

  spec.source_files     = "MAULibrary/**/*.{swift}"
  spec.resources        = "MAULibrary/**/*.{lproj,storyboard,xcdatamodeld,xib,xcassets,json,ttf}"

  spec.dependency         'Alamofire', '4.8.1'
  spec.dependency         'AlamofireObjectMapper', '5.2.0'
  spec.dependency         'lottie-ios'
  spec.dependency         'ReachabilitySwift'
  spec.dependency         'SVPinView'
  spec.dependency         'FWFaceAuth', '3.0.0.2'
end

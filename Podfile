# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'secure-ios-app' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for secure-ios-app
  pod 'AGSAuth', '~> 0.1.0'
  pod 'SwiftKeychainWrapper'
  pod 'Alamofire', '~> 4.5'
  pod 'NotificationBannerSwift'
  pod 'RealmSwift'
  pod 'SCLAlertView', :git => 'https://github.com/vikmeup/SCLAlertView-Swift.git', :branch => 'master'
  pod 'Floaty', '~> 4.0.0'
  pod 'DTTJailbreakDetection'
  pod 'TrustKit'

  target 'secure-ios-appTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RealmSwift'
  end

  target 'secure-ios-appUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = ''
    end
end

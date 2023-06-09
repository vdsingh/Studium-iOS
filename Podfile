# Uncomment the next line to define a global platform for your project
platform :ios, '13.0.0'

target 'Studium' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

#Analytics
pod 'FirebaseAnalytics'
pod 'FirebaseCrashlytics'

#Data Management
pod 'RealmSwift'

#Google Authentication
pod 'GoogleSignIn'

#Facebook Authentication
pod 'FBSDKLoginKit'

#UI Related
pod 'SwipeCellKit'
pod 'CalendarKit'
pod 'ChameleonFramework/Swift', :git => 'https://github.com/wowansm/Chameleon.git', :branch => 'swift5'
pod 'Colorful'
pod 'FlexColorPicker'
pod 'FSCalendar'
pod 'RAMAnimatedTabBarController'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end

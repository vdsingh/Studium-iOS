# Uncomment the next line to define a global platform for your project
platform :ios, '15.0.0'

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
pod 'GoogleAPIClientForREST/Calendar'
pod 'GTMSessionFetcher/Core'

#Facebook Authentication
pod 'FBSDKLoginKit'

#UI Related
pod 'SwipeCellKit'
pod 'CalendarKit'
pod 'ChameleonFramework/Swift', :git => 'https://github.com/wowansm/Chameleon.git', :branch => 'swift5'
pod 'Colorful'
pod 'FlexColorPicker' # Color Picker Form Element
pod 'FSCalendar' # Calendar View
pod 'RAMAnimatedTabBarController' # Animated Tab Bar
pod 'SwiftEntryKit', '2.0.0' # Banners and Pop-Ups

#ChatGPT API
pod 'ChatGPTSwift', '~> 1.3.1'


end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end

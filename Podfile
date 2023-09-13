# Uncomment the next line to define a global platform for your project
platform :ios, '15.0.0'

target 'Studium' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

#Analytics
pod 'FirebaseAnalytics'
pod 'FirebaseCrashlytics'
pod 'FirebaseStorage'

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
pod 'CalendarKit', '1.1.0'
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
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end

post_install do |installer|
  installer.aggregate_targets.each do |target|
    target.xcconfigs.each do |variant, xcconfig|
      xcconfig_path = target.client_root + target.xcconfig_relative_path(variant)
      IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
    end
  end
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.base_configuration_reference.is_a? Xcodeproj::Project::Object::PBXFileReference
        xcconfig_path = config.base_configuration_reference.real_path
        IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
      end
    end
  end
end

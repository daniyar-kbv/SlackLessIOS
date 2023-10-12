platform :ios, '16.0'
use_frameworks!

def shared_pods
  # Reactive
  pod 'RxSwift'
  pod 'RxCocoa'
  
  # UI
  pod 'SnapKit'
  
  # Cache and Storage
  pod 'Cache'
  pod 'KeychainAccess'
  
  # Networking
  pod 'ReachabilitySwift'
  pod 'Alamofire'
  pod 'Moya/RxSwift'
  
  # Firebase
  pod 'FirebaseFirestore'
end

target 'SlackLess' do
  shared_pods
  
  # Cache and Storage
  pod 'Kingfisher'
  
  # Helpers
  pod 'SwiftFormat'
  pod 'IQKeyboardManagerSwift'
  
#  UI
  pod 'FittedSheets'
  
  # Firebase
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'FirebaseAppCheck'
end

target 'SLActivityReport' do
    shared_pods
end

target 'SLActivityMonitor' do
    shared_pods
end

target 'SLShieldConfiguration' do
    shared_pods
end

target 'SLShieldAction' do
    shared_pods
end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
               end
          end
   end
end

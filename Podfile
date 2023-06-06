platform :ios, '15.0'

target 'SlackLess' do
  use_frameworks!

  pod 'Alamofire'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SnapKit'
  pod 'IQKeyboardManagerSwift'
  pod 'Moya/RxSwift', '~> 14.0'
  pod 'SwiftFormat'

  # Pods for Cache
  pod 'Cache'
  pod 'Kingfisher', '~> 7.0'
  pod 'KeychainAccess'
  
  # Firebase
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  pod 'Firebase/Crashlytics'

  # Pod for observing internet connection
  pod 'ReachabilitySwift'

end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
               end
          end
   end
end
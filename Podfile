platform :ios, '13.0'
inhibit_all_warnings!

xcodeproj 'MyAPPProject.xcodeproj'

workspace 'MyAPPProject'
use_frameworks!
target 'MyAPPProject' do

  pod 'AFNetworking'
  pod 'MJRefresh'
  pod 'MJExtension'
  pod 'Masonry'
end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    # add 修改项目配置
    if target.platform_name == :ios
      target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0' # 将11.0替换为您需要的目标版本号
      end
    end
    # add end

  end
end

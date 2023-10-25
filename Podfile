 platform :ios, '12.0'

# 消除警告
inhibit_all_warnings!

# WechatOpenSDK 可在模拟器运行
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end

source 'https://github.com/CocoaPods/Specs.git'
target 'Immers' do

  pod 'AFNetworking'
  pod 'YYModel'
  pod 'YYText'
  pod 'YYWebImage'
  pod 'Masonry'
  pod 'SVProgressHUD'
  pod 'DZNEmptyDataSet'
  pod 'MQTTClient'
  pod 'CocoaAsyncSocket'
  pod 'AliyunOSSiOS' ,'2.10.13'
  pod 'MJRefresh'
  pod "GoldRaccoon"
  pod 'RSKImageCropper'
  pod 'Bugly'
  pod 'UMCommon'
  pod 'UMDevice'
  pod 'JCore', '3.2.3-noidfa'
  pod 'JPush', '4.8.0'

  # 第三方登录
  pod 'WechatOpenSDK'
#  pod 'FBSDKLoginKit'
  
end

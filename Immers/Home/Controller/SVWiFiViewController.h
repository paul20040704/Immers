//
//  SVWiFiViewController.h
//  Immers
//
//  Created by developer on 2022/5/19.
//

#import "SVBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 事件类型
typedef NS_ENUM(NSInteger, SVWiFiType) {
    SVWiFiTypeFirst = 100, // 首次设置Wi-Fi
    SVWiFiTypeReconnect, // 设备已经绑定，但断网了
    SVWiFiTypeOther, // 其他
};

@interface SVWiFiViewController : SVBaseViewController

/// Wi-Fi列表
/// @param type 类型
+ (instancetype)viewControllerWithType:(SVWiFiType)type;

/// 首次扫码到的设备信息
@property (nonatomic, strong) NSDictionary *parameter;
/// 设备信息
@property (nonatomic, copy) NSString *deviceId;
@end

NS_ASSUME_NONNULL_END

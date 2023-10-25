//
//  SVConnectViewController.h
//  Immers
//
//  Created by developer on 2022/5/19.
//

#import "SVBaseViewController.h"
#import "SVWiFi.h"

NS_ASSUME_NONNULL_BEGIN

/// 事件类型
typedef NS_ENUM(NSInteger, SVConnectType) {
    SVConnectTypeUDP = 100, // 首次设置Wi-Fi 走UDP
    SVConnectTypeMQTT, // 其他 走MQTT
};

@interface SVConnectViewController : SVBaseViewController

///  WiFi信息
@property (nonatomic, strong) SVWiFi *ssid;
/// 连接方式
@property (nonatomic, assign) SVConnectType type;
/// 设备ID
@property (nonatomic, copy) NSString *deviceId;
/// 已连接回调
@property (nonatomic, copy) void(^connectedCallback)(void);

/// 连接失败
@property (nonatomic, copy) void(^connectErrorCallback)(void);

@end

NS_ASSUME_NONNULL_END

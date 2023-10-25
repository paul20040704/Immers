//
//  SVUDPSocket.h
//  Immers
//
//  Created by developer on 2022/5/30.
//

#import <Foundation/Foundation.h>

#define kUDPSocketMsgTypeKey @"msgType"
#define kUDPSocketDataTypeKey @"data"

/// 获取Wi-Fi列表
#define kUDPSocketMsgGetWiFiListValue @"getWifiList"
/// Wi-Fi列表
#define kUDPSocketMsgWiFiListValue @"wifiList"
/// 设置 Wi-Fi
#define kUDPSocketMsgSetWiFiValue @"setWifi"
/// 连接wifi状态
#define kUDPSocketMsgConnectValue @"wifiConnect"

NS_ASSUME_NONNULL_BEGIN

@interface SVUDPSocket : NSObject

/// 单例
+ (instancetype)sharedSocket;

/// 发送消息
/// @param message 消息题
/// @param completion 完成回调
- (void)sendMessage:(NSDictionary *)message completion:(void(^)(long tag, NSError *_Nullable error))completion;

/// 接收消息
/// @param completion 完成回调
- (void)receiveMessage:(void(^)(long tag, NSDictionary *message))completion;

/// 关闭连接
- (void)close;

@end

NS_ASSUME_NONNULL_END

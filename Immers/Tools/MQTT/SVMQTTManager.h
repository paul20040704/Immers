//
//  SVMQTTManager.h
//  Immers
//
//  Created by developer on 2022/5/30.
//

#import <Foundation/Foundation.h>
#import "SVMQTTMacro.h"
#import "MQTTClient.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVMQTTManager : NSObject

/// MQTT 单例
+ (instancetype)sharedManager;

/// 连接
- (void)connect;

/// 断开
- (void)close;

/// 订阅设备
/// @param deviceId 设备id
- (void)subscribeDeviceId:(NSString *)deviceId;

/// 取消订阅
/// @param deviceId 设备id
- (void)unsubscribeDeviceId:(NSString *)deviceId;

/// 取消所有订阅
- (void)unsubscribeAllDevice;

/// 连接
/// @param handler 回调 error 有值代表错误
- (void)connectionHandler:(void(^)(NSError *_Nullable error))handler;

/// 发送控制消息
/// @param data 消息体
/// @param handler 回调
- (void)sendControl:(NSDictionary *)data handler:(nullable void(^)(NSError *error))handler;

/// 发信息
/// @param dict 消息体
/// @param topic 主题
/// @param handler 回调
- (void)sendMessage:(NSDictionary *)dict topic:(NSString *)topic handler:(nullable void(^)(NSError *error))handler;

/// 接收到消息
/// @param key 存储接收信息handle的key(正常用对象hash值)
/// @param handler 回调
- (void)receiveMessage:(NSInteger)key handler:(void(^)(NSDictionary *message))handler;

/// 删除回调
/// @param key 存储接收信息handle的key(正常用对象hash值)
- (void)removeHandler:(NSInteger)key;

/// 返回mqtt当前连接状态
/// @return sessionStatus MQTTSessionStatus
- (MQTTSessionStatus )sessionStatus;
@end

NS_ASSUME_NONNULL_END

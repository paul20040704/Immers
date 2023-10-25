//
//  SVMQTTManager.m
//  Immers
//
//  Created by developer on 2022/5/30.
//

#import "SVMQTTManager.h"
#import "SVGlobalMacro.h"

@interface SVMQTTManager () <MQTTSessionDelegate>

@property (nonatomic, strong) NSMutableDictionary<NSString *, void(^)(NSDictionary *message)> *handlers;
@property (nonatomic, strong)NSMutableArray *subscribeDeviceIds;
@end

@implementation SVMQTTManager {
    MQTTSession *_session;
    NSString *_currentId;
    void(^_connectionCompletion)(NSError *_Nullable error);
    NSUInteger _closedTimes;
    NSUInteger _errorTipCount;//未链接操作提示错误计数
}

//kMQTTPort = 1883;
//static UInt32 const kMQTTPort = 1882;
static NSString *const kMQTTUserName = @"admin";
//kMQTTPassword = @"public";
static NSString *const kMQTTPassword = @"dacheng123456";

/// MQTT 单例
+ (instancetype)sharedManager {
    static SVMQTTManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SVMQTTManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _session = [[MQTTSession alloc] init];
        // 设置签名， 签名唯一性
        //MQTTClient自身已经处理了
//        _session.clientId = [NSString stringWithFormat:@"iOS-%@", [UIDevice currentDevice].identifierForVendor.UUIDString];

        // 订阅主题
        MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc] init];
        // ip地址 / 端口号
        transport.host = kMQTTHost;
        transport.port = kMQTTPort;
        // 给 session 对象设置基本信息
        _session.transport = transport;
        // 设置代理 回调信息
        _session.delegate = self;
        // 设置用户名称
        _session.userName = kMQTTUserName;
        // 设置用户密码
        _session.password = kMQTTPassword;
        // 设置会话链接超时时间
//        [_session connect];
        _errorTipCount = 3;
        //开始连接
        [_session connectWithConnectHandler:^(NSError *error) {
            if (error) {
                DebugLog(@"connect 错误的信息:%@",error);
            } else {
                DebugLog(@"MQTT 链接成功了");
            }
            // 监听连接状态变化
            //[sself->_session addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionOld) context:nil];
        }];
        
        [MQTTLog setLogLevel:DDLogLevelDebug];
    }
    return self;
}

/// KVO 监听 status 变化
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context {
//    if (_session.status == MQTTSessionStatusClosed || _session.status == MQTTSessionStatusError) {
//        // 尝试重连 3秒一次
//        DebugLog(@"MQTT session connect 重连");
////        [_session connectAndWaitTimeout:3];
//        [_session connect];
//    }
//}

// MARK: - 公共方法
/// 连接
- (void)connect {
    if (MQTTSessionStatusConnected == _session.status) { return; }
    [_session connect];
    DebugLog(@"MQTT session 开始重连");
}

/// 断开
- (void)close {
    [self unsubscribeAllDevice];
    [_session closeWithDisconnectHandler:^(NSError *error) {
        DebugLog(@"MQTT session close %@", error);
    }];
}

- (void)unsubscribeAllDevice {
    [self.subscribeDeviceIds enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[NSString class]]){
            [self unsubscribeDeviceId:obj];
        }
    }];
}

/// 订阅设备
/// @param deviceId 设备id
- (void)subscribeDeviceId:(NSString *)deviceId {
    // 没有连接
    if (_session.status != MQTTSessionStatusConnected || nil == deviceId) { return; }
    
    // 主题
    NSString *deviceMsgTopic = [NSString stringWithFormat:@"%@%@/deviceMsg", kMQTTTopicDevice, deviceId];
    NSString *onlineTopic = kMQTTTopicStatusOnline;
    NSString *offlineTopic = kMQTTTopicStatusOffline;
    NSDictionary *topics = @{ deviceMsgTopic : @(MQTTQosLevelAtLeastOnce), onlineTopic: @(MQTTQosLevelAtLeastOnce), offlineTopic : @(MQTTQosLevelAtLeastOnce) };
    DebugLog(@"MQTT 订阅：%@", deviceId);
    DebugLog(@"MQTT subscribeToTopics：%@", topics);
//    DebugLog(@"MQTT 取消订阅：%@", _currentId);
    // 取消订阅之前设备
//    if (![deviceId isEqualToString:_currentId]) {
//        [self unsubscribeDeviceId:_currentId];
//    }
    // 记录设备id
    _currentId = deviceId;
    // 开始订阅
    kWself
    [_session subscribeToTopics:topics subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
        kSself
        if (error) {
            DebugLog(@"MQTT subscribeToTopics error: %@ gQoss: %@", error, gQoss);
        }else if(![sself.subscribeDeviceIds containsObject:deviceId]){
            [sself.subscribeDeviceIds addObject:deviceId];
        }
    }];
}

/// 取消订阅
/// @param deviceId 设备id
- (void)unsubscribeDeviceId:(NSString *)deviceId {
    if (nil == deviceId || deviceId.length <= 0) { return; }
    // 主题
    NSString *deviceMsgTopic = [NSString stringWithFormat:@"%@%@/deviceMsg", kMQTTTopicDevice, deviceId];
    NSArray <NSString *> *topics = @[deviceMsgTopic, kMQTTTopicStatusOnline, kMQTTTopicStatusOffline];
    // 取消订阅
    [_session unsubscribeTopics:topics];
    [self.subscribeDeviceIds removeObject:deviceId];
    DebugLog(@"MQTT unsubscribeTopics：%@", topics);
}

/// 连接
/// @param handler 回调 error 有值代表错误
- (void)connectionHandler:(void(^)(NSError *_Nullable error))handler {
    _connectionCompletion = handler;
}

/// 发送控制消息
- (void)sendControl:(NSDictionary *)data handler:(nullable void(^)(NSError *error))handler {
    if (_session.status != MQTTSessionStatusConnected) {
        _errorTipCount ++;
        if (_errorTipCount%3==0) {
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_poor_network")];
        }
        return;
    }
    NSString *fromId = [data objectForKey:kFromId];
    BOOL hadDeviceId = (fromId&&fromId.length>0);
    NSString *topic = [NSString stringWithFormat:@"%@%@/control", kMQTTTopicDevice, hadDeviceId?fromId:_currentId];
    [self sendMessage:data topic:topic handler:handler];
}


/// 发信息
- (void)sendMessage:(NSDictionary *)dict topic:(NSString *)topic handler:(nullable void(^)(NSError *error))handler {
    if (![dict isKindOfClass:[NSDictionary class]]) { return; }
    DebugLog(@"MQTT send： %@", dict);
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
    [_session publishData:data onTopic:topic retain:NO qos:MQTTQosLevelAtMostOnce publishHandler:handler];
}

/// 接收到消息
- (void)receiveMessage:(NSInteger)key handler:(void(^)(NSDictionary *message))handler {
    if (nil == handler) { return; }
    DebugLog(@"receiveMessage:%ld",key);
    NSString *cmdKey = [NSString stringWithFormat:@"%ld", key];
    [self.handlers setValue:handler forKey:cmdKey];
}

/// 删除回调
- (void)removeHandler:(NSInteger)key {
    NSString *cmdKey = [NSString stringWithFormat:@"%ld", key];
    [self.handlers removeObjectForKey:cmdKey];
    
    DebugLog(@"handlers: %@", self.handlers);
}

// MARK: - MQTTSessionDelegate
/// 收到消息
- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    if (nil == dict) { return; }
    for (void(^receiveHandler)(NSDictionary *message) in self.handlers.allValues) {
        if (receiveHandler) {
            receiveHandler(dict);
        }
    }
    DebugLog(@"MQTT receive：%@", dict);
}

//连接失败
- (void)handleEvent:(MQTTSession *)session event:(MQTTSessionEvent)eventCode error:(NSError *)error {
    if(session.status == MQTTSessionStatusClosed || session.status == MQTTSessionStatusError)
      {
          DebugLog(@"MQTT session connect 重连");
          [_session connectAndWaitTimeout:3];
      }
}

/// MQTT连接成功，进行订阅主题 设置主题 服务质量
- (void)connected:(MQTTSession *)session {
    DebugLog(@"MQTT connected 连接成功");
    _closedTimes = 0;
    [self.subscribeDeviceIds enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self subscribeDeviceId:obj];
    }];
    
    if (_connectionCompletion) {
        _connectionCompletion(nil);
    }
}

/// 连接失败
- (void)connectionError:(MQTTSession *)session error:(NSError *)error {
    DebugLog(@"MQTT connectionError 连接失败： %@", error);
    if (_closedTimes < 10000) {
        [session connectAndWaitTimeout:1];
        _closedTimes += 1;
    } else {
        if (_connectionCompletion) {
            _connectionCompletion(error);
        }
    }
}

- (MQTTSessionStatus )sessionStatus {
    return _session.status;
}

// MARK: - lazy
- (NSMutableDictionary<NSString *, void (^)(NSDictionary *)> *)handlers {
    if (!_handlers) {
        _handlers = [[NSMutableDictionary alloc] init];
    }
    return _handlers;
}

- (NSMutableArray *)subscribeDeviceIds {
    if (!_subscribeDeviceIds) {
        _subscribeDeviceIds = [[NSMutableArray alloc] init];
    }
    return _subscribeDeviceIds;;
}
@end

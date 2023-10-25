//
//  SVUDPSocket.m
//  Immers
//
//  Created by developer on 2022/5/30.
//

#import "SVUDPSocket.h"
#import "GCDAsyncUdpSocket.h"
#import "SVGlobalMacro.h"

@interface SVUDPSocket () <GCDAsyncUdpSocketDelegate>

@end

@implementation SVUDPSocket {
    void(^_sendCompletion)(long tag, NSError *_Nullable error);
    void(^_receiveCompletion)(long tag, NSDictionary *message);
}

static GCDAsyncUdpSocket *_udpSocket = nil;
static NSString *_host = @"192.168.43.1";
static uint16_t _port = 24680;

+ (instancetype)sharedSocket {
    static SVUDPSocket *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [instance prepareSocket];
    });
    return instance;
}

- (void)prepareSocket {
    // 创建一个 udp socket用来和服务器端进行通讯
    _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    [_udpSocket setIPv6Enabled:NO];
    // banding一个端口
    [_udpSocket bindToPort:_port error:&error];
    // 启用广播
    [_udpSocket enableBroadcast:YES error:&error];
    if (error) { // 监听错误打印错误信息
        DebugLog(@"udpSocket error:%@",error);
        
    } else { // 监听成功则开始接收信息
        [_udpSocket beginReceiving:&error];
        DebugLog(@"prepare udpSocket");
//        NSString *host = [_udpSocket connectedHost];1
//        DebugLog(@"udpSocket host %@", host);
    }
}

// MARK: - 公共方法
/// 发送消息
/// @param message 消息题
/// @param completion 完成回调
- (void)sendMessage:(NSDictionary *)message completion:(void(^)(long tag, NSError *error))completion {
    if (![message isKindOfClass:[NSDictionary class]]) { return; }
    if ([_udpSocket isClosed]) {
        [self prepareSocket];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:message options:NSJSONWritingPrettyPrinted error:NULL];
    _sendCompletion = completion;
    [_udpSocket sendData:data toHost:_host port:_port withTimeout:-1 tag:0];
}

/// 接收消息
/// @param completion 完成回调
- (void)receiveMessage:(void(^)(long tag, NSDictionary *message))completion {
    if ([_udpSocket isClosed]) {
        [self prepareSocket];
    }
    _receiveCompletion = completion;
}

/// 关闭连接
- (void)close {
    [_udpSocket close];
}

// MARK: - GCDAsyncUdpSocketDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
#ifdef DEBUG
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    DebugLog(@"UDP didConnectToAddress [%@:%d]", ip, port);
#else
#endif
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    if (_sendCompletion) {
        _sendCompletion(tag, nil);
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    DebugLog(@"发送失败 失败原因 %@", error);
    if (_sendCompletion) {
        _sendCompletion(tag, error);
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
#ifdef DEBUG
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
#else
#endif
    NSDictionary *message = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];

    [sock receiveOnce:nil];
    // 继续来等待接收下一次消息
    DebugLog(@"UDP 的响应 [%@:%d] %@", ip, port, message);

    if (_receiveCompletion) {
        _receiveCompletion(0, message);
    }
}


- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error {
    DebugLog(@"udpSocket关闭");
}


@end

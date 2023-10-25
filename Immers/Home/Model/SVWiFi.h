//
//  SVWiFi.h
//  Immers
//
//  Created by developer on 2022/6/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVWiFi : NSObject

/// ip
@property (nonatomic, copy) NSString *BSSID;
/// Wi-Fi名称
@property (nonatomic, copy) NSString *SSID;
/// 加密方式
@property (nonatomic, copy) NSString *capabilities;
/// 信号强度 0～4
@property (nonatomic, copy) NSString *level;
/// 当前连接Wi-Fi
@property (nonatomic, assign) BOOL current;

@end

NS_ASSUME_NONNULL_END

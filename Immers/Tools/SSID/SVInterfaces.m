//
//  SVInterfaces.m
//  Immers
//
//  Created by developer on 2022/6/9.
//

#import "SVInterfaces.h"
#import <CoreLocation/CoreLocation.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@interface SVInterfaces () <CLLocationManagerDelegate>

@end

@implementation SVInterfaces {
    CLLocationManager *_locationManager;
    void(^_interface)(NSString *ssid);
    void(^_denied)(void);
    BOOL _hasSSID;
}

/// 创建实例
+ (instancetype)interfaces {
    SVInterfaces *interfaces = [[SVInterfaces alloc] init];
    // 创建 定位
    interfaces->_locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    interfaces->_locationManager.delegate = interfaces;
    // 请求授权
    [interfaces->_locationManager requestWhenInUseAuthorization];
    // 开始定位
    [interfaces->_locationManager startUpdatingLocation];
    return interfaces;
}

/// 获取ssid
- (void)ssid:(void((^)(NSString *ssid)))interface denied:(void((^)(void)))denied {
    _hasSSID = NO;
    [_locationManager startUpdatingLocation];
    _interface = interface;
    _denied = denied;
}

/// 获取当前ssid
- (NSString *)ssid {
    return [self fetchInterfaces];
}

// MARK: - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (locations.count && NO == _hasSSID) {
        [manager stopUpdatingLocation];
        _hasSSID = YES;
        if (_interface) {
            NSString *ssid = [self fetchInterfaces];
            _interface(ssid);
        }
    }
}

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    CLAuthorizationStatus status;
    if (@available(iOS 14.0, *)) {
        status = _locationManager.authorizationStatus;
    } else {
        status = [CLLocationManager authorizationStatus];
    }

    if (kCLAuthorizationStatusNotDetermined == status) {
        // 尚未设置定位权限
        [manager requestWhenInUseAuthorization];
        
    }  else if (kCLAuthorizationStatusRestricted == status || kCLAuthorizationStatusDenied == status) {
        // 拒绝权限
        if (_denied) {
            _denied();
        }
    } else {
        // 其他就当已授权
        [manager requestLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (_denied) {
        _denied();
    }
}

// MARK: - SSID
- (NSString *)fetchInterfaces {
    NSArray <NSString *> *interfaces = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSDictionary *info = nil;
    for (NSString *inter in interfaces) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)inter);
        
        if (info && [info count]) { break; }
    }
    return info[@"SSID"];
}

@end

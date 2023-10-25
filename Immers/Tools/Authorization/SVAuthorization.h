//
//  SVAuthorization.h
//  Immers
//
//  Created by developer on 2022/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVAuthorization : NSObject


/// 相册授权
/// @param authorized 已授权
/// @param denied 拒绝
+ (void)albumAuthorization:(void(^)(void))authorized denied:(void(^)(void))denied;


/// 相机授权
/// @param authorized 已授权
/// @param denied 拒绝
+ (void)cameraAuthorization:(void(^)(void))authorized denied:(void(^)(void))denied;

@end

NS_ASSUME_NONNULL_END

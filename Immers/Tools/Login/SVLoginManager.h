//
//  SVLoginManager.h
//  Immers
//
//  Created by developer on 2022/6/13.
//

#import <Foundation/Foundation.h>
#import "SVGlobalMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVLoginManager : NSObject <WXApiDelegate>

/// 登录单例
+ (instancetype)sharedManager;

/// 第三方登录
/// @param event 事件
/// @param completion 回调
- (void)login:(SVButtonEvent)event completion:(void(^)(BOOL isSuccess, BOOL isCancelled, NSDictionary *parameters))completion;

@end

NS_ASSUME_NONNULL_END

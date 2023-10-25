//
//  SVAppService.h
//  Immers
//
//  Created by developer on 2022/6/1.
//

#import "SVNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVAppService : NSObject

/// 添加意见反馈
/// @param parameters 参数
/// @param completion 完成回调
+ (void)feedBack:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 校验app版本是否需要升级
/// @param parameters 参数
/// @param completion 完成回调
+ (void)version:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

@end

NS_ASSUME_NONNULL_END

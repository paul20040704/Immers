//
//  SVAppService.m
//  Immers
//
//  Created by developer on 2022/6/1.
//

#import "SVAppService.h"

@implementation SVAppService

/// 添加意见反馈
+ (void)feedBack:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"appFeedBack/addFeedBack" parameters:parameters completion:completion];
}

/// 校验app版本是否需要升级
+ (void)version:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"appVersion/checkVersion" parameters:parameters completion:completion];
}

@end

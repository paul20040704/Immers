//
//  SVAppViewModel.m
//  Immers
//
//  Created by developer on 2022/6/1.
//

#import "SVAppViewModel.h"
#import "SVAppService.h"


@implementation SVAppViewModel

/// 添加意见反馈
- (void)feedBack:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVAppService feedBack:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        (0 == errorCode) ? completion(YES, SVLocalized(@"tip_submission_succeed")) : completion(NO, info[KErrorMsg]);
    }];
}

/// 校验app版本是否需要升级
- (void)versionCompletion:(SVSuccessCompletion)completion {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *parameters = @{ @"appType" : @"0", @"systemType" : @"1", @"code" : version };
    [SVAppService version:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            self.versionInfo = [SVAppVersion yy_modelWithJSON:info];
            completion(YES, nil);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

@end

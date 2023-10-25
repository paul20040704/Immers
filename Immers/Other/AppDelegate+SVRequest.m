//
//  AppDelegate+SVRequest.m
//  Immers
//
//  Created by developer on 2022/12/24.
//

#import "AppDelegate+SVRequest.h"
#import "SVAppViewModel.h"
#import "SVUpdateVersionView.h"
@implementation AppDelegate (SVRequest)
- (void)updateVersion {
    BOOL privacyAdmit = [[NSUserDefaults standardUserDefaults] boolForKey:kPrivacyAdmit];
    if(!privacyAdmit){
        return;
    }
    SVAppViewModel *viewModel = [[SVAppViewModel alloc] init];
    __weak typeof(viewModel) weakModel = viewModel;
    [viewModel versionCompletion:^(BOOL isSuccess, NSString * _Nullable message) {
        if(isSuccess){
            NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSString *newVersion = weakModel.versionInfo.apkVersion;
            NSInteger cVersion = [[currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
            NSInteger nVersion =  [[newVersion stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
            if (nVersion > cVersion) {
                SVUpdateVersionView *versionView = [[SVUpdateVersionView alloc] initWithFrame:self.window.bounds];
                versionView.appVersion = weakModel.versionInfo;
                [self.window addSubview:versionView];

            }
        }
        
    }];

}
@end

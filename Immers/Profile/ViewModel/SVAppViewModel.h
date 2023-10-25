//
//  SVAppViewModel.h
//  Immers
//
//  Created by developer on 2022/6/1.
//

#import "SVBaseViewModel.h"
#import "SVAppVersion.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVAppViewModel : SVBaseViewModel

/// app版本信息
@property (nonatomic, strong) SVAppVersion *versionInfo;

/// 添加意见反馈
/// @param parameters 参数
/// @param completion 完成回调
- (void)feedBack:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 校验app版本是否需要升级
/// @param completion 完成回调
- (void)versionCompletion:(SVSuccessCompletion)completion;

@end

NS_ASSUME_NONNULL_END

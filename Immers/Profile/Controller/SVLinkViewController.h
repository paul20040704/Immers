//
//  SVLinkViewController.h
//  Immers
//
//  Created by developer on 2022/5/24.
//

#import "SVBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 绑定类型
typedef NS_ENUM(NSInteger, SVLinkType) {
    SVLinkTypeBind = 100, // 已绑定
    SVLinkTypeUnbind, // 未绑定
};

@interface SVLinkViewController : SVBaseViewController

+ (instancetype)viewControllerWithType:(SVLinkType)type;

/// 绑定 / 取消绑定成功回调
@property (nonatomic, copy) void(^bindCallback)(void);

@end

NS_ASSUME_NONNULL_END

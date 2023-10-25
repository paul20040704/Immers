//
//  SVForgotViewController.h
//  Immers
//
//  Created by developer on 2022/5/13.
//

#import "SVBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVForgotViewController : SVBaseViewController

/// 是否是绑定帐号
@property (nonatomic, assign) BOOL bind;

/// 绑定第三方登录需要的参数
@property (nonatomic, strong) NSDictionary *parameter;

@end

NS_ASSUME_NONNULL_END

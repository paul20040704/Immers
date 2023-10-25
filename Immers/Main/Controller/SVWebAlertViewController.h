//
//  SVWebAlertViewController.h
//  Immers
//
//  Created by developer on 2022/12/20.
//

#import "SVBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVWebAlertViewController : SVBaseViewController
@property (nonatomic,copy)void(^actionBlock)(NSInteger index);//0 取消;1 确认
@end

NS_ASSUME_NONNULL_END

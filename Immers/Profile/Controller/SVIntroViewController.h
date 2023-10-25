//
//  SVIntroViewController.h
//  Immers
//
//  Created by developer on 2022/5/25.
//

#import "SVBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 绑定类型
typedef NS_ENUM(NSInteger, SVIntroType) {
    SVIntroTypeProduct = 100, // 产品介绍
    SVIntroTypeCompany, // 公司介绍
};

@interface SVIntroViewController : SVBaseViewController

+ (instancetype)viewControllerWithType:(SVIntroType)type;

@end

NS_ASSUME_NONNULL_END

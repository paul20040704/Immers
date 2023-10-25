//
//  SVMoreLoginView.h
//  Immers
//
//  Created by developer on 2022/5/13.
//

#import <UIKit/UIKit.h>
#import "SVGlobalMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVMoreLoginView : UIView

/// 登录事件 回调
@property (nonatomic, copy) void(^loginCallback)(SVButtonEvent event);

@end

NS_ASSUME_NONNULL_END

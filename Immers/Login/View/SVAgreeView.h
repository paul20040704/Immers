//
//  SVAgreeView.h
//  Immers
//
//  Created by developer on 2022/5/13.
//

#import <UIKit/UIKit.h>
#import "SVGlobalMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVAgreeView : UIView

/// 同意协议 事件
@property (nonatomic, copy) void(^agreeCallback)(BOOL agree);

/// 点击用户协议/隐私政策
@property (nonatomic, copy) void(^webCallback)(SVButtonEvent event);

/// 默认状态
@property (nonatomic, copy) NSString *normalName;

@end

NS_ASSUME_NONNULL_END

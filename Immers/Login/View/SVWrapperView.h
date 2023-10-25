//
//  SVWrapperView.h
//  Immers
//
//  Created by developer on 2022/5/13.
//

#import <UIKit/UIKit.h>
#import "SVGlobalMacro.h"
#import "SVCodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVWrapperView : UIView

/// 按钮事件 回调
@property (nonatomic, copy) void(^eventCallback)(SVButtonEvent event, NSDictionary *_Nullable dict);

/// 同意协议/政策
- (void)agree:(void(^)(void))callback;

///更新TextField
-(void)updateCodeButton:(SVCodeModel *)codeModel;

@end

NS_ASSUME_NONNULL_END

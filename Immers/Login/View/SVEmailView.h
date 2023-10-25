//
//  SVEmailView.h
//  Immers
//
//  Created by developer on 2022/5/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVEmailView : UIView

/// 提交表单
- (void)submitForm:(void(^)(NSDictionary *parameter))completion;

@end

NS_ASSUME_NONNULL_END

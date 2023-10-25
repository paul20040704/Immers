//
//  SVPhoneView.h
//  Immers
//
//  Created by developer on 2022/5/14.
//

#import <UIKit/UIKit.h>
#import "SVTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVPhoneView : UIView

/// 提交表单
- (void)submitForm:(void(^)(NSDictionary *parameter))completion;

///更新TextField
-(void)updateTextField:(SVCodeModel *)model;
///
@property (nonatomic, strong) SVTextField *phoneField;
/// 顯示手機國碼選單
@property (nonatomic, copy) void(^codeCallback)(void);

@end

NS_ASSUME_NONNULL_END

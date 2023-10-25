//
//  SVTextField.h
//  Immers
//
//  Created by developer on 2022/5/14.
//

#import <UIKit/UIKit.h>
#import "SVCodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVTextField : UIView

/// 输入框
/// @param leftText 左边文本
/// @param placeholder 占位文本
/// @param type 键盘类型
+ (instancetype)textField:(NSString *)leftText placeholder:(NSString *)placeholder type:(UIKeyboardType)type;

+ (instancetype)textField:(NSString *)leftText placeholder:(NSString *)placeholder type:(UIKeyboardType)type textColor:(nullable UIColor *)textColor placeholderColor:(nullable UIColor *)placeholderColor;

+ (instancetype)textField:(NSString *)leftText countryId:(NSString *)countryId  placeholder:(NSString *)placeholder type:(UIKeyboardType)type;

/// 修改區碼按鈕圖片文字
-(void)setButtonText:(SVCodeModel *)codeModel;

/// 输入最大长度
@property (nonatomic, assign) NSUInteger maxLength;

/// 输入框文本
@property (nonatomic, copy) NSString *text;

/// 点击選擇手機國碼
@property (nonatomic, copy) void(^codeCallback)(void);

///國家Id
@property (nonatomic, copy) NSString *countryId;

@end

NS_ASSUME_NONNULL_END

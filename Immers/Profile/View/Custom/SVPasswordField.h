//
//  SVPasswordField.h
//  Immers
//
//  Created by developer on 2022/5/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVPasswordField : UIView

/// 密码输入框
/// @param title 标题
/// @param placeholder 占位文本
+ (instancetype)fieldWithTitle:(NSString *)title placeholder:(NSString *)placeholder;


/// 密码输入框
/// @param title 标题
/// @param placeholder 占位文本
/// @param secureTextEntry 是否密文
+ (instancetype)fieldWithTitle:(NSString *)title placeholder:(NSString *)placeholder secureTextEntry:(BOOL)secureTextEntry;


/// 输入框文本
@property (nonatomic, copy) NSString *text;

@end

NS_ASSUME_NONNULL_END

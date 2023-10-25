//
//  NSString+Extension.h
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)

/// MD5 加密字符串
- (NSString *)md5String;

/// 转换为Base64编码
 - (NSString *)base64EncodedString;

/// 将Base64编码还原
 - (NSString *)base64DecodedString;

/// 去除空格
- (NSString *)trimming;

/// 是否是手机号
- (BOOL)isMobileNumber;

/// 是否是密码
- (BOOL)isPassword;

/// 是否是身份证号
- (BOOL)isCardNumber;

/// 是否是邮箱号
- (BOOL)isEMailNumber;

/// 是否包含表情
- (BOOL)containsEmoji;

/// 当前app的版本
+ (NSString *)version;

/// byte to GB
+ (NSString *)byte2gb:(NSInteger )byte;

/// byte to MB
+ (NSString *)byte2mb:(NSInteger )byte;
@end

// MARK: - 富文本
@interface NSAttributedString (Extension)

/// 图文富文本
/// @param imageName 图片名
+ (NSAttributedString *)attributedText:(NSString *)imageName;

/// 图文富文本
/// @param imageName 图片名
/// @param offset 偏移量
+ (NSAttributedString *)attributedText:(NSString *)imageName offset:(CGFloat)offset;

/// 富文本
/// @param text 文本
/// @param color 颜色
/// @param font 字体大小
+ (NSMutableAttributedString *)attributedText:(NSString *)text color:(UIColor *)color font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END

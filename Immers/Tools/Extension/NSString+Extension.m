//
//  NSString+Extension.m
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import "NSString+Extension.h"
#import "CommonCrypto/CommonDigest.h"
#import "SVGlobalMacro.h"

@implementation NSString (Extension)

/// MD5 加密字符串
- (NSString *)md5String {
    const char *cString = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cString, (CC_LONG)strlen(cString), digest);
    NSMutableString *result = [[NSMutableString alloc] init];
    
    for(NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

/// 转换为Base64编码
- (NSString *)base64EncodedString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

/// 将Base64编码还原
- (NSString *)base64DecodedString {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

/// 去除空格
- (NSString *)trimming {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/// 是否是手机号
- (BOOL)isMobileNumber {
    //NSString *text = @"^((13[0-9])|(14[01｜(4-9)])|(15[(0-3)|(5-9)])|(16[2567])|(17[0-8])|(18[0-9])|(19[(0-3)|(5-9))]))\\d{8}$";
    NSString *text = @"^[0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", text];
    return [predicate evaluateWithObject:self];
}

/// 是否是密码
- (BOOL)isPassword {
//    NSString *text = @"^(?!^(\\d+|[a-zA-Z]+|[~!@#$%^&*?/]+)$)^[\\w~!@#$%^&*?/]{8,30}$";
    NSString *text = @"^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[a-zA-Z0-9]{8,30}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", text];
    return [predicate evaluateWithObject:self];
}

/// 是否是身份证号
- (BOOL)isCardNumber {
    NSString *text = @"^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", text];
    return [predicate evaluateWithObject:self];
}

/// 是否是邮箱号
- (BOOL)isEMailNumber {
    NSString *text = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", text];
    return [predicate evaluateWithObject:self];
}

/// 是否包含表情
- (BOOL)containsEmoji {
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        if (substring.length > 0) {
            const unichar hs = [substring characterAtIndex:0];
            
            if (0x2194 <= hs && hs <= 0x2199) {
                returnValue = YES;
            }
            
            if (0x23e9 <= hs && hs <= 0x23fa) {
                returnValue = YES;
            }
            
            if (0x2600 <= hs && hs <= 0x2604) {
                returnValue = YES;
            }
            
            if (0x2648 <= hs && hs <= 0x2653) {
                returnValue = YES;
            }
            
            if (0x26f0 <= hs && hs <= 0x26fd) {
                returnValue = YES;
            }
            
            if (hs == 0x203c || hs == 0x2049 || hs == 0x2122 || hs == 0x2139 || hs == 0x21a9 || hs == 0x21aa || hs == 0x23 || hs == 0x231a || hs == 0x231b || hs == 0x2328 || hs == 0x23cf || hs == 0x24c2 || hs == 0x25b6 || hs == 0x25c0 || hs == 0x260e || hs == 0x2611 || hs == 0x2614 || hs == 0x2615 || hs == 0x2618 || hs == 0x261d || hs == 0x2620 || hs == 0x2622 || hs == 0x2623 || hs == 0x2626 || hs == 0x262a || hs == 0x262e || hs == 0x262f || hs == 0x2638 || hs == 0x2639 || hs == 0x263a || hs == 0x2668 || hs == 0x267b || hs == 0x267f || hs == 0x2692 || hs == 0x2693 || hs == 0x2694 || hs == 0x2696 || hs == 0x2697 || hs == 0x2699 || hs == 0x269b || hs == 0x269c || hs == 0x26a0 || hs == 0x26a1 || hs == 0x26b0 || hs == 0x26b1 || hs == 0x26bd || hs == 0x26be || hs == 0x26c4 || hs == 0x26c5 || hs == 0x26c8 || hs == 0x26ce || hs == 0x26cf || hs == 0x26d1 || hs == 0x26d3 || hs == 0x26d4 || hs == 0x26e9 || hs == 0x26ea || hs == 0x2702 || hs == 0x2705 || hs == 0x2708 || hs == 0x2709 || hs == 0x270a || hs == 0x270b || hs == 0x270c || hs == 0x270d || hs == 0x270f || hs == 0x2712 || hs == 0x2714 || hs == 0x2716 || hs == 0x271d || hs == 0x2721 || hs == 0x2728 || hs == 0x2733 || hs == 0x2734 || hs == 0x2744 || hs == 0x2747 || hs == 0x274c || hs == 0x274e || hs == 0x2753 || hs == 0x2754 || hs == 0x2755 || hs == 0x2757 || hs == 0x2763 || hs == 0x2764 || hs == 0x2795 || hs == 0x2796 || hs == 0x2797 || hs == 0x27a1 || hs == 0x27b0 || hs == 0x27bf || hs == 0x2934 || hs == 0x2935 || hs == 0x2b05 || hs == 0x2b06 || hs == 0x2b07 || hs == 0x2b50 || hs == 0x2b55 || hs == 0x3030 || hs == 0x303d || hs == 0x3297 || hs == 0x3299 || hs == 0x2a || hs == 0xa9 || hs == 0xae || hs == 0xd83c || hs == 0xd83d || hs == 0xd83e || hs == 0x267e || hs == 0x25aa || hs == 0x25ab || hs == 0x265f || hs == 0x26ab || hs == 0x26aa || hs == 0x25fe || hs == 0x25fd || hs == 0x25fc || hs == 0x25fb || hs == 0x2b1b || hs == 0x2b1c || hs == 0x2660 || hs == 0x2663 || hs == 0x2665 || hs == 0x2666 || hs == 0xdc02 || hs == 0xde45 || hs == 0xdd96 || hs == 0xdc4c) {
                
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}

/// 当前app的版本
+ (NSString *)version {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    return [info objectForKey:@"CFBundleShortVersionString"];
}

/// byte to GB
+ (NSString *)byte2gb:(NSInteger )byte {
    return [NSString stringWithFormat:@"%.2fG",byte / (1024 * 1024 * 1024.0)];
}

/// byte to MB
+ (NSString *)byte2mb:(NSInteger )byte {
    return [NSString stringWithFormat:@"%.2fM",byte / (1024 * 1024.0)];
}
@end


// MARK: - 富文本
@implementation NSAttributedString (Extension)

/// 图文富文本
/// @param imageName 图片名
+ (NSAttributedString *)attributedText:(NSString *)imageName {
    return [self attributedText:imageName offset:0];
}

/// 图文富文本
/// @param imageName 图片名
/// @param offset 偏移量
+ (NSAttributedString *)attributedText:(NSString *)imageName offset:(CGFloat)offset {
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    UIImage *image = [UIImage imageNamed:imageName];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, offset, image.size.width, image.size.height);
    return [NSAttributedString attributedStringWithAttachment:attachment];
}

/// 富文本
/// @param text 文本
/// @param color 颜色
/// @param font 字体大小
+ (NSMutableAttributedString *)attributedText:(NSString *)text color:(UIColor *)color font:(UIFont *)font {
    return [[NSMutableAttributedString alloc] initWithString:text attributes:@{ NSForegroundColorAttributeName : color, NSFontAttributeName : font }];
}

@end

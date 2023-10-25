//
//  UIColor+Extension.m
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import "UIColor+Extension.h"

CGFloat colorComponentFrom(NSString *string, NSUInteger start, NSUInteger length) {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@implementation UIColor (Extension)

+ (UIColor *)colorWithHex:(UInt32)hex {
    return [UIColor colorWithHex:hex alpha:1.0];
}
+ (UIColor *)colorWithHex:(UInt32)hex alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((hex >> 16) & 0xFF)/255.0
                           green:((hex >> 8) & 0xFF)/255.0
                            blue:(hex & 0xFF)/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    CGFloat alpha, red, blue, green;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = colorComponentFrom(colorString, 0, 1);
            green = colorComponentFrom(colorString, 1, 1);
            blue  = colorComponentFrom(colorString, 2, 1);
            break;
            
        case 4: // #ARGB
            alpha = colorComponentFrom(colorString, 0, 1);
            red   = colorComponentFrom(colorString, 1, 1);
            green = colorComponentFrom(colorString, 2, 1);
            blue  = colorComponentFrom(colorString, 3, 1);
            break;
            
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = colorComponentFrom(colorString, 0, 2);
            green = colorComponentFrom(colorString, 2, 2);
            blue  = colorComponentFrom(colorString, 4, 2);
            break;
            
        case 8: // #AARRGGBB
            alpha = colorComponentFrom(colorString, 0, 2);
            red   = colorComponentFrom(colorString, 2, 2);
            green = colorComponentFrom(colorString, 4, 2);
            blue  = colorComponentFrom(colorString, 6, 2);
            break;
            
        default:
            return nil;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (NSString *)HEXString {
    UIColor* color = self;
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    return [NSString stringWithFormat:@"#%02X%02X%02X", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue
                         alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red/255.f
                           green:green/255.f
                            blue:blue/255.f
                           alpha:alpha];
}

+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue {
    return [self colorWithWholeRed:red
                             green:green
                              blue:blue
                             alpha:1.0];
}

/// 随机颜色
+ (UIColor *)randomColor {
    NSInteger aRedValue = arc4random_uniform(256) % 255;
    NSInteger aGreenValue = arc4random_uniform(256) % 255;
    NSInteger aBlueValue = arc4random_uniform(256) % 255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue / 255.0f green:aGreenValue / 255.0f blue:aBlueValue / 255.0f alpha:1.0f];
    return randColor;
}

/// 文本颜色
+ (UIColor *)textColor {
    return [UIColor colorWithHex:0x333333];
}

/// 主题颜色
+ (UIColor *)themeColor {
    return [UIColor colorWithHex:0x000000];
}

/// 草绿色
+ (UIColor *)grassColor {
    return [UIColor colorWithHex:0x26ee9f];
}

/// 草绿色
+ (UIColor *)grassColor3 {
    return [UIColor colorWithHex:0xa7e5cd];
}

/// 灰色 0x000000 0.3
+ (UIColor *)grayColor3 {
    return [UIColor colorWithHex:0x000000 alpha:0.3];
}

/// 灰色 0x000000 0.4
+ (UIColor *)grayColor4 {
    return [UIColor colorWithHex:0x000000 alpha:0.4];
}

/// 灰色 0x000000 0.5
+ (UIColor *)grayColor5 {
    return [UIColor colorWithHex:0x000000 alpha:0.5];
}

/// 灰色 0x000000 0.6
+ (UIColor *)grayColor6 {
    return [UIColor colorWithHex:0x000000 alpha:0.6];
}

/// 灰色 0x000000 0.7
+ (UIColor *)grayColor7 {
    return [UIColor colorWithHex:0x000000 alpha:0.7];
}

/// 灰色 0x000000 0.8
+ (UIColor *)grayColor8 {
    return [UIColor colorWithHex:0x000000 alpha:0.8];
}

/// 背景颜色 0xF8F8F8
+ (UIColor *)backgroundColor {
    return [UIColor colorWithHex:0xf8f8f8];
}

/// 不可点击颜色 0xA8A8A8
+ (UIColor *)disableColor {
    return [UIColor colorWithHex:0xA8A8A8];
}

/// 红色
+ (UIColor *)redButtonColor {
    return [UIColor colorWithHex:0xFE8383];
}

/// 渐变颜色
/// @param c1 从 c1 颜色
/// @param c2 到 c2 颜色
/// @param gradientType 渐变方式
/// @param size 渐变大小
+ (UIColor *)gradientFromColor:(UIColor *)c1 toColor:(UIColor *)c2 gradientType:(SVGradientType)gradientType size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    NSArray *colors = [NSArray arrayWithObjects:(id)c1.CGColor, (id)c2.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    
    CGPoint start;
    CGPoint end;
    
    switch (gradientType) {
        case SVGradientTypeTopToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, size.height);
            break;
            
        case SVGradientTypeLeftToRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, 0.0);
            break;
            
        case SVGradientTypeUpleftToLowright:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, size.height);
            break;
            
        case SVGradientTypeUprightToLowleft:
            start = CGPointMake(size.width, 0.0);
            end = CGPointMake(0.0, size.height);
            break;
            
        default:
            break;
    }
    
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}

/// 默认渐变颜色
/// @param gradientType 渐变方式
/// @param size 渐变大小
+ (UIColor *)gradientType:(SVGradientType)gradientType size:(CGSize)size {
    return [UIColor gradientFromColor:[UIColor colorWithHex:0xFF7500] toColor:[UIColor colorWithHex:0xFF0000] gradientType:gradientType size:size];
}

@end

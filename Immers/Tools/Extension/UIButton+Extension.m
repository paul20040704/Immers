//
//  UIButton+Extension.m
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import "UIButton+Extension.h"
#import "SVGlobalMacro.h"

@implementation UIButton (Extension)

/// 修改按钮样式
/// @param style 样式
/// @param space 间距
- (void)resetButtonStyle:(SVButtinStyle)style space:(CGFloat)space {
    
    CGFloat titleW = self.titleLabel.intrinsicContentSize.width;
    CGFloat titleH = self.titleLabel.intrinsicContentSize.height;
    CGFloat imageW = self.imageView.frame.size.width;
    CGFloat imageH = self.imageView.frame.size.height;
    
    if (self.imageView.image) {
        imageW = self.imageView.image.size.width;
        imageH = self.imageView.image.size.height;
    }
    
    UIEdgeInsets titleEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets contentEdgeInsets = UIEdgeInsetsZero;
    
    switch (style) {
        case SVButtinStyleDefault: { // 默认
            titleEdgeInsets = UIEdgeInsetsMake(0, space/2.f, 0, -space/2.f);
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.f, 0, space/2.f);
            contentEdgeInsets = UIEdgeInsetsMake(0, space/2.f, 0, space/2.f);
        }
            break;
        case SVButtinStyleRight: { // 图片右边
           titleEdgeInsets = UIEdgeInsetsMake(0, -imageW - space/2.f, 0, imageW + space/2.f);
            imageEdgeInsets = UIEdgeInsetsMake(0, titleW + space/2.f, 0, -titleW - space/2.f);
            contentEdgeInsets = UIEdgeInsetsMake(0, space/2.f, 0, space/2.f);
        }
            break;
        case SVButtinStyleTop: { // 图片上边
            titleEdgeInsets = UIEdgeInsetsMake(imageH/2.f + space/4.f, -imageW/2.f, -imageH/2.f - space/4.f, imageW/2.f);
            imageEdgeInsets = UIEdgeInsetsMake(-titleH/2.f - space/4.f, titleW/2.f, titleH/2.f + space/4.f, -titleW/2.f);
            
            CGFloat minimumW = imageW < titleW ? imageW : titleW;
            CGFloat minimumH = imageH < titleH ? imageH : titleH;
            contentEdgeInsets = UIEdgeInsetsMake((minimumH + space)/2.f, -minimumW/2.f, (minimumH + space)/2.f, -minimumW/2.f);
        }
            break;
        case SVButtinStyleBottom: { // 图片下边
            titleEdgeInsets = UIEdgeInsetsMake(-imageH/2.f - space/4.f, -imageW/2.f, imageH/2.f +space/4.f, imageW/2.f);
            imageEdgeInsets = UIEdgeInsetsMake(titleH/2.f + space/4.f, titleW/2.f, -titleH/2.f - space/4.f, -titleW/2.f);
            CGFloat minimumW = imageW < titleW ? imageW : titleW;
            CGFloat minimumH = imageH < titleH ? imageH : titleH;
            contentEdgeInsets = UIEdgeInsetsMake((minimumH + space)/2.f, -minimumW/2.f, (minimumH + space)/2.f, -minimumW/2.f);
        }
            break;
        default:
            break;
    }
    
    self.titleEdgeInsets = titleEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
    self.contentEdgeInsets = contentEdgeInsets;
}

- (void)setImageWithURL:(NSString *)url placeholder:(nullable UIImage *)placeholder {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
//    NSURL *imageURL = [NSURL URLWithString:(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL,kCFStringEncodingUTF8))];
#pragma clang diagnostic pop
    
//    [self sd_setImageWithURL:imageURL forState:UIControlStateNormal placeholderImage:placeholder];
}

/// 设置背景颜色
/// @param backgroundColor 背景颜色
/// @param state 状态
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setBackgroundImage:image forState:state];
}

/// 设置样式
- (void)setStyle {
    [self setBackgroundColor:[UIColor grayColor6] forState:UIControlStateNormal];
    [self setBackgroundColor:[UIColor themeColor] forState:UIControlStateSelected];
}

/// 设置状态
- (void)setButtonEnabled:(BOOL)enabled {
    self.selected = enabled;
    self.userInteractionEnabled = enabled;
}

/// 按钮
/// @param title 标题
/// @param titleColor 标题颜色
/// @param font 字体大小
+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font {
    return [self buttonWithTitle:title selectedTitle:nil normalColor:titleColor selectedColor:nil font:font];
}

/// 按钮
/// @param title 默认标题
/// @param normalColor 默认字体颜色
/// @param font 字体大小
+ (instancetype)buttonWithTitle:(nullable NSString *)title normalColor:(UIColor *)normalColor font:(UIFont *)font {
    return [self buttonWithTitle:title selectedTitle:nil normalColor:normalColor selectedColor:nil font:font];
}

/// 按钮
/// @param title 默认标题
/// @param selectedTitle 选中标题
/// @param normalColor 默认字体颜色
/// @param selectedColor 选中字体颜色
/// @param font 字体大小
+ (instancetype)buttonWithTitle:(NSString *)title selectedTitle:(nullable NSString *)selectedTitle normalColor:(UIColor *)normalColor selectedColor:(nullable UIColor *)selectedColor font:(UIFont *)font {
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = font;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    
    if (selectedTitle) {
        [button setTitle:selectedTitle forState:UIControlStateSelected];
    }
    if (selectedColor) {
        [button setTitleColor:selectedColor forState:UIControlStateSelected];
    }
    
    return button;
}

/// 按钮
/// @param imageName 图片名
+ (instancetype)buttonWithImageName:(NSString *)imageName {
    return [self buttonWithNormalName:imageName selectedName:nil];
}

/// 按钮
/// @param normalName 默认图片名
/// @param selectedName 选中图片名
+ (instancetype)buttonWithNormalName:(NSString *)normalName selectedName:(nullable NSString *)selectedName {
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:normalName] forState:UIControlStateNormal];
    
    if (selectedName) {
        [button setImage:[UIImage imageNamed:selectedName] forState:UIControlStateSelected];
    }
    
    return button;
}


+ (instancetype)buttonClose {
    return [self buttonWithImageName:@"close_button_icon"];
}

@end

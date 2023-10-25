//
//  SVPasswordView.m
//  Immers
//
//  Created by developer on 2022/5/13.
//

#import "SVPasswordView.h"
#import "SVGlobalMacro.h"

static NSString  *const kPassworkNumbers = @"0123456789";

@interface SVPasswordView ()

@property (nonatomic, assign) CGFloat pointRadius; // 圆点半径
@property (nonatomic, strong) UIColor *pointColor; // 黑点的颜色
@property (nonatomic, strong) UIColor *rectColor;  // 边框的颜色

@end

@implementation SVPasswordView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textStore = [NSMutableString string];
        self.passworkCount = 6;
        self.pointRadius = 8.0;
        self.pointColor = [UIColor blackColor];
        self.rectColor = [UIColor colorWithHex:0xAAAAAA];
        self.backgroundColor = [UIColor whiteColor];
        [self becomeFirstResponder];
    }
    return self;
}

/// MARK: - UIKeyInput
/**
 *  用于显示的文本对象是否有任何文本
 */
- (BOOL)hasText {
    return self.textStore.length > 0;
}

/**
 *  插入文本
 */
- (void)insertText:(NSString *)text {
    if (self.textStore.length < self.passworkCount) {
        // 判断是否是数字
        NSCharacterSet *character = [[NSCharacterSet characterSetWithCharactersInString:kPassworkNumbers] invertedSet];
        NSString *filtered = [[text componentsSeparatedByCharactersInSet:character] componentsJoinedByString:@""];
        BOOL equal = [text isEqualToString:filtered];
        if(equal) {
            [self.textStore appendString:text];
            if ([self.delegate respondsToSelector:@selector(passworkViewDidChange:)]) {
                [self.delegate passworkViewDidChange:self];
            }
            if (self.textStore.length == self.passworkCount) {
                if ([self.delegate respondsToSelector:@selector(passworkViewCompleteInput:)]) {
                    [self.delegate passworkViewCompleteInput:self];
                }
            }
            [self setNeedsDisplay];
        }
    }
}

/**
 *  删除文本
 */
- (void)deleteBackward {
    if (self.textStore.length > 0) {
        [self.textStore deleteCharactersInRange:NSMakeRange(self.textStore.length - 1, 1)];
        if ([self.delegate respondsToSelector:@selector(passworkViewDidChange:)]) {
            [self.delegate passworkViewDidChange:self];
        }
    }
    [self setNeedsDisplay];
}

- (void)deleteTextStore {
    NSInteger length = self.textStore.length;
    for (NSInteger index = 0; index < length; index++) {
        [self deleteBackward];
    }
}

// MARK: -
/**
 *  设置密码的位数
 */
- (void)setPassworkCount:(NSUInteger)passworkCount {
    _passworkCount = passworkCount;
    [self setNeedsDisplay];
}

// MARK: -  drawRect
- (void)drawRect:(CGRect)rect {
    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;
    
    CGFloat w = width / self.passworkCount;
    CGFloat h = height;
    
    CGFloat x = (width - w * self.passworkCount) * 0.5;
    CGFloat y = (height - h) * 0.5;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, CGRectMake(x, y, w * self.passworkCount, h));
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, self.rectColor.CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
   // 画竖条
    for (NSInteger index = 1; index <= self.passworkCount; index++) {
        CGContextMoveToPoint(context, x + index * w, y);
        CGContextAddLineToPoint(context, x + index * w, y + h);
        CGContextClosePath(context);
    }
    
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextSetFillColorWithColor(context, self.pointColor.CGColor);
    
    // 画黑点
     for (NSInteger index = 1; index <= self.textStore.length; index++) {
         CGContextAddArc(context, x + index * w - w * 0.5, y + h * 0.5, self.pointRadius, 0, M_PI * 2, YES);
         CGContextDrawPath(context, kCGPathFill);
     }
}

// MARK: - 键盘
/**
 *  设置键盘的类型
 */
- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeNumberPad;
}

/**
 *  是否能成为第一响应者
 */
- (BOOL)canBecomeFirstResponder {
    return YES;
}

/**
 * 成为第一响应者
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
}

- (BOOL)becomeFirstResponder {
    if ([self.delegate respondsToSelector:@selector(passworkViewBeginInput:)]) {
        [self.delegate passworkViewBeginInput:self];
    }
    return [super becomeFirstResponder];
}

@end


// MARK: - 明文密码框
@implementation SVPasscodeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textStore = [NSMutableString string];
        self.passcodeCount = 4;
        self.space = kWidth(25);
        self.font = [UIFont boldSystemFontOfSize:20];
        self.backgroundColor = [UIColor whiteColor];
        [self becomeFirstResponder];
        
        UIButton *button = [[UIButton alloc] init];
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)buttonAction {
    [self becomeFirstResponder];
}

// MARK: - UIKeyInput
/// 用于显示的文本对象是否有任何文本
- (BOOL)hasText {
    return self.textStore.length > 0;
}

/// 插入文本
- (void)insertText:(NSString *)text {
    if (self.textStore.length < self.passcodeCount) {
        // 判断是否是数字
        NSCharacterSet *character = [[NSCharacterSet characterSetWithCharactersInString:kPassworkNumbers] invertedSet];
        NSString *filtered = [[text componentsSeparatedByCharactersInSet:character] componentsJoinedByString:@""];
        BOOL equal = [text isEqualToString:filtered];
        if(equal) {
            [self.textStore appendString:text];
            if ([self.delegate respondsToSelector:@selector(passcodeViewDidChange:)]) {
                [self.delegate passcodeViewDidChange:self];
            }
            if (self.textStore.length == self.passcodeCount) {
                if ([self.delegate respondsToSelector:@selector(passcodeViewCompleteInput:)]) {
                    [self.delegate passcodeViewCompleteInput:self];
                }
            }
            [self setNeedsDisplay];
        }
    }
}

/// 删除文本
- (void)deleteBackward {
    if (self.textStore.length > 0) {
        [self.textStore deleteCharactersInRange:NSMakeRange(self.textStore.length - 1, 1)];
        if ([self.delegate respondsToSelector:@selector(passcodeViewDidChange:)]) {
            [self.delegate passcodeViewDidChange:self];
        }
    }
    [self setNeedsDisplay];
}

- (void)deleteTextStore {
    NSInteger length = self.textStore.length;
    for (NSInteger index = 0; index < length; index++) {
        [self deleteBackward];
    }
}

// MARK: -
/// 设置密码的位数
- (void)setPasscodeCount:(NSUInteger)passcodeCount {
    _passcodeCount = passcodeCount;
    [self setNeedsDisplay];
}

// MARK: -  drawRect
- (void)drawRect:(CGRect)rect {
    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;
    
    CGFloat w = (width - ((self.passcodeCount - 1) * self.space)) / self.passcodeCount;
    CGFloat h = (height - 1);
    CGFloat y = h;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor3].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
   // 绘制横线
    for (NSInteger index = 0; index < self.passcodeCount; index++) {
        CGContextMoveToPoint(context, (index * (self.space + w)) , y);
        CGContextAddLineToPoint(context, (index * (self.space + w) + w), y);
        CGContextClosePath(context);
    }
    
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextSetFillColorWithColor(context, [UIColor textColor].CGColor);
    
    // 绘制文本
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{ NSFontAttributeName : self.font, NSParagraphStyleAttributeName : style };
    
     for (NSInteger index = 0; index < self.textStore.length; index++) {
         NSString *text = [self.textStore substringWithRange:NSMakeRange(index, 1)];
         CGRect rect = CGRectMake((index * (self.space + w)), height*0.3, w, h-2);
         [text drawInRect:rect withAttributes:attributes];
     }
}

// MARK: - 键盘
/// 设置键盘的类型
- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeNumberPad;
}

/// 是否能成为第一响应者
- (BOOL)canBecomeFirstResponder {
    return YES;
}

/// 成为第一响应者
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
}

- (BOOL)becomeFirstResponder {
    if ([self.delegate respondsToSelector:@selector(passcodeViewBeginInput:)]) {
        [self.delegate passcodeViewBeginInput:self];
    }
    return [super becomeFirstResponder];
}

@end

//
//  UITextView+Extension.m
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)

- (void)placeholderWith:(NSString *)placeholder szie:(NSInteger)fontSzie color:(UIColor *)textColor {
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:placeholder attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:fontSzie], NSForegroundColorAttributeName : textColor}];
    
    SEL selector = NSSelectorFromString(@"setAttributedPlaceholder:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UITextView instanceMethodSignatureForSelector:selector]];
    
    [invocation setSelector:selector];
    [invocation setArgument:&string atIndex:2];
    [invocation invokeWithTarget:self];
}

- (void)textMaxLength:(NSInteger)length {
    UITextRange *selectedRange = [self markedTextRange];
    // 获取高亮部分
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
   // 如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && position) {
        return;
    }
    
    if (self.text.length > length) {
        self.text = [self.text substringToIndex:length];
    }
}

@end

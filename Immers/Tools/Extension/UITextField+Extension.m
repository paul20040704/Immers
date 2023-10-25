//
//  UITextField+Extension.m
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)

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

+ (instancetype)textFieldWithPlaceholder:(NSString *)placeholder type:(UIKeyboardType)type textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor {
    UITextField *textField = [[UITextField alloc] init];
    textField.textColor = textColor;
    textField.placeholder = placeholder;
    textField.keyboardType = type;
    textField.backgroundColor = backgroundColor;
    return textField;
}

@end

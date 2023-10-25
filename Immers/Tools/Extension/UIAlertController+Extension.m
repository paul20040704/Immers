//
//  UIAlertController+Extension.m
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import "UIAlertController+Extension.h"
#import "SVGlobalMacro.h"

@implementation UIAlertController (Extension)

/// 弹窗
/// @param title 标题
/// @param message 信息
/// @param cancelText 取消文本
/// @param doneText 确定文本
/// @param cancelAction 取消事件
/// @param doneAction 确定事件
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message cancelText:(nullable NSString *)cancelText doneText:(nullable NSString *)doneText cancelAction:(nullable void(^)(UIAlertAction *action))cancelAction doneAction:(nullable void(^)(UIAlertAction *action))doneAction {
    
    UIAlertController *viewController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleCancel handler:cancelAction];
    UIAlertAction *actionDone = [UIAlertAction actionWithTitle:doneText style:UIAlertActionStyleDefault handler:doneAction];
    
    [actionCancel setValue:[UIColor themeColor] forKey:@"titleTextColor"];
    
    UIViewController *cancelController = [[UIViewController alloc] init];
    cancelController.view.backgroundColor = [UIColor themeColor];
    UILabel *label = [[UILabel alloc] init];
    label.font = kBoldFont(16);
    label.textColor = [UIColor whiteColor];
    label.text = doneText;
    label.textAlignment = NSTextAlignmentCenter;
    [cancelController.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cancelController.view);
    }];
    
    [actionDone setValue:cancelController forKey:@"contentViewController"];
    
    [viewController addAction:actionCancel];
    [viewController addAction:actionDone];
    
    return viewController;
}

@end

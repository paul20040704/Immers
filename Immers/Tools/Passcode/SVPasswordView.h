//
//  SVPasswordView.h
//  Immers
//
//  Created by developer on 2022/5/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SVPasswordView;

@protocol  SVPasswordViewDelegate <NSObject>
@optional

/// 监听输入的改变
- (void)passworkViewDidChange:(SVPasswordView *)passworkView;

/// 监听输入的完成时
- (void)passworkViewCompleteInput:(SVPasswordView *)passworkView;

/// 监听开始输入
- (void)passworkViewBeginInput:(SVPasswordView *)passworkView;

@end

@interface SVPasswordView : UIView <UIKeyInput>

/// 密码位数  默认6位
@property (nonatomic, assign) NSUInteger passworkCount;

/// 密码
@property (nonatomic, copy, readonly) NSMutableString *textStore;

/// 代理
@property (nonatomic, weak) id<SVPasswordViewDelegate> delegate;

/// 删除文本
- (void)deleteTextStore;

@end

// MARK: - 明文密码框
@class SVPasscodeView;

@protocol  SVPasscodeViewDelegate <NSObject>
@optional

/// 监听输入的改变
- (void)passcodeViewDidChange:(SVPasscodeView *)passcodeView;

/// 监听输入的完成时
- (void)passcodeViewCompleteInput:(SVPasscodeView *)passcodeView;

/// 监听开始输入
- (void)passcodeViewBeginInput:(SVPasscodeView *)passcodeView;

@end

@interface SVPasscodeView : UIView <UIKeyInput>

/// 密码位数  默认4位
@property (nonatomic, assign) NSUInteger passcodeCount;

/// 间距
@property (nonatomic, assign) CGFloat space;

/// Code 字体
@property (nonatomic, strong) UIFont *font;

/// 密码
@property (nonatomic, copy, readonly) NSMutableString *textStore;

/// 代理
@property (nonatomic, weak) id<SVPasscodeViewDelegate> delegate;

/// 删除文本
- (void)deleteTextStore;

@end


NS_ASSUME_NONNULL_END

//
//  SVPickerViewController.h
//  Immers
//
//  Created by developer on 2022/5/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVPickerViewController : UIImagePickerController

@property (nonatomic, assign) BOOL transfer;

/// 创建图片选择器 默认 UIImagePickerControllerSourceTypeCamera
/// @param completion 完成回调
+ (instancetype)pickerViewController:(void(^)(UIImage *image))completion;

/// 创建图片选择器
/// @param sourceType 数据来源
/// @param completion 完成回调
+ (instancetype)pickerViewControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType completion:(void(^)(UIImage *image))completion;

+ (instancetype)pickerViewControllerWithTransferCompletion:(void(^)(NSInteger type,NSString *url))completion;

@end

NS_ASSUME_NONNULL_END

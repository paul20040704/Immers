//
//  UIImageView+Extension.h
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Extension)

/// 设置图片
/// @param url 图片路径
/// @param placeholder 占位图片
- (void)setImageWithURL:(NSString *)url placeholder:(nullable UIImage *)placeholder;

/// 创建视图
+ (instancetype)imageView;

/// 创建视图
/// @param imageName 图片名
+ (instancetype)imageViewWithImageName:(NSString *)imageName;

/// 设置图片(获取视频第一帧)
/// @param videoURL 图片路径
/// @param placeHolder 占位图片
- (void)setVideoPreViewImageURL:(NSString *)videoURL placeHolderImage:(nullable UIImage *)placeHolder;
@end

NS_ASSUME_NONNULL_END

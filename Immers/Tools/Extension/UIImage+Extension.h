//
//  UIImage+Extension.h
//  Immers
//
//  Created by developer on 2022/5/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extension)

- (UIImage *)blurLevel:(CGFloat)blur;

+ (void)resetUpImageSize:(UIImage *)image;

- (UIImage*)fixOrientation:(UIImage*)image;

- (UIImage*)resizeImageWithSize:(CGSize)newSize;

@end

NS_ASSUME_NONNULL_END

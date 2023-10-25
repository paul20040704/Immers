//
//  UIImageView+Extension.m
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import "UIImageView+Extension.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>
#import "YYWebImage.h"

@implementation UIImageView (Extension)

/// 设置图片
/// @param url 图片路径
/// @param placeholder 占位图片
- (void)setImageWithURL:(NSString *)url placeholder:(nullable UIImage *)placeholder {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    NSURL *imageURL = [NSURL URLWithString:(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL,kCFStringEncodingUTF8))];
#pragma clang diagnostic pop
    
    [self yy_setImageWithURL:imageURL placeholder:placeholder options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation completion:nil];
}

/// 创建视图
+ (instancetype)imageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    return imageView;
}

/// 创建视图
/// @param imageName 图片名
+ (instancetype)imageViewWithImageName:(NSString *)imageName {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    return imageView;
}

- (void)setVideoPreViewImageURL:(NSString *)videoURL placeHolderImage:(UIImage *)placeHolder
{
    //获取缓存图片
   UIImage *image =  [[YYImageCache sharedCache] getImageForKey:videoURL];
    if(image){
        self.image = image;
    }else{
        //获取视频第一帧
        [self getVideoFirstViewImage:videoURL placeHolderImage:placeHolder];
    }
}

// 获取视频第一帧
- (void)getVideoFirstViewImage:(NSString *)videoURL placeHolderImage:(UIImage *)placeHolder {
   
    NSString *url = videoURL;//[NSString stringWithFormat:@"%@?flag=2",videoURL];
    __block UIImage *videoImage;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:url] options:nil];
        NSParameterAssert(asset);
        AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetImageGenerator.appliesPreferredTrackTransform = YES;
        assetImageGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
        CGImageRef thumbnailImageRef = NULL;
        NSError *thumbnailImageGenerationError = nil;
        thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(0, 60)actualTime:NULL error:&thumbnailImageGenerationError];
        if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
        videoImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage:thumbnailImageRef]: nil;

        dispatch_async(dispatch_get_main_queue(), ^{
            //主线程更新UI
            if(videoImage){
                self.image = videoImage;
                //缓存图片
                [[YYImageCache sharedCache] setImage:videoImage forKey:videoURL];
                CGImageRelease(thumbnailImageRef);
            }
        });

    });

}

@end

//
//  SVPickerViewController.m
//  Immers
//
//  Created by developer on 2022/5/25.
//

#import "SVPickerViewController.h"
#import "SVGlobalMacro.h"
#import <AVFoundation/AVFoundation.h>

@interface SVPickerViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource>

@property (nonatomic, copy) void(^completion)(UIImage *image);
@property (nonatomic, copy) void(^transferCompletion)(NSInteger type,NSString *url);//0 图片/1视频
@property (nonatomic, strong) UIImageView *cropBackgroundImageView;//裁剪边框
@end

@implementation SVPickerViewController {
    BOOL _selected;
}

+ (instancetype)pickerViewController:(void(^)(UIImage *image))completion {
    return [self pickerViewControllerWithSourceType:UIImagePickerControllerSourceTypeCamera completion:completion];
}

+ (instancetype)pickerViewControllerWithTransferCompletion:(void(^)(NSInteger type,NSString *url))completion {
    SVPickerViewController *viewController = [[SVPickerViewController alloc] init];
    viewController.transferCompletion = completion;
    viewController.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
    viewController.delegate = viewController;
    viewController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    viewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    return viewController;
}

+ (instancetype)pickerViewControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType completion:(void(^)(UIImage *image))completion {
    SVPickerViewController *viewController = [[SVPickerViewController alloc] init];
    viewController.completion = completion;
    viewController.delegate = viewController;
    viewController.sourceType = sourceType;
    viewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    return viewController;
}

- (void)transitionVideo:(NSURL *)movUrl {
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    /**
     AVAssetExportPresetMediumQuality 表示视频的转换质量，
     */
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
        // 转换完成保存的文件路径
        NSString *resultPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:resultPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:resultPath error:NULL];
        }
        resultPath = [NSString stringWithFormat:@"%@/%@.mp4", resultPath, [NSUUID UUID].UUIDString];
        DebugLog(@"out path ->%@", resultPath);
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        // 要转换的格式，这里使用 MP4
        exportSession.outputFileType = AVFileTypeMPEG4;
        // 转换的数据是否对网络使用优化
        exportSession.shouldOptimizeForNetworkUse = YES;
        // 异步处理开始转换
        [SVProgressHUD showWithStatus:SVLocalized(@"tip_loading")];
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
            [SVProgressHUD dismiss];
             // 转换状态监控
             switch (exportSession.status) {
                 case AVAssetExportSessionStatusUnknown:
                     [SVProgressHUD showWithStatus:SVLocalized(@"tip_uploading_failed")];
                     DebugLog(@"AVAssetExportSessionStatusUnknown");
                     break;
 
                 case AVAssetExportSessionStatusWaiting:
                     [SVProgressHUD showWithStatus:SVLocalized(@"tip_uploading_failed")];
                     DebugLog(@"AVAssetExportSessionStatusWaiting");
                     break;
 
                 case AVAssetExportSessionStatusExporting:
                     [SVProgressHUD showWithStatus:SVLocalized(@"tip_uploading_failed")];
                     DebugLog(@"AVAssetExportSessionStatusExporting");
                     break;
                     
                 case AVAssetExportSessionStatusFailed:
                     [SVProgressHUD showWithStatus:SVLocalized(@"tip_uploading_failed")];
                     DebugLog(@"AVAssetExportSessionStatusFailed");
                     break;
                     
                 case AVAssetExportSessionStatusCancelled:
                     [SVProgressHUD showWithStatus:SVLocalized(@"tip_uploading_failed")];
                     DebugLog(@"AVAssetExportSessionStatusCancelled");
                     break;
 
                 case AVAssetExportSessionStatusCompleted: {
                     // 转换完成
                     DebugLog(@"AVAssetExportSessionStatusCompleted");
                     dispatch_async(dispatch_get_main_queue(), ^{
                         self.transferCompletion(1,resultPath);
                     });
                     break;
                 }
             }
         }];
    }
}

- (BOOL)videoRule:(NSURL *)videoURL {
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
        // 獲取影片的時長（秒）
        CMTime duration = asset.duration;
        NSTimeInterval durationInSeconds = CMTimeGetSeconds(duration);
        
        // 獲取影片的輸出資源軌道
        AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        if (videoTrack) {
            CGSize naturalSize = videoTrack.naturalSize;
            CGFloat aspectRatio = naturalSize.width / naturalSize.height;
            NSLog(@"影片比例：%f", aspectRatio);
            NSLog(@"影片時長：%f 秒", durationInSeconds);
            if (durationInSeconds <= 5 && aspectRatio == 0.75) {
                NSLog(@"影片時長小於 5 秒且比例為 4:3");
                return YES;
            }else {
                NSLog(@"影片時長大於等於 5 秒或比例不是 4:3");
                return NO;
            }
        } else {
            NSLog(@"未找到影片軌道");
            return NO;
        }
}

// MARK: - UINavigationControllerDelegate,UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (_selected) { return; }
    _selected = YES;
    
    if (self.transferCompletion) {
        [self imagePickerControllerDidCancel:picker];
        
        if ([info[UIImagePickerControllerMediaType] isEqualToString:@"public.movie"]) {
            
            NSURL *mediaURL = info[UIImagePickerControllerMediaURL];
//            NSString *oldUrl = [mediaURL.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""];
//            if (@available(iOS 13.0, *)) {
//                //iOS13 拿到的视频URL在一个临时文件夹，要先把它存到另一个地方
//                NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory()];
//                temporaryDirectoryURL = [temporaryDirectoryURL URLByAppendingPathComponent:mediaURL.lastPathComponent];
//                NSString *newUrl = [temporaryDirectoryURL.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""];
//                NSError *error;
//                [[NSFileManager defaultManager] copyItemAtPath:oldUrl toPath:newUrl error:&error];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.transferCompletion(1,newUrl);
//                });
//
//            }else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.transferCompletion(1,oldUrl);
//                });
//
//            }
            if ([self videoRule:mediaURL]){
                //转成mp4格式
                [self transitionVideo:mediaURL];
            }else {
                //上傳影片條件錯誤
                [SVProgressHUD showInfoWithStatus:@"上傳影片格式錯誤"];
                return;
            }
            
        } else {
            NSString *url = [info[UIImagePickerControllerImageURL] absoluteString];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.transferCompletion(0,url);
            });
            
        }
        return;
    }
    
    NSString *key = picker.allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage;
    UIImage *pickedImage = info[key];
    
    // 保存拍照的原始图片
    if (self.sourceType == UIImagePickerControllerSourceTypeCamera && !picker.allowsEditing) {
        [self saveImage2Album:pickedImage];
    }
    
    if (!picker.allowsEditing) { // 原图
        // V1.1.0
        RSKImageCropViewController *viewController = [[RSKImageCropViewController alloc] initWithImage:pickedImage cropMode:RSKImageCropModeCustom];
        viewController.delegate = self;
        viewController.dataSource = self;
        viewController.moveAndScaleLabel.text = SVLocalized(@"home_move_and_scale");
        [viewController.cancelButton setTitle:SVLocalized(@"home_image_cancel") forState:UIControlStateNormal];
        [viewController.chooseButton setTitle:SVLocalized(@"home_image_choose") forState:UIControlStateNormal];
        [viewController.view addSubview:self.cropBackgroundImageView];
        [picker pushViewController:viewController animated:YES];
        //产品需求:需要先显示全图再动画过渡到相框最佳比例(图片裁剪不留黑边)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                viewController.avoidEmptySpaceAroundImage = YES;
            }];
        });

//         V1.0.0
        //[UIImage resetUpImageSize:pickedImage];

    } else {
        if (pickedImage && self.completion) {
            self.completion(pickedImage);
        }
        [self imagePickerControllerDidCancel:picker];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    _selected = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    });

}

- (void)saveImage2Album:(UIImage *)image {
    [UIImage resetUpImageSize:image];
    image = [image fixOrientation:image];
    NSData *imageData = UIImagePNGRepresentation(image);
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:kSaveImageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// MARK: - RSKImageCropViewControllerDelegate
// Crop image has been canceled.
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    _selected = NO;
    if (self.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self popViewControllerAnimated:NO];
        [self imagePickerControllerDidCancel:self];
    } else {
        [self popViewControllerAnimated:YES];
    }
}

// The original image has been cropped. Additionally provides a rotation angle used to produce image.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle {
    [SVProgressHUD dismiss];
    [self popViewControllerAnimated:YES];
    
    if (self.completion) {
        self.completion(croppedImage);
    }
    [self imagePickerControllerDidCancel:self];
}

// The original image will be cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                  willCropImage:(UIImage *)originalImage {
    _selected = NO;
    [SVProgressHUD show];
}

// MARK: - RSKImageCropViewControllerDataSource
// Returns a custom rect for the mask.
- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller {
    //相框比例
    CGSize aspectRatio = CGSizeMake(0.75f, 1.0f);
    
    CGFloat viewWidth = CGRectGetWidth(controller.view.frame);
    CGFloat viewHeight = CGRectGetHeight(controller.view.frame);
    
    CGFloat maskWidth;
    if ([controller isPortraitInterfaceOrientation]) {
        maskWidth = viewWidth;
    } else {
        maskWidth = viewHeight;
    }
    
    CGFloat maskHeight;
    do {
        maskHeight = maskWidth * aspectRatio.height / aspectRatio.width;
        maskWidth -= 1.0f;
    } while (maskHeight != floor(maskHeight));
    maskWidth += 1.0f;
    
    CGSize maskSize = CGSizeMake(maskWidth, maskHeight);
    
    CGRect maskRect = CGRectMake((viewWidth - maskSize.width) * 0.5f,
                                 (viewHeight - maskSize.height) * 0.5f,
                                 maskSize.width,
                                 maskSize.height);
    self.cropBackgroundImageView.frame = maskRect;

    return maskRect;
}

// Returns a custom path for the mask.
- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller {
    CGRect rect = controller.maskRect;
    CGPoint point1 = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPoint point2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPoint point3 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPoint point4 = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    
    UIBezierPath *rectangle = [UIBezierPath bezierPath];
    [rectangle moveToPoint:point1];
    [rectangle addLineToPoint:point2];
    [rectangle addLineToPoint:point3];
    [rectangle addLineToPoint:point4];
    [rectangle closePath];
    
    return rectangle;
}

// Returns a custom rect in which the image can be moved.
- (CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller {
    if (controller.rotationAngle == 0) {
        return controller.maskRect;
    } else {
        CGRect maskRect = controller.maskRect;
        CGFloat rotationAngle = controller.rotationAngle;
        
        CGRect movementRect = CGRectZero;
        
        movementRect.size.width = CGRectGetWidth(maskRect) * fabs(cos(rotationAngle)) + CGRectGetHeight(maskRect) * fabs(sin(rotationAngle));
        movementRect.size.height = CGRectGetHeight(maskRect) * fabs(cos(rotationAngle)) + CGRectGetWidth(maskRect) * fabs(sin(rotationAngle));
        
        movementRect.origin.x = CGRectGetMinX(maskRect) + (CGRectGetWidth(maskRect) - CGRectGetWidth(movementRect)) * 0.5f;
        movementRect.origin.y = CGRectGetMinY(maskRect) + (CGRectGetHeight(maskRect) - CGRectGetHeight(movementRect)) * 0.5f;
        
        movementRect.origin.x = floor(CGRectGetMinX(movementRect));
        movementRect.origin.y = floor(CGRectGetMinY(movementRect));
        movementRect = CGRectIntegral(movementRect);
        return movementRect;
    }
}

// MARK: - Lazy
- (UIImageView *)cropBackgroundImageView {
    if(!_cropBackgroundImageView){
        _cropBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_tailor_frame"]];
    }
    return _cropBackgroundImageView;
}

@end

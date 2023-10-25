//
//  SVAuthorization.m
//  Immers
//
//  Created by developer on 2022/5/25.
//

#import "SVAuthorization.h"
#import <Photos/Photos.h>

@implementation SVAuthorization

+ (void)albumAuthorization:(void(^)(void))authorized denied:(void(^)(void))denied {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    switch (status) {
        case PHAuthorizationStatusAuthorized: // 已授权
            authorized();
            break;
        case PHAuthorizationStatusDenied: // 拒绝
            denied();
            break;
        case PHAuthorizationStatusNotDetermined: { // 首次
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    status == AVAuthorizationStatusAuthorized ?  authorized() : denied();
                });
            }];
        }
            break;
            
        default: // other
            denied();
            break;
    }
}

+ (void)cameraAuthorization:(void(^)(void))authorized denied:(void(^)(void))denied {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusAuthorized: // 已授权
            authorized();
            break;
        case AVAuthorizationStatusDenied: // 拒绝
            denied();
            break;
        case AVAuthorizationStatusNotDetermined: { // 首次
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    granted ? authorized() : denied();
                });
            }];
        }
            break;
        default:  // other
            denied();
            break;
    }
}

@end

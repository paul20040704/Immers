//
//  SVDeviceData.h
//  Immers
//
//  Created by developer on 2023/3/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVBinderUser : NSObject

@property (nonatomic, copy) NSString *userEmail;
@property (nonatomic, copy) NSString *userImage;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userPhone;

@end

@interface SVDeviceData : NSObject

/// holo硬件类型
@property (nonatomic, copy) NSString *holoVersion;
/// 设备id
@property (nonatomic, copy) NSString *deviceId;
/// 设备名称
@property (nonatomic, copy) NSString *name;
/// 图片链接
@property (nonatomic, copy) NSString *imageUrl;
/// 是否被绑定
@property (nonatomic, assign) BOOL isBinding;
/// 是否分享设备
@property (nonatomic, assign) BOOL isShare;

@property (nonatomic, strong) SVBinderUser *user;

@end

NS_ASSUME_NONNULL_END

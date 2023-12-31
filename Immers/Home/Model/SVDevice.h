//
//  SVDevice.h
//  Immers
//
//  Created by developer on 2022/6/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVDevice : NSObject

/// 设备id
@property (nonatomic, copy) NSString *deviceId;
/// 设备名称
@property (nonatomic, copy) NSString *name;
/// 封面路径
@property (nonatomic, copy) NSString *imageUrl;
/// 在线状态
@property (nonatomic, assign) BOOL onlineStatus;
/// 剩余容量
@property (nonatomic, assign) NSInteger surplusCapacity;
/// 总容量
@property (nonatomic, assign) NSInteger totalCapacity;
/// 板子型号
@property (nonatomic,copy) NSString *holoVersion;
/// 设备版本号
@property (nonatomic, copy) NSString *versionNum;
/// 是否选中
@property (nonatomic, assign) BOOL selected;
/// 是否是分享设备
@property (nonatomic, assign) BOOL isShare; 

@end

NS_ASSUME_NONNULL_END

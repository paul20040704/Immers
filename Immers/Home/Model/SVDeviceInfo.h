//
//  SVDeviceInfo.h
//  Immers
//
//  Created by developer on 2022/11/22.
//

#import <Foundation/Foundation.h>
#import "SVWiFi.h"
#import "SVFTPInfo.h"
#import "SVVolume.h"
#import "SVUploadFilePath.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVDeviceInfo : NSObject
/// 设备id
@property (nonatomic, copy) NSString *deviceId;
/// 设备类型
@property (nonatomic, copy) NSString *deviceType;
/// 版本号
@property (nonatomic, copy) NSString *versionNum;
/// 播放方式: 1:正常  2:时钟模式
@property (nonatomic, copy) NSString *playType;
/// 剩余容量
@property (nonatomic, assign) NSInteger surplusCapacity;
/// 总容量
@property (nonatomic, assign) NSInteger totalCapacity;
/// 图片播放时长
@property (nonatomic, assign) NSInteger imageStayTime;
/// 下载任务数量
@property (nonatomic, assign) NSInteger taskNum;
/// 当前电量0-100
@property (nonatomic, assign) NSInteger battery;
/// 播放状态 0:空闲状态 1:顺序播放 2:随机播放 3:单个播放 4:暂停播放 5:资源播放(宠物播放)
@property (nonatomic, assign) NSInteger playStatus;
/// 语言 CN:简体中文 CT:繁体中文 EN:英文 JA:日文 KO:韩文
@property (nonatomic, copy) NSString *currentLanguage;
/// 播放模式 1: 顺序播放 2: 随机播放 3:单个播放
@property (nonatomic, copy) NSString *playModel;
/// wifi信息
@property (nonatomic, strong) SVWiFi *currentWifiInfo;
/// ftp信息
@property (nonatomic, strong) SVFTPInfo *ftpServiceInfo;
/// 电量信息
@property (nonatomic, strong) SVVolume *volumeInfo;
/// 上传文件地址
@property (nonatomic, strong) SVUploadFilePath *updateFilePath;

@end

NS_ASSUME_NONNULL_END

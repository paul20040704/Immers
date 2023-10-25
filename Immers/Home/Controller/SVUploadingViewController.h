//
//  SVUploadingViewController.h
//  Immers
//
//  Created by developer on 2022/9/13.
//

#import <UIKit/UIKit.h>
#import "SVFTPInfo.h"
#import "SVUploadFilePath.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVUploadingViewController : UIAlertController
/// 当前进度
@property (nonatomic, assign) float progress;

/// 是否是转换 默认 NO
@property (nonatomic, assign) BOOL converting;

/// FTP 信息
@property (nonatomic, strong) SVFTPInfo *info;

/// http上传文件信息
@property (nonatomic, strong) SVUploadFilePath *httpInfo;
/// FTP传输的文件路径
@property (nonatomic, copy) NSString *filePath;
/// 文件类型

@property (nonatomic, assign) NSInteger fileType;
/// 创建进度视图
+ (instancetype)uploadingViewController;


@end

NS_ASSUME_NONNULL_END

//
//  SVAsset.h
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVAsset : NSObject

/// 是否显示 【删除】图标
@property (nonatomic, assign) BOOL show;

/// 图标
@property (nonatomic, copy) NSString *icon;

/// 名称
@property (nonatomic, copy) NSString *name;

/// 图集id
@property (nonatomic, copy) NSString *aid;

/// 是否选中
@property (nonatomic, assign) BOOL selected;

@end

// MARK: - 文件
@interface SVFile : NSObject

/// 文件大小
@property (nonatomic, copy) NSString *fileSize;

/// 文件名称
@property (nonatomic, copy) NSString *name;

/// 文件id
@property (nonatomic, copy) NSString *fid;

/// 文件路径
@property (nonatomic, copy) NSString *twoDimensionUrl;

/// 是否显示 选中 icon
@property (nonatomic, assign) BOOL show;

/// 是否选中
@property (nonatomic, assign) BOOL selected;

/// 上传进度
@property (nonatomic, assign) double progress;

@end

// MARK: - 相框文件
@interface SVPhoto : NSObject

/// 预览图
@property (nonatomic, copy) NSString *cover;

/// 文件名称
@property (nonatomic, copy) NSString *name;

/// 路径
@property (nonatomic, copy) NSString *path;

/// 文件id
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *imageId;
@property (nonatomic, copy) NSString *localId;

/// 是否显示 选中 icon
@property (nonatomic, assign) BOOL show;

/// 是否选中
@property (nonatomic, assign) BOOL selected;

/// 上传进度
@property (nonatomic, assign) double progress;

/// 文件类型 1 == 图片  2 == 视频
@property (nonatomic, assign) NSInteger type;

/// 视频时长
@property (nonatomic, assign) NSTimeInterval duration;

/// 格式完成
@property (nonatomic, copy, readonly) NSString *videoDuration;

/// 上传图片数据
@property (nonatomic, strong) UIImage *image;

@end

// MARK: - 文件管理
@interface SVLocalFile : NSObject

/// 文件id
@property (nonatomic, copy) NSString *fileId;

/// 文件名称
@property (nonatomic, copy) NSString *name;

/// 专辑
@property (nonatomic, copy) NSString *album;

/// 作者
@property (nonatomic, copy) NSString *artist;

/// 显示名称
@property (nonatomic, copy) NSString *displayName;

/// 格式类型
@property (nonatomic, copy) NSString *mimeType;

/// 类型
@property (nonatomic, assign) NSInteger type;//1:图片 2:视频

/// 本地路径
@property (nonatomic, copy) NSString *path;

/// 时长
@property (nonatomic, assign) NSInteger duration;

/// 文件大小
@property (nonatomic, assign) NSInteger size;

/// 视频反转
@property (nonatomic, assign) NSInteger reversal;// 0:left 1:right

/// 视频格式
@property (nonatomic, copy) NSString *format;

/// 3D强度
@property (nonatomic, assign) NSInteger strength3D;

/// 3D焦点
@property (nonatomic, assign) NSInteger focus;

/// 排序
@property (nonatomic, assign) NSInteger sort;

/// 是否已经添加到播放列表
@property (nonatomic, assign) NSInteger isAdd;

/// 图片封面
@property (nonatomic, copy) NSString *cover;

/// 获取图片封面
@property (nonatomic, assign) NSInteger getCoverState; //0:未获取、1:获取中、2:获取失败、3:获取成功

/// 是否显示 选中 icon
@property (nonatomic, assign) BOOL show;

/// 是否选中
@property (nonatomic, assign) BOOL selected;

/// 上传进度
@property (nonatomic, assign) double progress;

///是否为一行最后一个
@property (nonatomic, assign) BOOL lastRow;

///是否为最后一行
@property (nonatomic, assign) BOOL lastLine;

@end

@interface SVLocalFileRequest : NSObject

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger size;

/// 0:全部(包含SD卡内容) 1:本机内容 2:SD内容
@property (nonatomic, assign) NSInteger storageType;

/// 0:全部 1:图片 2:视频
@property (nonatomic, assign) NSInteger fileType;

@property (nonatomic, strong) NSMutableArray <SVLocalFile *> *localFiles;

@property (nonatomic, assign) BOOL noMoreData;
@end

NS_ASSUME_NONNULL_END

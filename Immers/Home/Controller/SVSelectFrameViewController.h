//
//  SVSelectFrameViewController.h
//  Immers
//
//  Created by developer on 2022/9/13.
//

#import "SVBaseViewController.h"
#import "SVResourceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVSelectFrameViewController : SVBaseViewController

@property (nonatomic, assign) SVButtonEvent eventType;
@property (nonatomic, strong) UIImage *image;//要上传的图片
@property (nonatomic, strong) NSMutableArray<SVResourceModel *> *selectResources;//选择要下载的资源
@property (nonatomic, copy) NSString *fileType; //上傳類型 1:图片 2:视频
@property (nonatomic, copy) NSString *videoUrl; //要上傳的影片連結


@end

NS_ASSUME_NONNULL_END

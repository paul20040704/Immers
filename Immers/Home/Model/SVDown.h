//
//  SVDown.h
//  Immers
//
//  Created by developer on 2022/10/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVDown : NSObject

@property (nonatomic, copy) NSString *did;
@property (nonatomic, copy) NSString *imageId;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *twoImageUrl;
@property (nonatomic, assign) NSInteger download;//下载状态(0下载中；1下载完成(收不到)；2转制中)
@property (nonatomic, copy) NSString *serviceId;
@property (nonatomic, assign) double percent;

/// 0: 失败  1: 完成  2: 停止  3: 等待  4:下载中  5:预处理 6:预处理完成 7:删除任务
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy, readonly) NSString *stateText;
@property (nonatomic, copy, readonly) NSString *progressText;

@end

NS_ASSUME_NONNULL_END

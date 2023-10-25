//
//  SVResoruceGroupTask.h
//  Immers
//
//  Created by developer on 2022/11/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVResoruceGroupTask : NSObject
/// 任务ID
@property (nonatomic, copy) NSString *taskId;
/// 资源组ID
@property (nonatomic, copy) NSString *resGroupId;
/// 任务名称
@property (nonatomic, copy) NSString *name;
/// 进度百分比
@property (nonatomic, assign) NSInteger percent;
/// 下载状态(-1:其它状态 ,0:失败状态 , 1:完成状态,2:停止状态 ,3:等待状态 ,4:下载中, 5:预处理 ,6:预处理完成,7:删除任务)
@property (nonatomic, copy) NSString *state;
/// 其他参数暂不需要
///文件总大小/单位字节
//@property (nonatomic, assign) NSInteger fileSize;
/// 已下载/单位字节
//@property (nonatomic, assign) NSInteger currentProgress;
/// 资源数量
//@property (nonatomic, assign) NSInteger num;
/// 速度/单位字节
//@property (nonatomic, copy) NSInteger speed;
@end

NS_ASSUME_NONNULL_END

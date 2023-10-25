//
//  SVTimer.h
//  Immers
//
//  Created by developer on 2022/6/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVTimer : NSObject

/// 定时器
/// @param interval 间隔时长
/// @param repeats 是否重复
/// @param queue 线程
/// @param block 回调任务
+ (SVTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                     repeats:(BOOL)repeats
                                       queue:(dispatch_queue_t)queue
                                       block:(void (^)(void))block;

/// 同步定时器
/// @param interval 间隔时长
/// @param repeats 是否重复
/// @param block 回调任务
+ (SVTimer *)syncTimerWithTimeInterval:(NSTimeInterval)interval
                                     repeats:(BOOL)repeats
                                       block:(void (^)(void))block;
/// 异步定时器
/// @param interval 间隔时长
/// @param repeats 是否重复
/// @param block 回调任务
+ (SVTimer *)asyncTimerWithTimeInterval:(NSTimeInterval)interval
                                     repeats:(BOOL)repeats
                                       block:(void (^)(void))block;

- (void)invalidate;

@end

NS_ASSUME_NONNULL_END

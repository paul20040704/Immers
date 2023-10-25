//
//  SVTimer.m
//  Immers
//
//  Created by developer on 2022/6/20.
//

#import "SVTimer.h"

@interface SVTimer ()

@property (strong, nonatomic) dispatch_source_t timer;

@end

@implementation SVTimer

+ (SVTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                     repeats:(BOOL)repeats
                                       queue:(dispatch_queue_t)queue
                                       block:(void (^)(void))block {
    SVTimer *timer = [[SVTimer alloc] initWithInterval:interval
                                                 repeats:repeats
                                                   queue:queue
                                                   block:block];
    return timer;
}

/// 同步定时器
+ (SVTimer *)syncTimerWithTimeInterval:(NSTimeInterval)interval
                                     repeats:(BOOL)repeats
                                 block:(void (^)(void))block {
    dispatch_queue_t queue = dispatch_get_main_queue();
    return [self scheduledTimerWithTimeInterval:interval repeats:repeats queue:queue block:block];
}
/// 异步定时器
+ (SVTimer *)asyncTimerWithTimeInterval:(NSTimeInterval)interval
                                     repeats:(BOOL)repeats
                                  block:(void (^)(void))block {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    return [self scheduledTimerWithTimeInterval:interval repeats:repeats queue:queue block:block];
}

- (instancetype)initWithInterval:(NSTimeInterval)interval
                         repeats:(BOOL)repeats
                           queue:(dispatch_queue_t)queue
                           block:(void (^)(void))block {
    self = [super init];
    if (self) {
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(self.timer, ^{
            if (!repeats) {
                dispatch_source_cancel(self.timer);
            }
            block();
        });
        dispatch_resume(self.timer);
    }
    return self;
}

- (void)dealloc {
    [self invalidate];
}

- (void)invalidate {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}

@end

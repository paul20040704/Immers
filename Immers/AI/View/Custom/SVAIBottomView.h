//
//  SVAIBottomView.h
//  Immers
//
//  Created by Paul on 2023/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVAIBottomView : UIView
@property (nonatomic, copy) void(^downAction)(void);
@property (nonatomic, assign) NSInteger selectCounnt;
@end

NS_ASSUME_NONNULL_END

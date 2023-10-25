//
//  SVDeviceEventView.h
//  Immers
//
//  Created by ssv on 2022/11/10.
//

#import <UIKit/UIKit.h>
#import "SVEventButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVDeviceEventView : UIView
@property (nonatomic,copy)void(^clickAction)(NSInteger index);
@property (nonatomic,assign)NSInteger taskCount;
@end

NS_ASSUME_NONNULL_END

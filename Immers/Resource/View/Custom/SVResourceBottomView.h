//
//  SVResourceBottomView.h
//  Immers
//
//  Created by ssv on 2022/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVResourceBottomView : UIView
@property (nonatomic, copy) void(^downAction)(void);
@property (nonatomic, assign) NSInteger selectCounnt;
@end

NS_ASSUME_NONNULL_END

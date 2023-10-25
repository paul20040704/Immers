//
//  SVProfileHeaderView.h
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVProfileHeaderView : UIView

/// 选中回调
@property (nonatomic, copy) void(^didSelectedCallback)(void);

@end

NS_ASSUME_NONNULL_END

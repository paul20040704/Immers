//
//  SVTabBar.h
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVTabBar : UITabBar

/// 是否显示 上传按钮
@property (nonatomic, assign, getter=isShow) BOOL show;

/// 上传事件
@property (nonatomic, copy) void(^uploadCallback)(void);

@end

NS_ASSUME_NONNULL_END

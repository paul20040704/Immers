//
//  SVWiFiHeaderView.h
//  Immers
//
//  Created by developer on 2022/5/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVWiFiHeaderView : UIView

/// 回调
@property (nonatomic, copy) void(^valueChangedCallback)(BOOL open);

@end

NS_ASSUME_NONNULL_END

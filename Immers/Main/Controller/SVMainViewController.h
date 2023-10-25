//
//  SVMainViewController.h
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import <UIKit/UIKit.h>
#import "SVGlobalMacro.h"
#import "SVApns.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVMainViewController : UITabBarController

- (void)reloadMainViewController;
- (void)toAddDeviceAndBackHome;

- (void)handleNotification:(SVApnsEvent)event info:(SVApns *)info;

@end

NS_ASSUME_NONNULL_END

//
//  SVControlViewController.h
//  Immers
//
//  Created by developer on 2022/5/18.
//

#import "SVBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVControlViewController : SVBaseViewController
@property (nonatomic,copy)NSString *deviceId;
@property (nonatomic,strong)SVDeviceInfo *deviceInfo;
@end

NS_ASSUME_NONNULL_END

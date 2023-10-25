//
//  SVWiFiViewCell.h
//  Immers
//
//  Created by developer on 2022/5/19.
//

#import "SVTableViewCell.h"
#import "SVWiFi.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVWiFiViewCell : SVTableViewCell

@property (nonatomic, strong) SVWiFi *ssid;

@end

NS_ASSUME_NONNULL_END

//
//  SVSettingViewCell.h
//  Immers
//
//  Created by developer on 2022/5/18.
//

#import "SVTableViewCell.h"
#import "SVSettings.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVSettingsViewCell : SVTableViewCell

@property (nonatomic, strong) SVSettings *settings;

@end

NS_ASSUME_NONNULL_END

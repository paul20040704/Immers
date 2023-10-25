//
//  SVTaskViewCell.h
//  Immers
//
//  Created by developer on 2022/10/14.
//

#import "SVTableViewCell.h"
#import "SVDown.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVTaskViewCell : SVTableViewCell

/// 单个下载任务
@property (nonatomic, strong) SVDown *down;

@end

NS_ASSUME_NONNULL_END

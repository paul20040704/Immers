//
//  SVPlayViewCell.h
//  Immers
//
//  Created by developer on 2022/5/21.
//

#import "SVTableViewCell.h"
#import "SVPlayItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVPlayViewCell : SVTableViewCell

/// 设置项
@property (nonatomic, strong) SVPlayItem *item;

@end

NS_ASSUME_NONNULL_END

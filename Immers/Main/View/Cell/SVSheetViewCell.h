//
//  SVSheetViewCell.h
//  Immers
//
//  Created by developer on 2022/5/21.
//

#import "SVTableViewCell.h"
#import "SVSheetViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVSheetViewCell : SVTableViewCell

/// 选项
@property (nonatomic, strong) SVSheetItem *item;

@end

NS_ASSUME_NONNULL_END

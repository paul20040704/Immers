//
//  SVMemberApplyCell.h
//  Immers
//
//  Created by developer on 2023/2/22.
//

#import "SVTableViewCell.h"
#import "SVApply.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVMemberApplyCell : SVTableViewCell

@property (nonatomic, assign) BOOL showArrow;

/// 申请者信息
@property (nonatomic, strong) SVApply *apply;

@end

NS_ASSUME_NONNULL_END

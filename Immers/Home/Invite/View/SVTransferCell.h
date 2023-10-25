//
//  SVTransferCell.h
//  Immers
//
//  Created by developer on 2023/3/13.
//

#import "SVTableViewCell.h"
#import "SVMember.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVTransferCell : SVTableViewCell

/// 成员信息
@property (nonatomic, strong) SVMember *member;

/// 转让
@property (nonatomic, copy) void(^transferAction)(SVMember *member);

@end

NS_ASSUME_NONNULL_END

//
//  SVMemberListCell.h
//  Immers
//
//  Created by developer on 2023/2/21.
//

#import "SVTableViewCell.h"
#import "SVMember.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVMemberListCell : SVTableViewCell

/// 成员信息
@property (nonatomic, strong) SVMember *member;

@end

NS_ASSUME_NONNULL_END

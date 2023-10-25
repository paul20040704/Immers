//
//  SVProfileViewCell.h
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import "SVTableViewCell.h"
#import "SVProfileItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVProfileViewCell : SVTableViewCell

@property (nonatomic, strong) SVProfileItem *item;

@property (nonatomic, strong, readonly) UILabel *titleLabel;

- (void)prepareSubviews;

@end

@interface SVUpdateViewCell : SVProfileViewCell

@end

@interface SVSubtextViewCell : SVProfileViewCell

@end


NS_ASSUME_NONNULL_END

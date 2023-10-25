//
//  SVAccountViewCell.h
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import "SVTableViewCell.h"
#import "SVAccountItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVAccountViewCell : SVTableViewCell

@property (nonatomic, strong) SVAccountItem *item;

- (void)prepareSubviews;

@end

@interface SVTextViewCell : SVAccountViewCell

@end

@interface SVIconViewCell : SVAccountViewCell

@end

@interface SVLanguageViewCell : SVAccountViewCell

@end

NS_ASSUME_NONNULL_END

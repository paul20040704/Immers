//
//  SVPetActionCell.m
//  Immers
//
//  Created by developer on 2022/11/18.
//

#import "SVPetActionCell.h"

@implementation SVPetActionCell{
    UIImageView *_actionImageView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareSubviews];
    }
    return self;
}

- (void)prepareSubviews {
    _actionImageView = [[UIImageView alloc] init];
    [_actionImageView corner:kHeight(20)];
    [self.contentView addSubview:_actionImageView];
    [_actionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setAction:(SVPetActionModel *)action {
    _action = action;
    [_actionImageView setImageWithURL:action.petShowImage placeholder:[UIImage imageNamed:@"pet_action_backGround"]];
}
@end

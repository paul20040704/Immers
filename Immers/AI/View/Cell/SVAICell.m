//
//  SVAICell.m
//  Immers
//
//  Created by Paul on 2023/7/25.
//

#import "SVAICell.h"
#import "UIView+Extension.h"

@implementation SVAICell
{
    UIImageView *_coverView;
    UIButton *_stateButton;
}

// MARK: - setter

-(void)setResource:(SVAIModel *)resource {
    _resource = resource;
    _stateButton.hidden = !resource.show;
    _stateButton.selected = resource.selected;
    
    [_coverView setImage:resource.image];

}

// MARK: - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareSubviews];
    }
    return self;
}

/// 子视图
- (void)prepareSubviews {
    _coverView = [UIImageView imageView];
    _coverView.userInteractionEnabled = YES;
    _coverView.backgroundColor = [UIColor backgroundColor];
    [_coverView corner];
    
    _stateButton = [UIButton buttonWithNormalName:@"home_album_normal" selectedName:@"home_album_selected"];
    _stateButton.userInteractionEnabled = NO;
    [_stateButton sizeToFit];
    
    [self.contentView addSubview:_coverView];
    [self.contentView addSubview:_stateButton];
    
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [_stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kHeight(10));
        make.right.equalTo(self.contentView).offset(kHeight(-10));
    }];
}

@end

//
//  SVResourceCell.m
//  Immers
//
//  Created by ssv on 2022/11/11.
//

#import "SVResourceCell.h"
#import "UIView+Extension.h"
@implementation SVResourceCell
{
    UIImageView *_coverView;
    UIButton *_stateButton;
    UILabel *_sizeLabel;
}

// MARK: - Action
- (void)longPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        if (self.longPressBlock) {
            self.longPressBlock();
        }
    }

}

// MARK: - setter

-(void)setResource:(SVResourceModel *)resource {
    _resource = resource;
    _stateButton.hidden = !resource.show;
    _stateButton.selected = resource.selected;
    _sizeLabel.text = [NSString stringWithFormat:@"%.1fM",resource.uploadSize.doubleValue/1024/1024];
    if (resource.coverPicture) {
        [_coverView setImageWithURL:resource.coverPicture placeholder:[UIImage imageNamed:@"global_image_default"]];
    }else {
        if(resource.type.intValue==0){
            [_coverView setImageWithURL:resource.uploadUrl placeholder:[UIImage imageNamed:@"global_image_default"]];
        }else{
            [_coverView setVideoPreViewImageURL:resource.uploadUrl placeHolderImage:[UIImage imageNamed:@"global_image_default"]];
        }
    }

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
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [_coverView addGestureRecognizer:longPress];
    [_coverView corner];
    
    _stateButton = [UIButton buttonWithNormalName:@"home_album_normal" selectedName:@"home_album_selected"];
    _stateButton.userInteractionEnabled = NO;
    [_stateButton sizeToFit];
    
    _sizeLabel = [UILabel labelWithTextColor:[UIColor whiteColor] font:kSystemFont(12)];
    
    [self.contentView addSubview:_coverView];
    [self.contentView addSubview:_stateButton];
    [self.contentView addSubview:_sizeLabel];
    
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [_stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kHeight(10));
        make.right.equalTo(self.contentView).offset(kHeight(-10));
    }];
    
    [_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kWidth(8));
        make.bottom.equalTo(self.contentView).offset(kHeight(-4));
    }];
    
}

@end

//
//  SVResourceHeadView.m
//  Immers
//
//  Created by ssv on 2022/11/11.
//

#import "SVResourceHeadView.h"
#import "UIView+Extension.h"
#import "SVGlobalMacro.h"
@implementation SVResourceHeadView{
    UIButton *_picButton;
    UIButton *_videoButton;
    UIButton *_selectButton;
    UIImageView *_picLineView;
    UIImageView *_videoLineView;
}

- (instancetype )initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        [self prepareSubViews];
    }
    return self;
}

// MARK: - Action
- (void)resetSelectStatus {
    _selectButton.selected = NO;
}


- (void)buttonClick:(UIButton *)sender {
    NSInteger tag = sender.tag - 100;
    if(tag==0){
        _picLineView.hidden = NO;
        _videoLineView.hidden = YES;
        if (_selectButton.selected) {
            _selectButton.selected = NO;
        }
    }else if(tag==1){
        _picLineView.hidden = YES;
        _videoLineView.hidden = NO;
        if (_selectButton.selected) {
            _selectButton.selected = NO;
        }
    }else {
        _selectButton.selected = !_selectButton.selected;
        
    }
    if(self.clickAction){
        self.clickAction(tag);
    }
    
}


// MARK: - View
- (void)prepareSubViews {
    self.backgroundColor = UIColor.whiteColor;
    _picButton = [UIButton buttonWithTitle:SVLocalized(@"resource_picture") titleColor:UIColor.blackColor font:kSystemFont(16)];
    _picButton.tag = 100;
    [_picButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _videoButton = [UIButton buttonWithTitle:SVLocalized(@"resource_video") titleColor:UIColor.blackColor font:kSystemFont(16)];
    _videoButton.tag = 101;
    [_videoButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _selectButton = [UIButton buttonWithTitle:SVLocalized(@"resource_select") titleColor:UIColor.blackColor font:kSystemFont(14)];
    [_selectButton setTitle:SVLocalized(@"home_cancel") forState:UIControlStateSelected];
    _selectButton.tag = 102;
    [_selectButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _picLineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resource_select_cursor"]];
    _videoLineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resource_select_cursor"]];
    _videoLineView.hidden = YES;
    
    [self addSubview:_picButton];
    [self addSubview:_videoButton];
    [self addSubview:_selectButton];
    [self addSubview:_picLineView];
    [self addSubview:_videoLineView];
    
    [_picButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kWidth(140));
        make.bottom.equalTo(self.mas_bottom).offset(kHeight(-4));
    }];
    
    [_videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(kWidth(-140));
        make.bottom.equalTo(self.mas_bottom).offset(kHeight(-4));
    }];
    
    [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(kWidth(-24));
        make.centerY.equalTo(_videoButton.mas_centerY);
    }];
    
    [_picLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_picButton.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kWidth(26), kHeight(4)));
        make.centerX.equalTo(_picButton);
    }];
    
    [_videoLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_selectButton.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kWidth(26), kHeight(4)));
        make.centerX.equalTo(_videoButton);
    }];
}
@end

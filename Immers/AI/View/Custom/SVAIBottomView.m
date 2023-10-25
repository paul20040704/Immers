//
//  SVAIBottomView.m
//  Immers
//
//  Created by Paul on 2023/7/21.
//

#import "SVAIBottomView.h"
#import "SVGlobalMacro.h"

@implementation SVAIBottomView{
    UILabel *_countLabel;
    UIButton *_downButton;
}

- (instancetype )initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        [self prepareSubviews];
    }
    return self;
}

// MARK: - Action

- (void)downClickAction {
    if(self.downAction){
        self.downAction();
    }
}

// MARK: - view

- (void)prepareSubviews {
    self.backgroundColor = [UIColor colorWithHex:0x333333];
    if ([[UIDevice currentDevice] userInterfaceIdiom]  == UIUserInterfaceIdiomPhone) {
        self.layer.cornerRadius = kHeight(20);
    } else {
        self.layer.cornerRadius = kHeight(10);
    }
    
    _countLabel = [UILabel labelWithTextColor:UIColor.whiteColor font:kSystemFont(14)];
    _downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_downButton setBackgroundImage:[UIImage imageNamed:@"resource_down_enable"] forState:0];
    [_downButton setBackgroundImage:[UIImage imageNamed:@"resource_down_normal"] forState:UIControlStateDisabled];
    [_downButton addTarget:self action:@selector(downClickAction) forControlEvents:UIControlEventTouchUpInside];
    self.selectCounnt = 0;
    [self addSubview:_countLabel];
    [self addSubview:_downButton];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(kWidth(24));
    }];
    
    [_downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-kWidth(24));
        make.size.mas_equalTo(CGSizeMake(kWidth(26), kWidth(26)));
    }];
}

// MARK: - Setter
- (void)setSelectCounnt:(NSInteger)selectCounnt{
    _selectCounnt = selectCounnt;
    _downButton.enabled = _selectCounnt>0;
    _countLabel.text = [NSString stringWithFormat:SVLocalized(@"resource_select_count"),selectCounnt];
}




@end

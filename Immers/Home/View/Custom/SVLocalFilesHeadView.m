//
//  SVLocalFilesHeadView.m
//  Immers
//
//  Created by developer on 2022/11/15.
//

#import "SVLocalFilesHeadView.h"
#import "SVGlobalMacro.h"
@implementation SVLocalFilesHeadView{
    UIButton *_localButton;
    UIButton *_usbButton;
    UIButton *_selectButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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
        _selectButton.selected = !_selectButton.selected;
    }else {
        _localButton.selected = (tag==1);
        _usbButton.selected = !_localButton.selected;
        
    }
    if(self.clickAction){
        self.clickAction(tag);
    }
    
}


// MARK: - View
- (void)prepareSubViews {
    self.backgroundColor = [UIColor colorWithHex:0x333333];
    _localButton = [UIButton buttonWithTitle:SVLocalized(@"home_local_files") selectedTitle:SVLocalized(@"home_local_files") normalColor:[UIColor colorWithHex:0xffffff alpha:0.8] selectedColor:UIColor.grayColor8 font:kSystemFont(16)];
    [_localButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_localButton setBackgroundColor:[UIColor colorWithHex:0x494948] forState:0];
    _localButton.tag = 101;
    _localButton.selected = YES;
    [_localButton corner];
    [_localButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    _usbButton = [UIButton buttonWithTitle:SVLocalized(@"home_U_disk") selectedTitle:SVLocalized(@"home_U_disk") normalColor:[UIColor colorWithHex:0xffffff alpha:0.8] selectedColor:UIColor.grayColor8 font:kSystemFont(16)];
    [_usbButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_usbButton setBackgroundColor:[UIColor colorWithHex:0x494948] forState:0];
    _usbButton.tag = 102;
    [_usbButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_usbButton corner];
    
    _selectButton = [UIButton buttonWithTitle:SVLocalized(@"home_management") titleColor:UIColor.whiteColor font:kSystemFont(16)];
    [_selectButton setTitle:SVLocalized(@"home_cancel") forState:UIControlStateSelected];
    _selectButton.tag = 100;
    [_selectButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button = [UIButton buttonWithImageName:@"nav_back_white"];
    button.tag = 103;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    UIView *centerView = [UIView new];
    centerView.backgroundColor = [UIColor colorWithHex:0x494948];
    [centerView corner];
    
    [self addSubview:centerView];
    [centerView addSubview:_localButton];
    [centerView addSubview:_usbButton];
    [self addSubview:_selectButton];
    
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kWidth(28));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-kHeight(6));
    }];
    
    [_localButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(centerView);
    }];
    [_localButton.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kWidth(8));
        make.right.offset(kWidth(-8));
    }];
    [_usbButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(centerView);
        make.left.equalTo(_localButton.mas_right);
    }];
    [_usbButton.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kWidth(8));
        make.right.offset(kWidth(-8));
    }];
    [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(kWidth(-24));
        make.centerY.equalTo(_usbButton.mas_centerY);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_localButton);
        make.left.equalTo(self).offset(kWidth(22));
        make.size.mas_equalTo(CGSizeMake(kWidth(20), kWidth(20)));
    }];
    
    
    self.layer.shadowColor = [UIColor colorWithHex:0x000000 alpha:0.4].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, kWidth(4));
    self.layer.shadowOpacity = 1.0;
}

@end

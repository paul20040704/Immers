//
//  SVLocalFileBottomView.m
//  Immers
//
//  Created by developer on 2022/11/16.
//

#import "SVLocalFileBottomView.h"
#import "SVGlobalMacro.h"
@implementation SVLocalFileBottomView
{
    UIButton *_addButton;
    UIButton *_deleteButton;
    UILabel *_sizeLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareSubviews];
    }
    return self;
}

// MARK: - Action

- (void)addClickAction {
    if (self.addAction) {
        self.addAction();
    }
}

- (void)deleteClickAction {
    if (self.deleteAction) {
        self.deleteAction();
    }
}

- (void)updateSize:(NSString *)text{
    _sizeLabel.text = text;
}

- (void)changeSelectStatus:(BOOL )showSelect {
    if (_storageType==1) {
        _addButton.hidden = _deleteButton.hidden  =  !showSelect;
    }else{
        _addButton.hidden = !showSelect;
        _deleteButton.hidden = YES;
    }
    
    _sizeLabel.hidden = showSelect;
}

// MARK: - view

- (void)prepareSubviews {
    self.backgroundColor = [UIColor colorWithHex:0x333333];
    _addButton = [UIButton buttonWithTitle:SVLocalized(@"home_add_to_play") titleColor:UIColor.whiteColor font:kSystemFont(14)];
    [_addButton addTarget:self action:@selector(addClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    _deleteButton = [UIButton buttonWithTitle:SVLocalized(@"home_delete") titleColor:UIColor.whiteColor font:kSystemFont(14)];
    [_deleteButton addTarget:self action:@selector(deleteClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    _sizeLabel = [UILabel labelWithText:@"" font:kSystemFont(12) color:[UIColor colorWithHex:0xffffff alpha:0.58]];
    
    [self changeSelectStatus:NO];
    [self addSubview:_addButton];
    [self addSubview:_deleteButton];
    [self addSubview:_sizeLabel];
    
    [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kHeight(10));
        make.left.equalTo(self).offset(kWidth(24));
    }];
    
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kHeight(10));
        make.right.equalTo(self).offset(-kWidth(24));
    }];
    
    [_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(12);
        make.centerX.equalTo(self);
    }];
    
    self.layer.shadowColor = [UIColor colorWithHex:0x000000 alpha:0.4].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, -kWidth(4));
    self.layer.shadowOpacity = 1.0;
}


@end

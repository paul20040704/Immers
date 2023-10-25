//
//  SVEventButton.m
//  Immers
//
//  Created by developer on 2022/10/14.
//

#import "SVEventButton.h"
#import "SVGlobalMacro.h"

@implementation SVEventButton {
    NSString *_title;
    NSString *_imageName;
    
    UILabel *_countLabel;
    NSInteger _sizeType;
}

+ (instancetype)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName sizeType:(NSInteger )sizeType {
    return [[self alloc] initWithTitle:title imageName:imageName sizeType:sizeType];
}

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName sizeType:(NSInteger )sizeType{
    if (self = [super init]) {
        _title = title;
        _imageName = imageName;
        _sizeType = sizeType;
        [self prepareSubviews];
    }
    return self;
}

// MARK: - Settet
- (void)setCount:(NSInteger)count {
    _count = count;
    _countLabel.hidden = 0 == count;
    _countLabel.text = [NSString stringWithFormat:@"%ld", count];
    
    [_countLabel sizeToFit];
    [_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_countLabel.bounds.size.width + kWidth(14));
    }];
}

- (void)prepareSubviews {
    self.backgroundColor = [UIColor colorWithHex:0xF2F4F5];
    self.layer.cornerRadius  = kHeight(12);
    self.layer.shadowColor = [UIColor colorWithHex:0x000000 alpha:0.2].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, kWidth(4));
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowRadius = kHeight(12);
    
    UILabel *titleLabel = [UILabel labelWithText:_title font:kSystemFont(14) color:[UIColor textColor]];
    UIImageView *iconView = [UIImageView imageViewWithImageName:_imageName];
    _countLabel = [UILabel labelWithTextColor:[UIColor whiteColor] font:kSystemFont(10) alignment:NSTextAlignmentCenter];
    _countLabel.backgroundColor = [UIColor colorWithHex:0xFB7F7C];
    _countLabel.layer.cornerRadius = kHeight(9);
    _countLabel.layer.masksToBounds = YES;
    _countLabel.hidden = YES;
    
    [self addSubview:titleLabel];
    [self addSubview:iconView];
    [self addSubview:_countLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if(_sizeType==0){
            make.left.equalTo(self).offset(kWidth(12));
            make.top.equalTo(self).offset(kHeight(9));
        }else{
            make.left.equalTo(self).offset(kWidth(16));
            make.top.equalTo(self).offset(kHeight(12));
        }
        
    }];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(kWidth(-10));
        if(_sizeType==0){
            make.centerY.equalTo(self);
        }else{
            make.bottom.equalTo(self).offset(kWidth(-10));
        }
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            make.size.mas_equalTo(CGSizeMake(kWidth(44), kWidth(44)));
        } else {
            make.size.mas_equalTo(CGSizeMake(kWidth(49), kWidth(49)));
        }
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(iconView.mas_right).offset(kWidth(-18));
        make.centerY.equalTo(iconView.mas_top).offset(kWidth(12));
        make.height.mas_equalTo(kHeight(18));
    }];
}

@end

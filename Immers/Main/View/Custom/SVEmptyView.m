//
//  SVEmptyView.m
//  Immers
//
//  Created by developer on 2022/5/16.
//

#import "SVEmptyView.h"
#import "SVGlobalMacro.h"

@implementation SVEmptyView {
    NSString *_text;
    NSString *_imageName;
    UIColor *_textColor;
    
    UIImageView *_iconView;
    UILabel *_textLabel;
}

/// 空数据
/// @param text 提示文本
/// @param imageName 图片名
+ (instancetype)viewWithText:(NSString *)text imageName:(NSString *)imageName {
    return [[self alloc] initWithText:text imageName:imageName];
}

+ (instancetype)viewWithText:(nullable NSString *)text imageName:(nullable NSString *)imageName textColor:(UIColor *)textColor{
    return [[self alloc] initWithText:text imageName:imageName textColor:textColor];
}

- (instancetype)initWithText:(NSString *)text imageName:(NSString *)imageName {
    if (self = [super init]) {
        _text = text;
        _imageName = imageName;
        [self prepareSubviews];
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text imageName:(NSString *)imageName textColor:(UIColor *)textColor {
    if (self = [super init]) {
        _text = text;
        _imageName = imageName;
        _textColor = textColor;
        [self prepareSubviews];
    }
    return self;
}


- (void)prepareSubviews {
    NSAssert((nil != _text || nil != _imageName), @"text或imageName不为空");
    // icon view
    if (_imageName && _imageName.length > 0) {
        _iconView = [UIImageView imageViewWithImageName:_imageName];
        [self addSubview:_iconView];
        
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(self);
            if (nil == _text || _text.length <= 0) {
                make.bottom.equalTo(self);
            }
        }];
    }
    
    // tip text
    if (_text && _text.length > 0) {
        _textLabel = [UILabel labelWithText:_text font:kSystemFont(14) color:_textColor?_textColor:[UIColor grayColor5]];
        _textLabel.preferredMaxLayoutWidth = kWidth(260);
        [_textLabel sizeToFit];
        [self addSubview:_textLabel];
        
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (_imageName && _imageName.length > 0) {
                make.centerX.equalTo(self);
                make.top.equalTo(_iconView.mas_bottom).offset(kHeight(10));
            } else {
                make.top.centerX.equalTo(self);
            }
            make.bottom.equalTo(self);
        }];
    }
    
    CGFloat maxWidth = 0;
    CGFloat height = 0;
    if (_imageName && _imageName.length > 0) {
        maxWidth = _iconView.bounds.size.width;
        height = _iconView.bounds.size.height;
    }
    
    if (_text && _text.length > 0) {
        CGFloat width = _textLabel.bounds.size.width;
        if (width > maxWidth) {
            maxWidth = width;
        }
        
        height += _textLabel.bounds.size.height;
        if (_imageName && _imageName.length > 0) {
            height += kHeight(10);
        }
    }
    
    self.bounds = CGRectMake(0, 0, maxWidth, height);
    
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(maxWidth);
//        (_imageName && _imageName.length > 0) ? make.top.equalTo(_iconView) : make.top.equalTo(_textLabel);
//        (_text && _text.length > 0) ? make.bottom.equalTo(_textLabel) : make.bottom.equalTo(_iconView);
//    }];
}

@end

//
//  SVAlbumViewCell.m
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import "SVAlbumViewCell.h"
#import "SVProgressView.h"

@implementation SVAlbumViewCell {
    UIImageView *_coverView;
    UIButton *_stateButton;
    UILabel *_durationLabel;
    UILabel *_sizeLabel;
    SVProgressView *_progressView;
}

// MARK: - setter
- (void)setFile:(SVFile *)file {
    _file = file;
    _stateButton.hidden = !file.show;
    _stateButton.selected = file.selected;
    _progressView.progress = file.progress;
}

- (void)setPhoto:(SVPhoto *)photo {
    _photo = photo;
    _stateButton.hidden = !photo.show;
    _stateButton.selected = photo.selected;
    _progressView.progress = photo.progress;
    _durationLabel.text =  photo.videoDuration;
    if (photo.cover) {
        if ([photo.cover hasPrefix:@"http"]) {
            [_coverView setImageWithURL:photo.cover placeholder:[UIImage imageNamed:@"global_image_default"]];
        } else {
            NSArray <NSString *> *strings = [photo.cover componentsSeparatedByString:@","];
            NSData *data = [[NSData alloc] initWithBase64EncodedString:strings.lastObject options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *image = [UIImage imageWithData:data];
            _coverView.image = image?:[UIImage imageNamed:@"global_image_fail"];
        }

    } else {
        _coverView.image = photo.image;
    }
}

- (void)setLocalFile:(SVLocalFile *)localFile {
    _localFile = localFile;
    
    _progressView.hidden = YES;
    _durationLabel.hidden = YES;
    _stateButton.hidden = !localFile.show;
    _stateButton.selected = localFile.selected;
    
    _sizeLabel.text = [NSString byte2mb:localFile.size];
    
    if ([localFile.cover hasPrefix:@"http"]) {
        [_coverView setImageWithURL:localFile.cover placeholder:[UIImage imageNamed:@"global_image_default"]];
    } else {
        NSArray <NSString *> *strings = [localFile.cover componentsSeparatedByString:@","];
        NSData *data = [[NSData alloc] initWithBase64EncodedString:strings.lastObject options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image = [UIImage imageWithData:data];
        _coverView.image = image?:(localFile.getCoverState==1?[UIImage imageNamed:@"global_image_default"]: [UIImage imageNamed:@"global_image_fail"]);
    }
    
    if (localFile.lastLine) {
        [_coverView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
        }];
    }else{
        [_coverView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-kWidth(2));
        }];
    }
    if (localFile.lastRow) {
        [_coverView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView);
        }];
    }else{
        [_coverView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-kWidth(2));
        }];
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
    //self.contentView.backgroundColor = UIColor.whiteColor;
    _coverView = [UIImageView imageView];
    _coverView.backgroundColor = [UIColor backgroundColor];
    
    _stateButton = [UIButton buttonWithNormalName:@"home_album_normal" selectedName:@"home_album_selected"];
    _stateButton.userInteractionEnabled = NO;
    [_stateButton sizeToFit];
//    _textLabel = [UILabel labelWithTextColor:[UIColor textColor] font:kSystemFont(14) alignment:NSTextAlignmentCenter];
    
    _durationLabel = [UILabel labelWithTextColor:[UIColor whiteColor] font:kSystemFont(12)];
    
    _sizeLabel = [UILabel labelWithTextColor:UIColor.whiteColor font:kSystemFont(13)];
    
    _progressView = [[SVProgressView alloc] init];
    
    [self.contentView addSubview:_coverView];
    [self.contentView addSubview:_stateButton];
//    [self.contentView addSubview:_textLabel];
    [self.contentView addSubview:_durationLabel];
    [self.contentView addSubview:_progressView];
    [self.contentView addSubview:_sizeLabel];
    
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView);
        make.right.bottom.equalTo(self.contentView).offset(-kWidth(2));
    }];
    
    [_stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kHeight(10));
        make.right.equalTo(self.contentView).offset(kHeight(-10));
    }];
    
//    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.width.equalTo(self.contentView);
//    }];
    
    [_durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(kWidth(-6));
        make.height.mas_equalTo(kHeight(24));
        make.bottom.equalTo(self.contentView);
    }];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
    
    [_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kWidth(6));
        make.bottom.equalTo(self.contentView).offset(kHeight(-4));
    }];
}

@end

//
//  SVTaskViewCell.m
//  Immers
//
//  Created by developer on 2022/10/14.
//

#import "SVTaskViewCell.h"

@implementation SVTaskViewCell {
    UIImageView *_taskView;
    UILabel *_statusLabel;
    UILabel *_progressLabel;
    UIProgressView *_progressView;
    UIImageView *_errorView;
}

// MARK: - Setter
- (void)setDown:(SVDown *)down {
    _down = down;
    // [down.twoImageUrl stringByAppendingFormat:@"?x-oss-process=image/resize,p_50"]
    [_taskView setImageWithURL:down.twoImageUrl placeholder:[UIImage imageNamed:@"global_image_default"]];
    _statusLabel.text = down.stateText;
    _progressLabel.text = down.progressText;
    [_progressView setProgress:down.percent / 100.0 animated:YES];
    _errorView.hidden = 0 != down.state;
}

// MARK: - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self prepareSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

// MARK: - prepare
- (void)prepareSubviews {
    _taskView = [UIImageView imageView];
    _taskView.layer.cornerRadius = kHeight(4);
    _taskView.layer.masksToBounds = YES;
    _taskView.backgroundColor = [UIColor backgroundColor];
    
    _statusLabel = [UILabel labelWithTextColor:[UIColor textColor] font:kSystemFont(14)];
    _progressLabel = [UILabel labelWithTextColor:[UIColor textColor] font:kSystemFont(14)];
    
    _errorView = [UIImageView imageViewWithImageName:@"home_download_error"];
    _errorView.hidden = YES;
    
    _progressView = [[UIProgressView alloc] init];
    _progressView.progressTintColor = [UIColor grassColor3];
    _progressView.trackTintColor = [UIColor colorWithHex:0xD9D9D9];
    
    [self.contentView addSubview:_taskView];
    [self.contentView addSubview:_statusLabel];
    [self.contentView addSubview:_progressLabel];
    [self.contentView addSubview:_progressView];
    [self.contentView addSubview:_errorView];
    
    [_taskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kWidth(24));
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(kHeight(-6));
        make.width.mas_equalTo(kWidth(40));
    }];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_taskView.mas_right).offset(kWidth(10));
        make.top.equalTo(_taskView).offset(kHeight(10));
    }];
    
    [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(kWidth(-24));
        make.centerY.equalTo(_statusLabel);
    }];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_statusLabel.mas_bottom).offset(kHeight(6));
        make.left.equalTo(_statusLabel);
        make.right.equalTo(_progressLabel);
        make.height.mas_equalTo(kWidth(6));
    }];
    
    [_errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_statusLabel.mas_right).offset(kWidth(6));
        make.centerY.equalTo(_statusLabel);
    }];
}

@end

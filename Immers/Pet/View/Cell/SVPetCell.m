//
//  SVPetCell.m
//  Immers
//
//  Created by ssv on 2022/11/14.
//

#import "SVPetCell.h"
#import "SVGlobalMacro.h"
@implementation SVPetCell
{
    UIImageView *_bgImageView;
    UIButton *_bottomButton;
    UIView *_progressView;
    UILabel *_bottomLabel;
    UIButton *_cancelButton;
    UIImageView *_reloadImageView;
}
// MARK: - init
- (instancetype )initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        [self prepareSubViews];
    }
    return self;
}

// MARK: - Action
- (void)buttonClick {
    if (self.clickAction) {
        self.clickAction(0);
    }
}

- (void)cancelAction {
    if (self.clickAction) {
        self.clickAction(1);
    }
}

- (void)reloadAdobt {
    if (self.clickAction) {
        self.clickAction(2);
    }
}

// MARK: - View
- (void)prepareSubViews {
    self.contentView.layer.cornerRadius = kHeight(10);
    self.contentView.layer.masksToBounds = YES;
    _bgImageView = [UIImageView new];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_bgImageView];
    
    _bottomButton = [UIButton buttonWithTitle:@"" titleColor:UIColor.whiteColor font:kSystemFont(14)];
    [_bottomButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomButton setBackgroundColor:UIColor.blackColor];
    [self.contentView addSubview:_bottomButton];
    
    _progressView = [UIView new];
    _progressView.backgroundColor = UIColor.grassColor;
    [self.contentView addSubview:_progressView];
    
    _bottomLabel = [UILabel labelWithTextColor:UIColor.whiteColor font:kSystemFont(14)];
    _bottomLabel.textAlignment = NSTextAlignmentCenter;
    _bottomLabel.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:_bottomLabel];
    
    _cancelButton = [UIButton buttonWithImageName:@"pet_cancel_download"];
    [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton.hidden = YES;
    [self.contentView addSubview:_cancelButton];
    
    _reloadImageView = [UIImageView imageViewWithImageName:@"pet_reload_download"];
    _reloadImageView.userInteractionEnabled = YES;
    _reloadImageView.hidden = YES;
    _reloadImageView.backgroundColor = UIColor.grayColor6;
    _reloadImageView.contentMode = UIViewContentModeCenter;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadAdobt)];
    [_reloadImageView addGestureRecognizer:tap];
    [self.contentView addSubview:_reloadImageView];
    
    
    [_bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(kHeight(32));
    }];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.bottom.equalTo(_bottomButton.mas_top);
    }];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(_bottomButton);
        make.width.mas_equalTo(1);
    }];

    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(_bottomButton);
        make.left.equalTo(_bottomButton).offset(kWidth(4));
    }];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(_bottomButton);
        make.width.mas_equalTo(kWidth(34));
    }];
    
    [_reloadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bgImageView);
    }];
}

// MARK: - setter
- (void)setPetModel:(SVPetModel *)petModel {
    _petModel = petModel;
    [_bgImageView setImageWithURL:petModel.petImage placeholder:[UIImage imageNamed:@"pet_head_backGround"]];
    if(petModel.isAdopt.intValue==2||(0<_percent&&_percent<100)){
        //领养中
        if (_percent==-1&&petModel.verification) {
            //宠物丢失、显示重新领养样式
            _reloadImageView.hidden = NO;
            _cancelButton.hidden = YES;
            _bottomLabel.text = [NSString stringWithFormat:SVLocalized(@"pet_adopt_fail"),petModel.petName];
            _bottomLabel.textAlignment = NSTextAlignmentCenter;
            _bottomButton.backgroundColor = [UIColor colorWithHex:0xfe8383];
            _progressView.hidden = YES;
            [_progressView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
        }else{
            //领养中
            _reloadImageView.hidden = YES;
            _cancelButton.hidden = NO;
            NSString *progressText = SVLocalized(@"pet_adopt_progress");
            _bottomLabel.text = [NSString stringWithFormat:@"%@ %ld%%",progressText,MAX(_percent, 0)];
            _bottomLabel.textAlignment = NSTextAlignmentLeft;
            _bottomButton.backgroundColor = UIColor.blackColor;
            _progressView.hidden = NO;
            [_progressView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(self.contentView.mj_w*MAX(_percent, 0)/100);
            }];
            [self layoutIfNeeded];
            [_progressView corners:UIRectCornerTopRight|UIRectCornerBottomRight radius:kHeight(32/2)];
        }
        _bottomButton.enabled = NO;

    }else if (petModel.isAdopt.intValue==1||_percent>=100){
        //已领养
        _reloadImageView.hidden = YES;
        _cancelButton.hidden = YES;
        _bottomButton.enabled = NO;
        _bottomLabel.text = [NSString stringWithFormat:@"%@ %@",SVLocalized(@"pet_already_adopt"),petModel.petName];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomButton.backgroundColor = UIColor.grassColor;
        _progressView.hidden = NO;
        [_progressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.contentView.mj_w);
        }];
        
    }
    else{
        //未领养
        _reloadImageView.hidden = YES;
        _cancelButton.hidden = YES;
        _bottomButton.enabled = YES;
        _bottomButton.backgroundColor = UIColor.blackColor;
        _bottomLabel.text = [NSString stringWithFormat:@"%@ %@",SVLocalized(@"pet_adopt"),petModel.petName];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _progressView.hidden = YES;
        [_progressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
}




@end

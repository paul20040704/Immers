//
//  LGScrollCardImgView.m
//  SonkwoApp
//
//  Created by zdby on 2022/6/21.
//  Copyright © 2022 ceasia. All rights reserved.
//

#import "LGScrollCardImgView.h"
#import "LGScrollCardConfig.h"
#import "UIImageView+Extension.h"
#import "UIView+Extension.h"
@interface LGScrollCardImgView ()

@property (nonatomic,strong)LGScrollCardLayout *imgLayout;
// 当默认的初始图的宽度
@property (nonatomic,assign)CGFloat imageWidth;

@end

@implementation LGScrollCardImgView

-(instancetype)initWithFrame:(CGRect)frame imgLayout:(LGScrollCardLayout*)imgLayout
{
    self = [super initWithFrame:frame];
    if(self){
        self.imgLayout = imgLayout;
        
        self.backgroundColor = UIColor.clearColor;
        self.imageWidth = frame.size.width - (imgLayout.overloopCount-1)*imgLayout.lineMargin;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.imageWidth, frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = true;
        self.imageView = imageView;
        [self addSubview:imageView];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.imageWidth = frame.size.width - (LG_EASY_CARD_OVERLAP_COUNT-1)*LG_EASY_CARD_PHOTO_LINE_MARGIN;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.imageWidth, frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = true;
        self.imageView = imageView;
        [self addSubview:imageView];
    }
    return self;
}


-(void)setImgUrl:(NSString *)imgUrl
{
    _imgUrl = imgUrl;
    if(imgUrl == nil){
        self.imageView.alpha = 0;
        self.imageView.image = nil;
    }else{
        self.imageView.alpha = 1;
        if([imgUrl containsString:@"type=0"]){
            [self.imageView setImageWithURL:imgUrl placeholder:[UIImage imageNamed:@"global_image_default"]];
        }else{
            [self.imageView setVideoPreViewImageURL:imgUrl placeHolderImage:[UIImage imageNamed:@"global_image_default"]];
        }
    }
}

-(void)setPosition:(float)position
{
    _position = position;
    if(position < 0){
        self.imageView.frame = CGRectMake(0, 0, self.imageWidth, self.bounds.size.height);
        return;
    }
    
    float position_value = position;
    if(position_value >= self.imgLayout.overloopCount-1){
        position_value = self.imgLayout.overloopCount-1;
    }
    // istemp的view只有向左滑作为最底层
    if(self.istemp){
        position_value = self.imgLayout.overloopCount-1;
    }
    
    // 0: 距离右侧有一定的距离
    CGFloat y = (self.imgLayout.overloopCount-1)*self.imgLayout.rowMargin * position_value;
    CGFloat h = self.bounds.size.height - 2 * y;
    CGFloat w = self.imageWidth;
    CGFloat x = self.imgLayout.lineMargin * position_value;
    
    
    self.imageView.frame = CGRectMake(x, y, w, h);
    
    // 根据实际获取最大圆角和最小圆角
//    CGFloat minRadius = MIN(self.imgLayout.minCornerRadius, self.imgLayout.maxCornerRadius);
//    CGFloat maxRadius = MAX(self.imgLayout.minCornerRadius, self.imgLayout.maxCornerRadius);
//
//    // 动态计算圆角
//    CGFloat cornerAdd = (maxRadius - minRadius) * ((self.imgLayout.overloopCount-1) - position_value) / (self.imgLayout.overloopCount-1);
//    [self.imageView.layer setCornerRadius:(minRadius+cornerAdd)];
//    [self.imageView.layer setMasksToBounds:true];
    [self.imageView corner];
    
}

@end

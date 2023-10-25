//
//  LGScrollCardImgView.h
//  SonkwoApp
//
//  Created by zdby on 2022/6/21.
//  Copyright © 2022 ceasia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGScrollCardLayout.h"
NS_ASSUME_NONNULL_BEGIN

@interface LGScrollCardImgView : UIView
-(instancetype)initWithFrame:(CGRect)frame imgLayout:(LGScrollCardLayout*)imgLayout;

// 内部的图片
@property (nonatomic,weak)UIImageView *imageView;
// 图片地址
@property (nonatomic,copy,nullable)NSString *imgUrl;
// 是否是用来底部做切换用的
@property (nonatomic,assign)BOOL istemp;
/// 当前位置
@property (nonatomic,assign)float position;
@end

NS_ASSUME_NONNULL_END

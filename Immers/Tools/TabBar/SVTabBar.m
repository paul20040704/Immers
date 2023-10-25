//
//  SVTabBar.m
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import "SVTabBar.h"
#import "SVGlobalMacro.h"

@interface SVTabBar ()

@property (nonatomic, strong) UIButton *uploadButton;
@property (nonatomic, strong) UIButton *plusButton;

@end

@implementation SVTabBar
{
    CGFloat _tabarHeiht;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        if (@available(iOS 13.0, *)) {
            UITabBarAppearance *standardAppearance = [[UITabBarAppearance alloc] init];
            standardAppearance.backgroundColor = [UIColor whiteColor];
            standardAppearance.shadowColor = [UIColor clearColor];
            [standardAppearance configureWithTransparentBackground];
            standardAppearance.stackedLayoutAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
            self.standardAppearance = standardAppearance;
        } else {
            [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
            [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
            [UITabBar appearance].backgroundColor = [UIColor whiteColor];
        }
        
        //self.tintColor = [UIColor grassColor];
        //self.unselectedItemTintColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.3;
        self.clipsToBounds = NO;
        
        [self prepareSubviews];
    }
    return self;
}

/// 子控件
- (void)prepareSubviews {
    // 添加上传按钮
    [self addSubview:self.uploadButton];
    
    [self.uploadButton addTarget:self action:@selector(uploadClick) forControlEvents:UIControlEventTouchUpInside];
}

/// 上传事件
- (void)uploadClick {
    if (self.uploadCallback) {
        self.uploadCallback();
    }
}

/// 布局
- (void)layoutSubviews {
    [super layoutSubviews];

    // 高度 / 位置
    _tabarHeiht = self.bounds.size.height;
    if ([[UIDevice currentDevice] userInterfaceIdiom]  == UIUserInterfaceIdiomPhone) {
        _tabarHeiht = kHeight(90);
    }
    
    //CGFloat x = kWidth(24);
    self.frame = CGRectMake(0, kScreenHeight-_tabarHeiht, kScreenWidth, _tabarHeiht);
    // 设置中心点
    self.uploadButton.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) * 0.3);

    [self updateFrame];
}

/// 是否显现
- (void)setShow:(BOOL)show {
    _show = show;
    [UIView animateWithDuration:0.25 animations:^{
        self.uploadButton.alpha = show ? 0.0 : 1.0;
    }completion:^(BOOL finished) {
        [self updateFrame];
    }];
    
}


- (void)updateFrame{
    // 修改位置
    CGFloat w = CGRectGetWidth(self.frame) / (_show?4:5);
    NSInteger index = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            if ([[UIDevice currentDevice] userInterfaceIdiom]  == UIUserInterfaceIdiomPad) {
                child.frame = CGRectMake(index * w, 0, w, _tabarHeiht);
            } else {
                child.frame = CGRectMake(index * w, kHeight(5), w, kHeight(54));
            }
            if (index==1&&!_show) {
                index++;
            }
            index += 1;

        }
    }
    
}

// MARK: - 重写hitTest方法以响应点击超出tabBar的加号按钮
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.clipsToBounds && !self.hidden && self.alpha > 0) {
        UIView *result = [super hitTest:point withEvent:event];
        
        if (result) {
            return result;
        } else {
            for (UIView *subview in self.subviews.reverseObjectEnumerator) {
                CGPoint subPoint = [subview convertPoint:point fromView:self];
                result = [subview hitTest:subPoint withEvent:event];
                if (result) {
                    return result;
                }
            }
        }
    }
    return nil;
}

// MARK: - lazy
- (UIButton *)uploadButton {
    if (!_uploadButton) {
        _uploadButton = [UIButton buttonWithImageName:@"tabbar_upload"];
        [_uploadButton sizeToFit];
    }
    return _uploadButton;
}



@end

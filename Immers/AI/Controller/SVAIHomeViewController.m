//
//  SVAIHomeViewController.m
//  Immers
//
//  Created by Paul on 2023/8/1.
//

#import "SVAIHomeViewController.h"
#import "SVGlobalMacro.h"
#import "SVAIViewController.h"
#import "SVAIVideoViewController.h"

@interface SVAIHomeViewController () {
    UIButton *_imageButton;
    UIButton *_videoButton;
}

@end

@implementation SVAIHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareSubviews];
}

// MARK: -UIView
- (void)prepareSubviews {
    _imageButton = [UIButton buttonWithImageName:@"AI_image"];
    _imageButton.tag = 100;
    [_imageButton setTitle:SVLocalized(@"ai_image") forState:UIControlStateNormal];
    [_imageButton resetButtonStyle:SVButtinStyleTop space:10];
    [_imageButton setBackgroundColor: [UIColor colorWithHexString:@"#95A9D3"]];
    [_imageButton corner:20];
    [_imageButton addTarget:self action:@selector(buttonClick:) forControlEvents: UIControlEventTouchUpInside];
    
    _videoButton = [UIButton buttonWithImageName:@"AI_video"];
    _videoButton.tag = 101;
    [_videoButton setTitle:SVLocalized(@"ai_video") forState:UIControlStateNormal];
    [_videoButton resetButtonStyle:SVButtinStyleTop space:10];
    [_videoButton setBackgroundColor: [UIColor colorWithHexString:@"#95A9D3"]];
    [_videoButton corner:20];
    [_videoButton addTarget:self action:@selector(buttonClick:) forControlEvents: UIControlEventTouchUpInside];
    
    [self addSubview:_imageButton];
    [self addSubview:_videoButton];
    
    [_imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavBarHeight + kStatusBarHeight);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(kHeight(250));
    }];

    
    [_videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo((_imageButton.mas_bottom)).offset(40);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(kHeight(250));
    }];
    
}

// MARK: -Action
- (void)buttonClick:(UIButton *)sender {
    NSInteger tag = sender.tag - 100;
    if(tag==0){
        SVAIViewController *viewController = [[SVAIViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }else {
        SVAIVideoViewController *viewController = [[SVAIVideoViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


@end

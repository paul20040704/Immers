//
//  SVAIZoomViewController.m
//  Immers
//
//  Created by Paul on 2023/8/9.
//

#import "SVAIZoomViewController.h"
#import "SVGlobalMacro.h"
#import <Photos/Photos.h>

@interface SVAIZoomViewController () <UIScrollViewDelegate>

@end

@implementation SVAIZoomViewController {
    UIScrollView *_scrollView;
    UIImageView *_imageView;
    UIButton *_saveButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareSubviews];
}

- (void)prepareSubviews {
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 3.0;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _imageView = [[UIImageView alloc]initWithImage:self.image];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _saveButton = [UIButton buttonWithTitle:SVLocalized(@"home_member_save") titleColor:[UIColor whiteColor] font:kSystemFont(14)];
    [_saveButton setBackgroundColor:[UIColor grayColor]];
    [_saveButton corner];
    [_saveButton addTarget:self action:@selector(saveImagesToAlbum) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_scrollView];
    [self.view addSubview:_saveButton];
    [_scrollView addSubview:_imageView];
    
    _scrollView.contentSize = _imageView.frame.size;
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(600));
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kHeight(600));
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth(120));
        make.height.mas_equalTo(kHeight(30));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(kHeight(-40));
    }];
    
}

-(void)saveImagesToAlbum {
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        NSMutableArray *assetRequests = [NSMutableArray array];
        PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:self.image];
        [assetRequests addObject:assetRequest.placeholderForCreatedAsset];
        PHAssetCollectionChangeRequest *collectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"My Album"];
        [collectionRequest addAssets:assetRequests];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_save_image_succeed")];
            }else {
                [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_save_image_erroe")];
            }
        });
    }];
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

@end

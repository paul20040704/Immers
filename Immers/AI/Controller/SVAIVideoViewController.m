//
//  SVAIVideoViewController.m
//  Immers
//
//  Created by Paul on 2023/8/2.
//

#import "SVAIVideoViewController.h"
#import "SVGlobalMacro.h"
#import "SVPickerViewController.h"
#import "SVAIVideoViewModel.h"
#import "SVAIDropDownView.h"

@interface SVAIVideoViewController () <UITextViewDelegate>
@property (nonatomic,strong)SVAIVideoViewModel *viewModel;
@property (nonatomic, strong) NSTimer *backgroundTimer;
@property (nonatomic,strong)SVAIDropDownView *dropMenu;
@property (nonatomic,strong)NSString *voiceType; //選中的聲音
@end

@implementation SVAIVideoViewController {
    UIButton *_allButton;
    UIButton *_maleButton;
    UIButton *_femaleButton;
    UIButton *_chlidButton;
    UIButton *_uploadButton;
    UITextView *_inputTextView;
    UIButton *_jokeButton;
    UIButton *_encourageButton;
    UIButton *_greetButton;
    UIButton *_confirmButton;
    UIImage *_selectImage;
    NSString *_uuid;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
    [SVProgressHUD dismiss];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_dropMenu closeMenu];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareSubviews];
    _dropMenu.datas = @[@"Davis", @"Guy", @"Eric", @"Nancy", @"Jenny", @"Ana"];
    self.voiceType = @"Davis";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

// MARK: -UIView
- (void)prepareSubviews {
    _uploadButton = [UIButton buttonWithTitle:SVLocalized(@"home_select_album") titleColor:[UIColor colorWithHexString:@"ADADAD"] font:kSystemFont(14)];
    [_uploadButton setImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
    [_uploadButton resetButtonStyle:SVButtinStyleTop space:10];
    [_uploadButton corner:20];
    _uploadButton.layer.borderWidth = kWidth(1);
    _uploadButton.layer.borderColor = [UIColor colorWithHexString:@"#D0D0D0"].CGColor;
    [_uploadButton addTarget:self action:@selector(pickImage) forControlEvents: UIControlEventTouchUpInside];
    
    _allButton = [UIButton buttonWithTitle:SVLocalized(@"all") titleColor:[UIColor colorWithHexString:@"#6988F5"] font:kSystemFont(14)];
    [_allButton setBackgroundColor:[UIColor colorWithHexString:@"#E9EDF5"]];
    [_allButton corner];
    _allButton.tag = 100;
    [_allButton addTarget:self action:@selector(voiceButton:) forControlEvents: UIControlEventTouchUpInside];
    
    _maleButton = [UIButton buttonWithTitle:SVLocalized(@"men") titleColor:[UIColor colorWithHexString:@"#6988F5"] font:kSystemFont(14)];
    [_maleButton setBackgroundColor:[UIColor colorWithHexString:@"#E9EDF5"]];
    [_maleButton corner];
    _maleButton.tag = 101;
    [_maleButton addTarget:self action:@selector(voiceButton:) forControlEvents: UIControlEventTouchUpInside];
    
    _femaleButton = [UIButton buttonWithTitle:SVLocalized(@"female") titleColor:[UIColor colorWithHexString:@"#6988F5"] font:kSystemFont(14)];
    [_femaleButton setBackgroundColor:[UIColor colorWithHexString:@"#E9EDF5"]];
    [_femaleButton corner];
    _femaleButton.tag = 102;
    [_femaleButton addTarget:self action:@selector(voiceButton:) forControlEvents: UIControlEventTouchUpInside];
    
    _chlidButton = [UIButton buttonWithTitle:SVLocalized(@"chlid") titleColor:[UIColor colorWithHexString:@"#6988F5"] font:kSystemFont(14)];
    [_chlidButton setBackgroundColor:[UIColor colorWithHexString:@"#E9EDF5"]];
    [_chlidButton corner];
    _chlidButton.tag = 103;
    [_chlidButton addTarget:self action:@selector(voiceButton:) forControlEvents: UIControlEventTouchUpInside];
    
    kWself;
    _dropMenu = [[SVAIDropDownView alloc] initWithFrame:CGRectMake(30, (kNavBarHeight + kStatusBarHeight + kHeight(300)), (kScreenWidth - 60), kHeight(36))];
    _dropMenu.rowHeight = kHeight(36);
    _dropMenu.autoCloseWhenSelected = YES;
    _dropMenu.textColor = UIColor.grayColor3;
    _dropMenu.indicatorColor = UIColor.grayColor3;
    _dropMenu.cellClickedBlock = ^(NSString * _Nonnull title, NSInteger index) {
        //[wself selectDevice:index];
        wself.voiceType = title;
    };
    
    _inputTextView = [[UITextView alloc] init];
    _inputTextView.backgroundColor = [UIColor colorWithHex:0xf0f0f0];
    _inputTextView.textColor = [UIColor colorWithHex:0x333333];
    _inputTextView.delegate = self;
    _inputTextView.text = @" ";
    [_inputTextView deleteBackward];
    [_inputTextView corner];
    _inputTextView.textContainerInset = UIEdgeInsetsMake(kWidth(14), kWidth(14), kWidth(14), kWidth(14));
    [_inputTextView placeholderWith:SVLocalized(@"profile_enter_comments") szie:12 color:[UIColor colorWithHex:0x999999]];
    
    _jokeButton = [UIButton buttonWithTitle:SVLocalized(@"joke") titleColor:[UIColor colorWithHexString:@"#6988F5"] font:kSystemFont(14)];
    [_jokeButton setBackgroundColor:[UIColor colorWithHexString:@"#E9EDF5"]];
    [_jokeButton corner];
    _jokeButton.tag = 101;
    [_jokeButton addTarget:self action:@selector(buttonClick:) forControlEvents: UIControlEventTouchUpInside];
    
    _encourageButton = [UIButton buttonWithTitle:SVLocalized(@"encourage") titleColor:[UIColor colorWithHexString:@"#6988F5"] font:kSystemFont(14)];
    [_encourageButton setBackgroundColor:[UIColor colorWithHexString:@"#E9EDF5"]];
    [_encourageButton corner];
    _encourageButton.tag = 102;
    [_encourageButton addTarget:self action:@selector(buttonClick:) forControlEvents: UIControlEventTouchUpInside];
    
    _greetButton = [UIButton buttonWithTitle:SVLocalized(@"greeting") titleColor:[UIColor colorWithHexString:@"#6988F5"] font:kSystemFont(14)];
    [_greetButton setBackgroundColor:[UIColor colorWithHexString:@"#E9EDF5"]];
    [_greetButton corner];
    _greetButton.tag = 103;
    [_greetButton addTarget:self action:@selector(buttonClick:) forControlEvents: UIControlEventTouchUpInside];
    
    _confirmButton = [UIButton buttonWithTitle:SVLocalized(@"confirm") titleColor:[UIColor whiteColor] font:kSystemFont(20)];
    [_confirmButton setBackgroundColor:[UIColor colorWithHexString:@"#6988F5"]];
    [_confirmButton corner:20];
    [_confirmButton addTarget:self action:@selector(confirmClick) forControlEvents: UIControlEventTouchUpInside];
    
    [self addSubview:_allButton];
    [self addSubview:_maleButton];
    [self addSubview:_femaleButton];
    [self addSubview:_chlidButton];
    [self addSubview:_uploadButton];
    [self addSubview:_inputTextView];
    [self addSubview:_jokeButton];
    [self addSubview:_encourageButton];
    [self addSubview:_greetButton];
    [self addSubview:_confirmButton];
    [self addSubview:_dropMenu];
    
    [_uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavBarHeight + kStatusBarHeight);
        make.left.equalTo(self.view).offset(90);
        make.right.equalTo(self.view).offset(-90);
        make.height.mas_equalTo(kHeight(250));
    }];
    
    [_allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_uploadButton.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(30);
        make.height.mas_equalTo(kHeight(30));
        make.width.mas_equalTo(kWidth(70));
    }];
    
    [_maleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_uploadButton.mas_bottom).offset(10);
        make.left.equalTo(_allButton.mas_right).offset(10);
        make.height.mas_equalTo(kHeight(30));
        make.width.mas_equalTo(kWidth(70));
    }];
    
    [_femaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_uploadButton.mas_bottom).offset(10);
        make.left.equalTo(_maleButton.mas_right).offset(10);
        make.height.mas_equalTo(kHeight(30));
        make.width.mas_equalTo(kWidth(70));
    }];
    
    [_chlidButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_uploadButton.mas_bottom).offset(10);
        make.left.equalTo(_femaleButton.mas_right).offset(10);
        make.height.mas_equalTo(kHeight(30));
        make.width.mas_equalTo(kWidth(70));
    }];
    
    [_inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo((_uploadButton.mas_bottom)).offset(100);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(kHeight(150));
    }];
    
    [_jokeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo((_inputTextView.mas_bottom)).offset(20);
        make.left.equalTo(self.view).offset(30);
        make.height.mas_equalTo(kHeight(33));
        make.width.mas_equalTo(kWidth(62));
    }];
    
    [_encourageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo((_inputTextView.mas_bottom)).offset(20);
        make.left.equalTo(_jokeButton.mas_right).offset(10);
        make.height.mas_equalTo(kHeight(33));
        make.width.mas_equalTo(kWidth(89));
    }];
    
    [_greetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo((_inputTextView.mas_bottom)).offset(20);
        make.left.equalTo(_encourageButton.mas_right).offset(10);
        make.height.mas_equalTo(kHeight(33));
        make.width.mas_equalTo(kWidth(62));
    }];
    
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(kHeight(-40));
        make.width.mas_equalTo(kWidth(176));
        make.height.mas_equalTo(kHeight(48));
    }];
    
}

// MARK: - Action

- (void)buttonClick:(UIButton *)sender {
    NSInteger tag = sender.tag - 100;
    NSString *stringValue = [NSString stringWithFormat:@"%ld", (long)tag];
    [SVProgressHUD show];
    kWself
    [self.viewModel getSentences: stringValue completion:^(BOOL isSuccess, NSString * _Nullable message) {
        kSself
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if (isSuccess) {
                sself->_inputTextView.text = message;
            }else {
                [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_request_failed")];
            }
        });
    }];
}

- (void)voiceButton:(UIButton *)sender {
    NSInteger tag = sender.tag - 100;
    if(tag==0){
        _dropMenu.datas = @[@"Davis", @"Guy", @"Eric", @"Nancy", @"Jenny", @"Ana"];
        [_dropMenu closeMenu];
        self.voiceType = @"Davis";
    }else if (tag==1){
        _dropMenu.datas = @[@"Davis", @"Guy", @"Eric"];
        [_dropMenu closeMenu];
        self.voiceType = @"Davis";
    }else if (tag==2){
        _dropMenu.datas = @[@"Nancy", @"Jenny"];
        [_dropMenu closeMenu];
        self.voiceType = @"Nancy";
    }else {
        _dropMenu.datas = @[@"Ana"];
        [_dropMenu closeMenu];
        self.voiceType = @"Ana";
    }
}

-(void)confirmClick{
    if (!_selectImage) {
        NSLog(@"_selectImage");
    }else if (!_inputTextView.text.length){
        NSLog(@"_inputTextView");
    }else {
        [SVProgressHUD show];
        kWself
        [self.viewModel getAIVideo:UIImagePNGRepresentation(_selectImage) text:_inputTextView.text voiceType:self.voiceType completion:^(BOOL isSuccess, NSString * _Nullable message) {
            kSself
            [SVProgressHUD dismiss];
            if (isSuccess) {
                sself->_uuid = message;
                [wself startBackgroundAPI];
                dispatch_async(dispatch_get_main_queue(), ^{
                    kWself
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:SVLocalized(@"video_alert") preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:SVLocalized(@"confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [wself.navigationController popViewControllerAnimated:YES];
                    }];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                });
            }else {
                DebugLog(@"error %@", message);
            }
        }];
    }
}

-(void)startBackgroundAPI {
    kWself
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        wself.backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:wself selector:@selector(callAPI:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:wself.backgroundTimer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] run];
    });
}

-(void)callAPI:(NSTimer *)timer{
    kWself
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        kSself
        [wself.viewModel getVideoProcess:sself->_uuid completion:^(BOOL isSuccess, NSString * _Nullable message) {
            if (isSuccess) {
                [wself.backgroundTimer invalidate];
                wself.backgroundTimer = nil;
                NSLog(@"Timer stopped.");
            }else {
                NSLog(@"%@", message);
            }
        }];
    });
}


-(void)pickImage{
    kWself
    [SVAuthorization cameraAuthorization:^{
        [wself prepareImage:UIImagePickerControllerSourceTypePhotoLibrary];
    } denied:^{
        [wself denied:SVLocalized(@"home_album_not_authorized")];
    }];
}

/// 选择 图片/拍照
- (void)prepareImage:(UIImagePickerControllerSourceType)sourceType {
    SVPickerViewController *viewController = [SVPickerViewController pickerViewControllerWithSourceType:sourceType completion:^(UIImage *image) {
        self->_selectImage = image;
        [self->_uploadButton setBackgroundImage:image forState:UIControlStateNormal];
        [self->_uploadButton setTitle:@"" forState:UIControlStateNormal];
        [self->_uploadButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
    }];
    [self presentViewController:viewController animated:YES completion:nil];
}

/// 相机/相册未授权 提示
- (void)denied:(NSString *)message {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:SVLocalized(@"login_prompt") message:message cancelText:SVLocalized(@"home_cancel") doneText:SVLocalized(@"home_allow_access") cancelAction:nil doneAction:^(UIAlertAction *action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        });
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)closeMenu {
    [_dropMenu closeMenu];
}

// MARK: -Lazy
- (SVAIVideoViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[SVAIVideoViewModel alloc] init];
    }
    
    return _viewModel;
}

// MARK: - dealloc
- (void)dealloc {
    NSLog(@"SVAIVideoViewController dealloc");
}


@end

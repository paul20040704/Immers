//
//  SVAccountViewController.m
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import "SVAccountViewController.h"
#import "SVSheetViewController.h"
#import "SVFieldViewController.h"
#import "SVPasswordViewController.h"
#import "SVLinkViewController.h"
#import "SVPickerViewController.h"
#import "SVLanguageViewController.h"
#import "SVCodeViewController.h"
#import "SVProfileViewModel.h"
#import "SVSectionHeaderView.h"
#import "SVAccountViewCell.h"
#import "SVUserViewModel.h"

@interface SVAccountViewController ()
/// 视图模型
@property (nonatomic, strong) SVUserViewModel *userViewModel;
@end

@implementation SVAccountViewController {
    SVProfileViewModel *_viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SVLocalized(@"profile_settings");
    
    _viewModel = [[SVProfileViewModel alloc] init];
    [self prepareSubviews];
}

// MARK: - Action
/// 更换头像
- (void)avaratClick:(SVAccountItem *)item {
    kWself
    SVSheetItem *item0 = [SVSheetItem item:SVLocalized(@"home_from_album") callback:^{
        [SVAuthorization cameraAuthorization:^{
            [wself prepareImage:UIImagePickerControllerSourceTypePhotoLibrary];
        } denied:^{
            [wself denied:SVLocalized(@"home_album_not_authorized")];
        }];
    }];
    SVSheetItem *item1 = [SVSheetItem item:SVLocalized(@"home_camera") callback:^{
        [SVAuthorization cameraAuthorization:^{
            [wself prepareImage:UIImagePickerControllerSourceTypeCamera];
        } denied:^{
            [wself denied:SVLocalized(@"home_camera_not_authorized")];
        }];
    }];
    SVSheetViewController *viewController = [SVSheetViewController sheetController:@[item0, item1]];
    [self presentViewController:viewController animated:YES completion:nil];
}

/// 编辑昵称
- (void)nameClick:(SVAccountItem *)item {
    kWself
    SVFieldViewController *viewController = [SVFieldViewController fieldControllerWithTitle:SVLocalized(@"profile_user_name") placeholder:item.text cancelText:SVLocalized(@"home_cancel") confirmText:SVLocalized(@"home_confirm")];
    viewController.showClose = YES;
    viewController.backgroundColor = [UIColor colorWithHex:0xbbbbbb];
    viewController.titleTextColor = [UIColor whiteColor];
    viewController.confirmTextColor = [UIColor whiteColor];
    viewController.confirmBackgroundColor = [UIColor grassColor3];
    viewController.cancelTextColor = [UIColor grayColor7];
    viewController.maxLength = kNameMaxLength;
    [viewController handler:nil confirmAction:^(NSString *text) {
        [wself updateInfo:@{ @"userName" : text }];
    }];
    [self presentViewController:viewController animated:YES completion:nil];
}

/// 编辑性别
- (void)genderClick:(SVAccountItem *)item {
    kWself
    SVSheetItem *item0 = [SVSheetItem item:SVLocalized(@"profile_male") callback:^{
        [wself updateInfo:@{ @"userSex" : @"1" }];
    }];
    SVSheetItem *item1 = [SVSheetItem item:SVLocalized(@"profile_female") callback:^{
        [wself updateInfo:@{ @"userSex" : @"0" }];
    }];
    SVSheetViewController *viewController = [SVSheetViewController sheetController:@[item0, item1]];
    [self presentViewController:viewController animated:YES completion:nil];
}

/// 语言设置
- (void)languageClick {
    SVLanguageViewController *viewController = [[SVLanguageViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

/// 修改密码
- (void)passwordClick:(SVAccountItem *)item {
    SVPasswordViewController *viewController = [[SVPasswordViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

/// 绑定帐号
- (void)thirdClick:(SVAccountItem *)item {
    SVUserAccount *userAccount = [SVUserAccount sharedAccount];
    SVLinkViewController *viewController = [SVLinkViewController viewControllerWithType:userAccount.bindWx ? SVLinkTypeBind : SVLinkTypeUnbind];
    [self.navigationController pushViewController:viewController animated:YES];
    kWself
    viewController.bindCallback = ^{
        kSself
        sself->_viewModel.sections = nil;
        [sself.tableView reloadData];
    };
}

/// 注销帐号提示
- (void)cancelAccount:(SVAccountItem *)item {
    kWself
    SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:SVLocalized(@"profile_validation_method") message:nil cancelText:SVLocalized(@"profile_phone_verification") confirmText:SVLocalized(@"profile_emial_verification")];
    viewController.showClose = YES;
    viewController.backgroundColor = [UIColor colorWithHex:0xbbbbbb];
    viewController.titleTextColor = [UIColor whiteColor];
    [viewController handler:^{
        [wself removeAccount:[SVUserAccount sharedAccount].phone];
    } confirmAction:^{
        [wself removeAccount:[SVUserAccount sharedAccount].email];
    }];
    [self presentViewController:viewController animated:YES completion:nil];
}

/// 删除帐号
- (void)removeAccount:(NSString *)account {
    if (nil == account || account.length <= 0) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"home_incorrect_account")];
        return;
    }
    SVCodeViewController *viewController = [SVCodeViewController viewControllerWithType:SVCodeTypeRemoveAccount];
    viewController.parameters = @{ @"account" : account };
    [self.navigationController pushViewController:viewController animated:YES];
}

/// 退出登录
- (void)logoutClick:(UIButton *)button {
    button.selected = YES;
    kWself
    SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:SVLocalized(@"profile_sure_exit") message:nil cancelText:SVLocalized(@"home_confirm") confirmText:SVLocalized(@"home_cancel")];
    viewController.backgroundColor = [UIColor colorWithHex:0xbbbbbb];
    viewController.titleTextColor = [UIColor whiteColor];
    [viewController handler:^{
        [wself logoutRequest];
        button.selected = NO;
    } confirmAction:^{
        button.selected = NO;
    }];
    [self presentViewController:viewController animated:YES completion:nil];
}

/// 选择 图片/拍照
- (void)prepareImage:(UIImagePickerControllerSourceType)sourceType {
    kWself
    SVPickerViewController *viewController = [SVPickerViewController pickerViewControllerWithSourceType:sourceType completion:^(UIImage * image) {
        [wself updateAvarat:image];
    }];
    viewController.allowsEditing = YES;
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

// MARK: - Request
- (void)logoutRequest {
    kShowLoading
    [self.userViewModel logoutCompletion:^(BOOL isSuccess, NSString *message) {
        kDismissLoading
        if (isSuccess) {
            self->_viewModel.sections = nil;
            [self.tableView reloadData];
            [[SVMQTTManager sharedManager] close];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

/// 更新用户头像
- (void)updateAvarat:(UIImage *)avarat {
    kShowLoading
    [self.userViewModel updateAvarat:avarat completion:^(BOOL isSuccess, NSString *message) {
        kDismissLoading
        if (isSuccess) {
            self->_viewModel.sections = nil;
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

/// 更新用户信息
- (void)updateInfo:(NSDictionary *)parameters {
    kShowLoading
    [self.userViewModel update:parameters completion:^(BOOL isSuccess, NSString *message) {
        kDismissLoading
        if (isSuccess) {
            self->_viewModel.sections = nil;
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

// MARK: - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _viewModel.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _viewModel.sections[section].items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SVAccountItem *item = _viewModel.sections[indexPath.section].items[indexPath.row];
    SVAccountViewCell *accountCell;
    if (item.text) {
        accountCell = [SVTextViewCell cellWithTableView:tableView];
        
    } else {
        accountCell = [SVIconViewCell cellWithTableView:tableView];
    }
    accountCell.item = item;
    return accountCell;
}

// MARK: - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SVAccountItem *item = _viewModel.sections[indexPath.section].items[indexPath.row];
    if (!item.enabled) { return; }
    SEL selector = NSSelectorFromString(item.sel);
    IMP imp = [self methodForSelector:selector];
    void (*msgSendPointer)(id, SEL, SVAccountItem *) = (void *)imp;
    msgSendPointer(self, selector, item);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SVSectionHeaderView *headerView = [SVSectionHeaderView viewWithTableView:tableView];
    headerView.title = _viewModel.sections[section].title;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kHeight(38);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (0 == section) {
        return kHeight(10);
    }
    return 0.01;
}

/// 子视图
- (void)prepareSubviews {
    // 表格
    self.style = UITableViewStyleGrouped;
    [super prepareTableView];
    self.tableView.rowHeight = kHeight(50);
    self.tableView.separatorColor = [UIColor colorWithHex:0x000000 alpha:0.1];
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.backgroundColor = [UIColor whiteColor];
    UIEdgeInsets inset = self.tableView.contentInset;
    if ([[UIDevice currentDevice] userInterfaceIdiom]  == UIUserInterfaceIdiomPad) {
        inset.bottom += kHeight(100);
    } else {
        inset.top += kHeight(10);
    }
    self.tableView.contentInset = inset;
    //退出按钮
    UIButton *logoutButton = [UIButton buttonWithTitle:SVLocalized(@"profile_exit") selectedTitle:SVLocalized(@"profile_exit") normalColor:[UIColor grayColor8] selectedColor:[UIColor whiteColor] font:kSystemFont(14)];
    // 设置背景图片
    [logoutButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutButton setBackgroundColor:[UIColor grayColor8] forState:UIControlStateSelected];
    // 样式
    logoutButton.layer.borderWidth = 1;
    logoutButton.layer.borderColor = [UIColor grayColor8].CGColor;
    [logoutButton corner];
    
    // 添加控件
    [self.view addSubview:logoutButton];
    
    // 事件
    [logoutButton addTarget:self action:@selector(logoutClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 约束
    [logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(40));
        make.right.equalTo(self.view).offset(kWidth(-40));
        make.height.mas_equalTo(kHeight(48));
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(kHeight(-40));
    }];
}

// MARK: - lazy
- (SVUserViewModel *)userViewModel {
    if (!_userViewModel) {
        _userViewModel = [[SVUserViewModel alloc] init];
    }
    return _userViewModel;
}


@end

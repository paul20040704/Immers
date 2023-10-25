//
//  SVPickerViewController.m
//  Immers
//
//  Created by Paul on 2023/7/27.
//

#import "SVChooseViewController.h"
#import "SVGlobalMacro.h"

@interface SVChooseViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SVChooseViewController{
    UIView *_titleview;
    UILabel *_titleLabel;
    UIButton *_cancelButton;
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self prepareSubViews];
}

- (void)prepareSubViews {
    _titleview = [[UIView alloc]init];
    _titleview.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = SVLocalized(@"select_code");
    _titleLabel.textColor = [UIColor blackColor];
    
    _cancelButton = [UIButton buttonWithImageName:@"home_file_close"];
    [_cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [[UITableView alloc]init];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50.0;
    
    [_titleview addSubview: _titleLabel];
    [_titleview addSubview: _cancelButton];
    [self.view addSubview: _titleview];
    [self.view addSubview: _tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(kHeight(360));
    }];
    
    [_titleview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(_tableView.mas_top);
        make.height.mas_equalTo(kHeight(50));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleview).offset(kWidth(20));
        make.centerY.equalTo(_titleview.mas_centerY);
    }];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_titleview).offset(kWidth(-20));
        make.centerY.equalTo(_titleview.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
}

// MARK: - Action
-(void)cancelClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.codeModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // 從 stringArray 中取出對應位置的字符串，並設置到 cell 的標籤上
    SVCodeModel *model = [self.codeModelArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.countryID;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // indexPath.row 代表用戶點擊的行數
    SVCodeModel *model = [self.codeModelArray objectAtIndex:indexPath.row];
    if (self.codeCallback) {
        self.codeCallback(model);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end

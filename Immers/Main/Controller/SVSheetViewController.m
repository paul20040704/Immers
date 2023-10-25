//
//  SVSheetViewController.m
//  Immers
//
//  Created by developer on 2022/5/21.
//

#import "SVSheetViewController.h"
#import "SVSheetViewCell.h"

// MARK: - Model
@implementation SVSheetItem

+ (instancetype)item:(nullable NSString *)text callback:(void(^)(void))callback {
    return [self item:nil text:text callback:callback];
}

+ (instancetype)item:(nullable NSString *)icon text:(nullable NSString *)text callback:(void(^)(void))callback {
    return [self item:icon text:text textColor:nil selectedColor:nil selected:NO callback:callback];
}

+ (instancetype)item:(nullable NSString *)text textColor:(nullable UIColor *)textColor callback:(void(^)(void))callback {
    return [self item:nil text:text textColor:textColor selectedColor:nil selected:NO callback:callback];
}

+ (instancetype)item:(nullable NSString *)icon text:(nullable NSString *)text textColor:(nullable UIColor *)textColor selectedColor:(nullable UIColor *)selectedColor selected:(BOOL)selected callback:(void(^)(void))callback {
    SVSheetItem *item = [[SVSheetItem alloc] init];
    item.text = text;
    item.icon = icon;
    item.textColor = textColor;
    item.selectedColor = selectedColor;
    item.selected = selected;
    item.selectedCallback = callback;
    return item;
}

@end

// MARK: - ViewController
@interface SVSheetViewController ()

@end

@implementation SVSheetViewController {
    NSArray<SVSheetItem *> *_items;
}

+ (instancetype)sheetController:(NSArray<SVSheetItem *> *)items {
    SVSheetViewController *viewController = [[SVSheetViewController alloc] init];
    viewController->_items = items;
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.hidenNav = YES;
    self.view.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.0];
    [self prepareSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [[self.view viewWithTag:100] topCorner];
}


// MARK: - Action
- (void)dismissClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// MARK: - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SVSheetViewCell *sheetCell = [SVSheetViewCell cellWithTableView:tableView];
    sheetCell.item = _items[indexPath.row];
    return sheetCell;
}

// MARK: - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_items[indexPath.row].selectedCallback) {
        [self dismissClick];
        _items[indexPath.row].selectedCallback();
    }
}

/// 子视图
- (void)prepareSubviews {
    UIButton *dismissButton = [[UIButton alloc] init];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *wrapperView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    wrapperView.tag = 100;
    
    UITableView *tableView = [self prepareTableItems];
    
    [self.view addSubview:dismissButton];
    [self.view addSubview:wrapperView];
    [self.view addSubview:tableView];
    
    // 事件
    [dismissButton addTarget:self action:@selector(dismissClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 约束
    [dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    CGFloat height;
    if (_showCount>0) {
        height = kHeight(88) * MIN(_items.count, _showCount+0.5) + kSafeAreaBottom;
    }else{
        height = kHeight(88) * _items.count + kSafeAreaBottom;
    }

    [wrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(height-0.5);
    }];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(wrapperView).insets(UIEdgeInsetsMake(0, 0, kSafeAreaBottom, 0));
    }];
}

- (UITableView *)prepareTableItems {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    tableView.rowHeight = kHeight(88);
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollEnabled = YES;
    tableView.bounces = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorColor = [UIColor colorWithHex:0xffffff alpha:0.6];
    tableView.separatorInset = UIEdgeInsetsZero;
    
    return tableView;
}

@end

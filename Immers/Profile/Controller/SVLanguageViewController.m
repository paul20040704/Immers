//
//  SVLanguageViewController.m
//  Immers
//
//  Created by developer on 2022/6/1.
//

#import "SVLanguageViewController.h"
#import "SVAccountViewCell.h"
#import "SVAccountItem.h"
#import "SVLanguage.h"

@interface SVLanguageViewController ()

@property (nonatomic, strong) NSArray<SVAccountItem *> *items;

@end

@implementation SVLanguageViewController {
    NSString *_local;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SVLocalized(@"profile_language");
    
    _local = [SVLanguage local];
    [self prepareSubviews];
    [self prepareItems];
}

// MARK: - Action
- (void)doneClick {
    if ([_local isEqualToString:[SVLanguage local]] ) { return; }
    [SVLanguage saveLanguage:_local];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchLanguageNotification object:nil];
}

// MARK: - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SVLanguageViewCell *languageCell = [SVLanguageViewCell cellWithTableView:tableView];
    languageCell.item = self.items[indexPath.row];
    return languageCell;
}

// MARK: - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _local = self.items[indexPath.row].icon;
    [self updateData];
}

/// 准备视图
- (void)prepareSubviews {
    [super prepareTableView];
    self.tableView.rowHeight = kHeight(50);
    self.tableView.separatorColor = [UIColor colorWithHex:0xf3f3f3];
}

- (void)prepareItems {
    UIButton *doneButton = [UIButton buttonWithTitle:SVLocalized(@"profile_done") titleColor:[UIColor grayColor7] font:kSystemFont(14)];
    [doneButton sizeToFit];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kHeight(30));
    }];
    [doneButton addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
}

- (void)updateData {
    for (SVAccountItem *item in self.items) {
        item.text = [item.icon isEqualToString:_local] ? @"" : nil;
    }
    [self.tableView reloadData];
}

// MARK: - lazy
- (NSArray<SVAccountItem *> *)items {
    if (!_items) {        
        _items = [NSArray yy_modelArrayWithClass:[SVAccountItem class] json:[SVLanguage items]];
        [self updateData];
    }
    return _items;
}

@end

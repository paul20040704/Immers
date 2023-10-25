//
//  SVBaseViewController.m
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import "SVBaseViewController.h"

#import "SVBaseViewController.h"

#import "SVAICell.h"
// MARK: - NavigationBar
@implementation SVNavigationBar

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *itemView in self.subviews) {
        NSString *className = NSStringFromClass(itemView.classForCoder);
        if ([className containsString:@"Background"]) {
            itemView.frame = self.bounds;
            
        } else if ([className containsString:@"ContentView"]) {
            CGRect frame = itemView.frame;
            frame.origin.y = (self.bounds.size.height - 44);
            frame.size.height = (self.bounds.size.height - frame.origin.y);
            itemView.frame = frame;
        }
    }
}

@end

// MARK: - ViewController
@interface SVBaseViewController ()

@property (nonatomic, strong) SVNavigationBar *navigationBar;

@end

@implementation SVBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.style = UITableViewStylePlain;
    
    [self prepareNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationBar.hidden = self.hidenNav;
}

// MARK: - Settet
- (void)setTitle:(NSString *)title {
    self.navItem.title = title;
}

- (void)setLight:(BOOL)light {
    _light = light;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setTranslucent:(BOOL)translucent {
    _translucent = translucent;
    self.navigationBar.translucent = translucent;
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _navigationBar.titleTextAttributes = @{ NSFontAttributeName : kBoldFont(17), NSForegroundColorAttributeName : titleColor };
    _navigationBar.tintColor = titleColor;
}

- (void)setBarTintColor:(UIColor *)barTintColor {
    _barTintColor = barTintColor;
    _navigationBar.barTintColor = barTintColor;
}

- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)flag completion:(void (^)(void))completion {
    
    viewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [super presentViewController:viewController animated:flag completion:completion];
}

// MARK: - 准备视图
- (void)prepareNavigationBar {
    self.navigationBar.items = @[self.navItem];
    [self.view addSubview:self.navigationBar];
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kNavBarHeight);
    }];
}

- (void)prepareTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.style];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    CGFloat bottomInset = (self.navigationController.viewControllers.count > 1) ? 0 : kTabBarHeight;
    _tableView.contentInset = UIEdgeInsetsMake(kNavBarHeight, 0, bottomInset, 0);
    
    [self.view insertSubview:_tableView belowSubview:self.navigationBar];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)prepareCollectionViewForRegisterClass:(Class)cellClass layout:(UICollectionViewLayout *)layout {
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.emptyDataSetSource = self;
    _collectionView.emptyDataSetDelegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    [_collectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
    
    _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    CGFloat bottomInset = (self.navigationController.viewControllers.count > 1) ? 0 : kTabBarHeight;
    _collectionView.contentInset = UIEdgeInsetsMake(kNavBarHeight, 0, bottomInset, 0);
    
    [self.view insertSubview:_collectionView belowSubview:self.navigationBar];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([cellClass isSubclassOfClass:[SVAICell class]]){
            make.top.equalTo(self.view.mas_top).offset(kHeight(90));
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }else {
            make.edges.equalTo(self.view);
        }
    }];
}

- (void)addSubview:(UIView *)subview {
    [self.view insertSubview:subview belowSubview:self.navigationBar];
}

/// 顶层控制器
- (UIViewController *)topViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self topViewControllerFrom:rootViewController];
}

- (UIViewController *)topViewControllerFrom:(UIViewController *)rootViewController {
    UIViewController *currentViewController;
    if ([rootViewController presentedViewController]) {
        // 视图是被presented出来的
        rootViewController = [rootViewController presentedViewController];
    }

    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentViewController = [self topViewControllerFrom:[(UITabBarController *)rootViewController selectedViewController]];
        
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentViewController = [self topViewControllerFrom:[(UINavigationController *)rootViewController visibleViewController]];
    } else {
        // 根视图为非导航类
        currentViewController = rootViewController;
    }
    
    return currentViewController;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _light ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

// MARK: - Lazy
- (SVNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[SVNavigationBar alloc] init];
        _navigationBar.barTintColor = [UIColor whiteColor];
        _navigationBar.titleTextAttributes = @{ NSFontAttributeName : kBoldFont(17), NSForegroundColorAttributeName : [UIColor textColor] };
        _navigationBar.tintColor = [UIColor textColor];
        _navigationBar.shadowImage = [[UIImage alloc] init];
        _navigationBar.translucent = NO;
    }
    return _navigationBar;
}

- (UINavigationItem *)navItem {
    if (!_navItem) {
        _navItem = [[UINavigationItem alloc] init];
    }
    return _navItem;
}

// MARK: - UITableViewDataSource 数据源方法 为了消除警告
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

// MARK: - UICollectionViewDataSource 数据源方法 为了消除警告
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

// MARK: -
- (void)dealloc {
    [SVProgressHUD dismiss];
    DebugLog(@"%@ --> dealloc", NSStringFromClass([self class]));
}

@end

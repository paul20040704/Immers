//
//  SVBaseViewController.h
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import <UIKit/UIKit.h>
#import "SVGlobalMacro.h"

NS_ASSUME_NONNULL_BEGIN

// MARK: - navigationBar
@interface SVNavigationBar : UINavigationBar

@end

// MARK: - ViewController
@interface SVBaseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/// 表格视图
@property (nonatomic, strong, readonly) UITableView *tableView;

/// 单元格视图
@property (nonatomic, strong, readonly) UICollectionView *collectionView;

/// 表格视图样式 默认 UITableViewStylePlain
@property (nonatomic, assign) UITableViewStyle style;

/// 自定义导航条目
@property (nonatomic, strong) UINavigationItem *navItem;

/// 是否隐藏导航栏
@property (nonatomic, assign) BOOL hidenNav;

/// 状态栏颜色
@property (nonatomic, assign) BOOL light;

/// 导航栏透明度
@property (nonatomic, assign) BOOL translucent;

/// 标题字体颜色
@property (nonatomic, strong) UIColor *titleColor;

/// 导航栏颜色
@property (nonatomic, strong) UIColor *barTintColor;

/// 准备表格视图
- (void)prepareTableView;

/// 准备单元格视图
/// @param cellClass 注册Cell
/// @param layout 布局
- (void)prepareCollectionViewForRegisterClass:(Class)cellClass layout:(UICollectionViewLayout *)layout;

/// 添加视图 在导航栏下面
- (void)addSubview:(UIView *)subview;

/// 顶层控制器
- (UIViewController *)topViewController;

@end

NS_ASSUME_NONNULL_END

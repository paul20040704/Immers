//
//  SVHeaderFooterView.h
//  Immers
//
//  Created by developer on 2022/5/19.
//

#import <UIKit/UIKit.h>
#import "SVGlobalMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVHeaderFooterView : UITableViewHeaderFooterView

/// 创建 HeaderFooterView
/// @param tableView 表格视图
+ (instancetype)viewWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END

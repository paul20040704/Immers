//
//  MJRefreshFooter+Extension.m
//  Immers
//
//  Created by ssv on 2022/11/8.
//

#import "MJRefreshFooter+Extension.h"

@implementation MJRefreshFooter (Extension)
+ (MJRefreshBackStateFooter * )getNormalRefreshFooterWithRefreshingBlock:(MJRefreshComponentAction)refreshingBlock{
    MJRefreshBackStateFooter *footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:refreshingBlock];
    [footer setTitle:SVLocalized(@"home_no_more_data") forState:MJRefreshStateNoMoreData];
    [footer setTitle:SVLocalized(@"home_pull_up") forState:MJRefreshStateIdle];
    [footer setTitle:SVLocalized(@"home_pull_release_more") forState:MJRefreshStatePulling];
    [footer setTitle:SVLocalized(@"home_pull_up_loading") forState:MJRefreshStateRefreshing];
    return footer;
}
@end

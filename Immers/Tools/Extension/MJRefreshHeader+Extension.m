//
//  MJRefreshHeader+Extension.m
//  Immers
//
//  Created by ssv on 2022/11/7.
//

#import "MJRefreshHeader+Extension.h"

@implementation MJRefreshHeader (Extension)

+ (MJRefreshNormalHeader * )getNormalRefreshHeaderWithRefreshingBlock:(MJRefreshComponentAction)refreshingBlock{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
    [header setTitle:SVLocalized(@"home_pull_more") forState:MJRefreshStateIdle];
    [header setTitle:SVLocalized(@"home_pelease_more") forState:MJRefreshStatePulling];
    [header setTitle:SVLocalized(@"home_refreshing") forState:MJRefreshStateRefreshing];
    [header modifyLastUpdatedTimeText:^NSString *(NSDate *lastUpdatedTime) {
        return [NSString stringWithFormat:SVLocalized(@"home_last_update"), nil == lastUpdatedTime ? @"" : lastUpdatedTime.timeDescription ];
    }];
    return header;
}


@end

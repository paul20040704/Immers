//
//  SVResourceViewModel.m
//  Immers
//
//  Created by ssv on 2022/11/8.
//

#import "SVResourceViewModel.h"
#import "SVDeviceService.h"
@implementation SVResourceViewModel
{
    NSInteger _page;//当前页码
    NSInteger _pageSize;//每页数量
    NSURLSessionDataTask *_resourcesTask;//获取资源接口task
}

- (instancetype )init {
    if (self == [super init]){
        _page = 1;
        _pageSize = 20;
    }
    return self;
}


/// 获取资源列表
/// @param reload 是否刷新
/// @param completion 完成回调
- (void)resources:(BOOL )reload completion:(SVSuccessCompletion)completion{
    if (_resourcesTask&&_resourcesTask.state == NSURLSessionTaskStateRunning) {
        [_resourcesTask cancel];
    }
    reload?_page=1:_page++;
    NSDictionary *parameters = @{@"type":@(_resourceType),@"startPage":@(_page),@"pageSize":@(_pageSize)};
    kWself
    _resourcesTask = [SVDeviceService getImageResource:parameters completion:^(NSInteger errorCode, NSDictionary * _Nonnull info) {
        kSself
        if (reload) {
            [sself.resources removeAllObjects];
        }
        if (0 == errorCode) {
            int totalPage = ((NSNumber *)[info objectForKey:@"totalPage"]).intValue;
            wself.noMoreData = totalPage<=sself->_page;
            [wself.resources addObjectsFromArray:[NSArray yy_modelArrayWithClass:[SVResourceModel class] json:[info objectForKey:@"resourceImageResps"]]];
            completion(YES, nil);
        } else {
            if (errorCode!=-999) {
                if(sself->_page>1) sself->_page--;
                completion(NO, info[KErrorMsg]);
            }
        }
    }];
    
}

/// 下载资源
/// @param paramters 请求参数
/// @param completion 完成回调
- (void)downloadResource:(NSDictionary *)paramters completion:(SVSuccessCompletion)completion{
    NSMutableArray *mArray = @[].mutableCopy;
    for (SVResourceModel *model in self.selectResources) {
        [mArray addObject:[model yy_modelToJSONObject]];
    }
    NSMutableDictionary *mParamters = paramters.mutableCopy;
    [mParamters setValue:mArray forKey:@"imageResps"];
    [SVDeviceService downloadResource:mParamters completion:^(NSInteger errorCode, NSDictionary * _Nonnull info) {
        if (0 == errorCode) {
            completion(YES, nil);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}


// MARK: - Lazy
- (NSMutableArray<SVResourceModel *> *)resources {
    if(!_resources){
        _resources = @[].mutableCopy;
    }
    return _resources;
}

- (NSMutableArray <SVResourceModel *> *)selectResources {
    if(!_selectResources){
        _selectResources = @[].mutableCopy;
    }
    return  _selectResources;
}
@end

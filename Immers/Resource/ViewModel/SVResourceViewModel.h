//
//  SVResourceViewModel.h
//  Immers
//
//  Created by ssv on 2022/11/8.
//

#import "SVBaseViewModel.h"
#import "SVResourceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVResourceViewModel : SVBaseViewModel
@property (nonatomic,strong)NSMutableArray<SVResourceModel *> *resources;//资源列表
@property (nonatomic,strong)NSMutableArray<SVResourceModel *> *selectResources;//选中的资源
@property (nonatomic,assign)NSInteger resourceType;//0 图片，1 视频
@property (nonatomic,assign)BOOL noMoreData;//数据是否已经加载完成(底部加载更多是否开启)
/// 获取资源列表
/// @param reload 是否刷新
/// @param completion 完成回调
- (void)resources:(BOOL )reload completion:(SVSuccessCompletion)completion;

/// 下载资源
/// @param paramters 请求参数
/// @param completion 完成回调
- (void)downloadResource:(NSDictionary *)paramters completion:(SVSuccessCompletion)completion;
@end

NS_ASSUME_NONNULL_END

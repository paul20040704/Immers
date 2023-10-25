//
//  SVAIViewModel.h
//  Immers
//
//  Created by Paul on 2023/7/21.
//

#import "SVBaseViewModel.h"
#import "SVAIModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVAIViewModel : SVBaseViewModel
@property (nonatomic,strong)NSMutableArray<SVAIModel *> *resources;//资源列表
@property (nonatomic,strong)NSMutableArray<SVAIModel *> *selectResources;//选中的资源

//取得AI圖片
- (void)getAIResources:(NSString *)paramter completion:(SVSuccessCompletion)completion;

@end

NS_ASSUME_NONNULL_END

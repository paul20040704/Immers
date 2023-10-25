//
//  SVPetViewModel.h
//  Immers
//
//  Created by ssv on 2022/11/9.
//

#import "SVBaseViewModel.h"
#import "SVPetModel.h"
#import "SVResoruceGroupTask.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVPetViewModel : SVBaseViewModel
@property (nonatomic, copy)NSString *deviceId;
@property (nonatomic,strong)NSMutableArray <SVPetModel *> *pets;//宠物数组
@property (nonatomic,strong)SVPetInfoModel *petInfo;//单个宠物详细信息
@property (nonatomic,strong)NSMutableArray *actionSizes;//所有动作大小

@property (nonatomic,assign)BOOL hadLoadProgress;
@property (nonatomic,strong)NSMutableDictionary *petProgress;//宠物下载进度


/// 获取所有宠物
/// @param completion 完成回调
- (void)allPets:(SVSuccessCompletion)completion;

/// 获取资源组(宠物等)任务数量和任务列表(MQTT)
/// @param completion 完成回调
- (void)petsTaskList:(SVSuccessCompletion)completion;

/// 资源组相关MQTT回调数据
/// @param completion 消息回调
- (void)requestMessage:(SVResultCompletion)completion;

/// 下载/领养宠物
/// @param paramters 请求参数
/// @param completion 完成回调
- (void)downloadPet:(NSDictionary *)paramters completion:(SVSuccessCompletion)completion;

/// 获取宠物详细信息
/// @param paramters 请求参数
/// @param completion 完成回调
- (void)petInfo:(NSDictionary *)paramters completion:(SVSuccessCompletion)completion;

/// 弃养宠物
/// @param paramters 请求参数
/// @param completion 完成回调
- (void)abandonPet:(NSDictionary *)paramters completion:(SVSuccessCompletion)completion;

/// 重新领养宠物
/// @param paramters 请求参数
/// @param completion 完成回调
- (void)reDownloadPet:(NSDictionary *)paramters completion:(SVSuccessCompletion)completion;
@end

NS_ASSUME_NONNULL_END

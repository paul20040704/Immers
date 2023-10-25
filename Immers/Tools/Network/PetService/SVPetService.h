//
//  SVPetService.h
//  Immers
//
//  Created by ssv on 2022/11/9.
//

#import "SVNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVPetService : NSObject
/// 下载宠物
/// @param parameters 参数
/// @param completion 完成回调
+ (void)downloadPet:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;
/// 获取全部宠物
/// @param parameters 参数
/// @param completion 完成回调
+ (void)getAllPet:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;
/// 获取宠物详细信息
/// @param parameters 参数
/// @param completion 完成回调
+ (void)getPetInfo:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;
/// 弃养宠物
/// @param parameters 参数
/// @param completion 完成回调
+ (void)abandonPet:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 重新领养宠物
/// @param parameters 参数
/// @param completion 完成回调
+ (void)reDownloadPet:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;
@end

NS_ASSUME_NONNULL_END

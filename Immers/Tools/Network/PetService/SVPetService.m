//
//  SVPetService.m
//  Immers
//
//  Created by ssv on 2022/11/9.
//

#import "SVPetService.h"

@implementation SVPetService

/// 下载宠物
+ (void)downloadPet:(NSDictionary *)parameters completion:(SVRequestCompletion)completion{
    [[SVNetworkManager sharedManager] POST:@"userPet/downloadPet" parameters:parameters completion:completion];
}

/// 获取全部宠物
+ (void)getAllPet:(NSDictionary *)parameters completion:(SVRequestCompletion)completion{
    [[SVNetworkManager sharedManager] POST:@"userPet/getAllPet" parameters:parameters completion:completion];
}

/// 获取宠物详细信息
+ (void)getPetInfo:(NSDictionary *)parameters completion:(SVRequestCompletion)completion{
    [[SVNetworkManager sharedManager] POST:@"userPet/getPetInfo" parameters:parameters completion:completion];
}

/// 弃养宠物
+ (void)abandonPet:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"userPet/surrenderPet" parameters:parameters completion:completion];
}

/// 重新领养宠物
+ (void)reDownloadPet:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"userPet/reDownload" parameters:parameters completion:completion];
}
@end

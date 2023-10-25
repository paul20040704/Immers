//
//  SVPetViewModel.m
//  Immers
//
//  Created by ssv on 2022/11/9.
//

#import "SVPetViewModel.h"
#import "SVPetService.h"
@implementation SVPetViewModel
/// 获取所有宠物
- (void)allPets:(SVSuccessCompletion)completion{
    _hadLoadProgress = NO;
    kWself
    [SVPetService getAllPet:@{@"framePhotoId":_deviceId?:@""} completion:^(NSInteger errorCode, NSDictionary * _Nonnull info) {
        if (0 == errorCode) {
            if([info isKindOfClass:[NSArray class]]){
                wself.pets = [NSArray yy_modelArrayWithClass:[SVPetModel class] json:info].mutableCopy;
                
            }
            completion(YES, nil);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 获取资源组(宠物等)任务数量和任务列表(MQTT)
/// @param completion 完成回调
- (void)petsTaskList:(SVSuccessCompletion)completion {
    [[SVMQTTManager sharedManager] sendControl:@{kCmd:@(SVMQTTCmdEventGetResourceGroupTaskList),kFromId:_deviceId?:@""} handler:^(NSError * _Nonnull error) {
        if (nil == error) {
            completion(YES,nil);
        }
    }];
}

/// 资源组相关MQTT回调数据
/// @param completion 消息回调
- (void)requestMessage:(SVResultCompletion)completion {
    kWself
    [[SVMQTTManager sharedManager] receiveMessage:[self hash] handler:^(NSDictionary * _Nonnull message) {
        NSInteger cmd = [message[kCmd] integerValue];
        NSString *fromId = message[kFromId];
        if (![fromId isEqualToString:wself.deviceId]) {
            return;
        }
        if (cmd == SVMQTTCmdEventResourceGroupTaskList) {
            wself.hadLoadProgress = YES;
            [wself.petProgress removeAllObjects];
            NSDictionary <NSString *, id> *ext = message[kExt];
            NSArray *list = [NSArray yy_modelArrayWithClass:SVResoruceGroupTask.class json:ext[kList]];
            for (SVResoruceGroupTask *task in list) {
                [wself.petProgress setValue:@(task.percent) forKey:[fromId stringByAppendingString:task.resGroupId]];
            }
            completion(YES,nil,@{kCmd:@(SVMQTTCmdEventGetResourceGroupTaskList)});
        } else if (cmd == SVMQTTCmdEventResourceGroupProgress) {
            NSDictionary <NSString *, id> *ext = message[kExt];
            SVResoruceGroupTask *task = [SVResoruceGroupTask yy_modelWithJSON:ext];
            NSNumber *oldP = [wself.petProgress objectForKey:[fromId stringByAppendingString:task.resGroupId]];
            NSInteger index = -1;
            if (oldP.intValue!=task.percent) {
                for (int i=0; i<wself.pets.count; i++) {
                    SVPetModel *model = wself.pets[i];
                    if ([model.petId isEqualToString:[fromId stringByAppendingString:task.resGroupId]]) {
                        index = i;
                    }
                }
                [wself.petProgress setValue:@(task.percent) forKey:[fromId stringByAppendingString:task.resGroupId]];
                completion(YES,nil,@{kCmd:@(SVMQTTCmdEventGetResourceGroupTaskList),@"resGroupId":@(index)});
            }

        } else if (cmd == SVMQTTCmdEventDeviceInfo){
            NSDictionary <NSString *, id> *ext = message[kExt];
            completion(YES,nil,@{kCmd:@(SVMQTTCmdEventDeviceInfo),kFromId:fromId?:@"",@"versionNum":[NSString stringWithFormat:@"%@",ext[@"versionNum"]]});
        }
    }];
}


/// 下载/领养宠物
- (void)downloadPet:(NSDictionary *)paramters completion:(SVSuccessCompletion)completion{
    [SVPetService downloadPet:paramters completion:^(NSInteger errorCode, NSDictionary * _Nonnull info) {
        if (0 == errorCode) {
            completion(YES, nil);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 获取宠物详细信息
- (void)petInfo:(NSDictionary *)paramters completion:(SVSuccessCompletion)completion{
    kWself
    NSString *petId = [paramters objectForKey:@"petId"];
    [SVPetService getPetInfo:paramters completion:^(NSInteger errorCode, NSDictionary * _Nonnull info) {
        if (0 == errorCode) {
            [wself.petInfo yy_modelSetWithDictionary:info];
            [wself.actionSizes removeAllObjects];
            for (SVPetActionModel *model in wself.petInfo.petInfoVos) {
                [wself.actionSizes addObject:@{@"resId":model.petActionId?:@"",@"fileSize":model.petActionSize?:@(0)}];
            }
            if (wself.petInfo.petInfoVos.count>4) {
                wself.petInfo.petInfoVos  = [wself.petInfo.petInfoVos subarrayWithRange:NSMakeRange(1, wself.petInfo.petInfoVos.count-1)];
            }
            wself.petInfo.petId = petId;
            completion(YES, nil);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 弃养宠物
- (void)abandonPet:(NSDictionary *)paramters completion:(SVSuccessCompletion)completion {
    [SVPetService abandonPet:paramters completion:^(NSInteger errorCode, NSDictionary * _Nonnull info) {
        if (0 == errorCode) {
            completion(YES, nil);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 重新领养宠物
/// @param paramters 请求参数
/// @param completion 完成回调
- (void)reDownloadPet:(NSDictionary *)paramters completion:(SVSuccessCompletion)completion {
    [SVPetService reDownloadPet:paramters completion:^(NSInteger errorCode, NSDictionary * _Nonnull info) {
        if (0 == errorCode) {
            completion(YES, nil);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

// MARK: - Lazy/setter
- (NSMutableArray<SVPetModel *> *)pets {
    if(!_pets){
        _pets = @[].mutableCopy;
    }
    return _pets;
}

- (SVPetInfoModel *)petInfo {
    if(!_petInfo){
        _petInfo = [[SVPetInfoModel alloc] init];
    }
    return _petInfo;;
}

- (NSMutableDictionary *)petProgress {
    if (!_petProgress) {
        _petProgress = @{}.mutableCopy;
    }
    return _petProgress;
}

- (NSMutableArray *)actionSizes {
    if (!_actionSizes) {
        _actionSizes = @[].mutableCopy;
    }
    return _actionSizes;
}

- (void)setDeviceId:(NSString *)deviceId {
    _deviceId = deviceId;
}

- (void)dealloc {
    [[SVMQTTManager sharedManager] removeHandler:[self hash]];
}
@end

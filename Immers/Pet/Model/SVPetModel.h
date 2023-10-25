//
//  SVPetModel.h
//  Immers
//
//  Created by ssv on 2022/11/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVPetModel : NSObject
/// 宠物ID
@property (nonatomic, copy) NSString *petId;
/// 是否领养(0否、1是、2正在下载)
@property (nonatomic, copy) NSString *isAdopt;
/// 宠物图片
@property (nonatomic, copy) NSString *petImage;
/// 宠物名称
@property (nonatomic, copy) NSString *petName;
/// 宠物下载是否可判断丢失(true代表可以与相框资源组任务列表做校验比对)
@property (nonatomic, assign) BOOL verification;
@end

@interface SVPetActionModel : NSObject
/// 动作ID
@property (nonatomic, copy) NSString *petActionId;
/// 动作名称
@property (nonatomic, copy) NSString *petActionName;
/// 动作视频大小
@property (nonatomic, copy) NSString *petActionSize;
/// 动作状态
@property (nonatomic, copy) NSString *petActionType;
/// 动作图片
@property (nonatomic, copy) NSString *petShowImage;
@end

@interface SVPetInfoModel : NSObject
/// 宠物ID
@property (nonatomic, copy) NSString *petId;
/// 宠物详情背景图
@property (nonatomic, copy) NSString *backgroundImage;
/// 宠物详情背景图
@property (nonatomic, copy) NSString *awaitId;
/// 宠物动作数组
@property(nonatomic,strong)NSArray <SVPetActionModel *> *petInfoVos;

@end

NS_ASSUME_NONNULL_END

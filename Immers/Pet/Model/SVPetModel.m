//
//  SVPetModel.m
//  Immers
//
//  Created by ssv on 2022/11/9.
//

#import "SVPetModel.h"

@implementation SVPetModel
+ (NSDictionary <NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"petId" : @"id" };
}
@end

@implementation SVPetActionModel
+ (NSDictionary <NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"petActionId" : @"id" };
}
@end

@implementation SVPetInfoModel
+ (NSDictionary <NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"petId" : @"id" };
}
+ (NSDictionary *)modelContainerPropertyGenericClass{

    return @{@"petInfoVos" : [SVPetActionModel class]};

}
@end

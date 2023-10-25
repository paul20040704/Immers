//
//  SVUserInfo.m
//  Immers
//
//  Created by developer on 2023/3/10.
//

#import "SVUserInfo.h"

@implementation SVUserInfo

+ (NSDictionary <NSString *, id> *)modelContainerPropertyGenericClass {
    return @{ @"members" : @"SVMember" };
}

+ (NSDictionary <NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"members" : @"framePhotoMembers" };
}

@end

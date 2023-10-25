//
//  SVDeviceData.m
//  Immers
//
//  Created by developer on 2023/3/13.
//

#import "SVDeviceData.h"

@implementation SVBinderUser

@end


@implementation SVDeviceData

+ (NSDictionary <NSString *, id> *)modelContainerPropertyGenericClass {
    return @{ @"SVBinderUser" : @"user" };
}

+ (NSDictionary <NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"deviceId" : @"id", @"user" : @"bindingUser" };
}

@end

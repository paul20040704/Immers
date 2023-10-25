//
//  SVPlaySection.m
//  Immers
//
//  Created by developer on 2022/5/21.
//

#import "SVPlaySection.h"

@implementation SVPlaySection

+ (NSDictionary <NSString *, id> *)modelContainerPropertyGenericClass {
    return @{ @"items" : @"SVPlayItem" };
}

//+ (NSDictionary <NSString *, id> *)modelCustomPropertyMapper {
//    return @{ @"good_id" : @"id" };
//}

@end

//
//  SVAccountSection.m
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import "SVAccountSection.h"

@implementation SVAccountSection

+ (NSDictionary <NSString *, id> *)modelContainerPropertyGenericClass {
    return @{ @"items" : @"SVAccountItem" };
}

@end

//
//  SVWiFi.m
//  Immers
//
//  Created by developer on 2022/6/8.
//

#import "SVWiFi.h"

@implementation SVWiFi

- (NSString *)level {
    return [_level isEqualToString:@"0"] ? @"1" : _level;
}

@end

//
//  SVAsset.m
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import "SVAsset.h"

@implementation SVAsset

+ (NSDictionary <NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"aid" : @"id" };
}

@end

@implementation SVFile

+ (NSDictionary <NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"fid" : @"id" };
}

@end

@implementation SVPhoto

+ (NSDictionary <NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"pid" : @"id" };
}

- (NSString *)videoDuration {
    if (2 != self.type) { return @""; }
    NSInteger second = self.duration / 1000;
    return [NSString stringWithFormat:@"%02ld:%02ld", second / 60, second % 60];
}

@end

@implementation SVLocalFile
+ (NSDictionary <NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"fileId" : @"id" };
}


@end

@implementation SVLocalFileRequest



@end

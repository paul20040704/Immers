//
//  SVDevice.m
//  Immers
//
//  Created by developer on 2022/6/1.
//

#import "SVDevice.h"

@implementation SVDevice

+ (NSDictionary <NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"deviceId" : @"id" };
}

- (NSString *)versionNum {
    if (!_versionNum) {
        //本地默认值-1,代表还未从设备拿到详细信息。0代表相框是还未添加版本号的版本
        _versionNum = @"-1";
    }
    return _versionNum;
}
@end

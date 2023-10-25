//
//  SVMember.m
//  Immers
//
//  Created by developer on 2023/3/10.
//

#import "SVMember.h"
#import "SVGlobalMacro.h"

@implementation SVMember

- (NSString *)role {
    if (_memberRole == 1) {
        return SVLocalized(@"home_member_owner");
    } else if (_memberRole == 2) {
        return SVLocalized(@"home_member_manager");
    } else {
        return SVLocalized(@"home_member_normal");
    }
}

- (NSString *)roleColor {
    if (_memberRole == 1) {
        return @"#26EE9F";
    } else if (_memberRole == 2) {
        return @"#00BCD4";
    } else {
        return @"#CDDC39";
    }
}

@end

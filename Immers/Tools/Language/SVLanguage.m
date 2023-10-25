//
//  SVLanguage.m
//  Immers
//
//  Created by developer on 2022/5/25.
//

#import "SVLanguage.h"
#import "SVGlobalMacro.h"

static NSString *const kLocalKey = @"localLanguageKey";
static NSString *const kRemoteKey = @"remoteLanguageKey";
static NSBundle *_bundle;

@implementation SVLanguage

/// 获取语言
+ (void)sharedLanguage {
    NSString *language = [[NSUserDefaults standardUserDefaults] valueForKey:kLocalKey];
    if (!language) {
        NSArray<NSString *> *languages = [NSLocale preferredLanguages];
        language = languages.firstObject;
    }
    [self saveLanguage:language];
}

/// 设置语言
+ (void)saveLanguage:(NSString *)language {
    NSString *remote = [self remote];
    if ([language hasPrefix:@"zh-Hans"]) { // 简体
        language = @"zh-Hans";
        remote = @"CN";
        
   } else if ([language hasPrefix:@"zh-Hant"]) { // 繁体（台湾/香港）
       language = @"zh-Hant";
       remote = @"TC";
       
   } else if ([language hasPrefix:@"ja"]) { // 日语
       language = @"ja";
       remote = @"JA";
       
   } else if ([language hasPrefix:@"ko"]) { // 韩国
       language = @"ko";
       remote = @"KR";
       
   } else { // other  英文
       language = @"en";
       remote = @"EN";
   }
 
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    _bundle = [NSBundle bundleWithPath:path];
    
    [[NSUserDefaults standardUserDefaults] setValue:language forKey:kLocalKey];
    [[NSUserDefaults standardUserDefaults] setValue:remote forKey:kRemoteKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 本地话
+ (NSString *)localizedForKey:(NSString *)key {
    return NSLocalizedStringFromTableInBundle(key, @"Localizable", _bundle, nil);
}

/// 请求 服务器 header 语言
+ (NSString *)remote {
    NSString *remote = [[NSUserDefaults standardUserDefaults] valueForKey:kRemoteKey];
    return remote ? : @"CN";
}

/// 本地保存语言
+ (NSString *)local {
    NSString *local = [[NSUserDefaults standardUserDefaults] valueForKey:kLocalKey];
    return local ? : @"zh-Hans";
}

/// 所有语言
+ (NSArray <NSDictionary <NSString *, NSString *> *> *)items {
    NSDictionary *dict0 = @{ @"title" : SVLocalized(@"profile_simplified"), @"icon" : @"zh-Hans",  @"sel" : @"1" };
    NSDictionary *dict1 = @{ @"title" : SVLocalized(@"profile_traditional"), @"icon" : @"zh-Hant", @"sel" : @"1" };
    NSDictionary *dict2 = @{ @"title" : SVLocalized(@"profile_english"), @"icon" : @"en", @"sel" : @"1" };
    //NSDictionary *dict3 = @{ @"title" : SVLocalized(@"profile_japanese"), @"icon" : @"ja", @"sel" : @"1" };
    //NSDictionary *dict4 = @{ @"title" : SVLocalized(@"profile_korean"), @"icon" : @"ko", @"sel" : @"1" };
    //return @[dict0, dict1, dict2, dict3, dict4];
    return @[dict0, dict1, dict2];
}

/// 当前设置语言
+ (NSString *)current {
    for (NSDictionary *dict in self.items) {
        if ([dict[@"icon"] isEqualToString:self.local]) {
            return dict[@"title"];
        }
    }
    return @"";
}

@end

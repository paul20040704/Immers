//
//  SVProfileViewModel.m
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import "SVProfileViewModel.h"
#import "SVGlobalMacro.h"

@implementation SVProfileViewModel

- (NSArray <SVProfileItem *> *)profileItems {
    if (!_profileItems) {
        NSDictionary *dict0 = @{ @"icon" : @"profile_feedback", @"title" : SVLocalized(@"profile_feedback"), @"className" : @"SVProfileViewCell" };
        NSDictionary *dict1 = @{ @"icon" : @"profile_update", @"title" : SVLocalized(@"profile_version_update"), @"className" : @"SVUpdateViewCell" };
        // NSDictionary *dict2 = @{ @"icon" : @"profile_about", @"title" : SVLocalized(@"profile_about"), @"className" : @"SVProfileViewCell" };
        NSDictionary *dict3 = @{ @"icon" : @"profile_invite", @"title" : SVLocalized(@"profile_invite"), @"className" : @"SVProfileViewCell" };
        //_profileItems = [NSArray yy_modelArrayWithClass:[SVProfileItem class] json:@[dict3,dict0, dict1, dict2]];
        _profileItems = [NSArray yy_modelArrayWithClass:[SVProfileItem class] json:@[dict3,dict0, dict1]];
    }
    return _profileItems;
}

- (NSArray <SVAccountSection *> *)sections {
    if (!_sections) {
        SVUserAccount *account = [SVUserAccount sharedAccount];
        
        NSDictionary *dict0 = @{ @"icon" : account.userImage ?: @"", @"title": SVLocalized(@"profile_avarat"), @"sel" : @"avaratClick:" };
        NSDictionary *dict1 = @{ @"title": SVLocalized(@"profile_user_name"), @"text" : account.userName,  @"sel" : @"nameClick:" };
        NSDictionary *dict2 = @{ @"title": SVLocalized(@"profile_sex"), @"text" : account.userSex == 0 ? SVLocalized(@"profile_female") : SVLocalized(@"profile_male"), @"sel" : @"genderClick:" };
        
        NSDictionary *dict3 = @{ @"title": SVLocalized(@"profile_email_address"), @"text" : account.email };
        NSDictionary *dict4 = @{ @"title": SVLocalized(@"profile_phone"), @"text" : account.phone };
        NSDictionary *dict5 = @{ @"title": SVLocalized(@"profile_set_language"), @"text" : [SVLanguage current], @"sel" : @"languageClick" };
        NSDictionary *dict6 = @{ @"icon" : @"profile_edit", @"title": SVLocalized(@"profile_set_password"), @"sel" : @"passwordClick:" };
        NSDictionary *dict7 = @{ @"icon" : account.bindWx ? @"profile_wechat_logo" : @"x", @"title": SVLocalized(@"profile_third_party_binding"), @"sel" : @"thirdClick:" };
        NSDictionary *dict8 = @{ @"title": SVLocalized(@"profile_log_out"), @"sel" : @"cancelAccount:" };
        
        NSDictionary *section0 = @{ @"title" : SVLocalized(@"profile_information"), @"items" : @[dict0, dict1, dict2] };
        NSDictionary *section1 = @{ @"title" : SVLocalized(@"profile_account"), @"items" : @[dict3, dict4, dict5, dict6, dict7, dict8] };
        
        _sections = [NSArray yy_modelArrayWithClass:[SVAccountSection class] json:@[section0, section1]];
    }
    return _sections;
}

- (NSArray<SVProfileItem *> *)abouts {
    if (!_abouts) {
        NSDictionary *dict0 = @{ @"icon" : @"profile_agreement", @"title" : SVLocalized(@"profile_user_agreement"), @"className" : @"SVProfileViewCell" };
        NSDictionary *dict1 = @{ @"icon" : @"profile_policy", @"title" : SVLocalized(@"profile_privacy_policy"), @"className" : @"SVProfileViewCell" };
        NSDictionary *dict2 = @{ @"icon" : @"profile_product_intro", @"title" : SVLocalized(@"profile_product"), @"className" : @"SVProfileViewCell" };
        NSDictionary *dict3 = @{ @"icon" : @"profile_company_intro", @"title" : SVLocalized(@"profile_company_intro"), @"className" : @"SVProfileViewCell" };
        NSDictionary *dict4 = @{ @"icon" : @"profile_connect", @"title" : SVLocalized(@"profile_contact_us"), @"text" : @"400-060-2558", @"className" : @"SVSubtextViewCell" };
        
        _abouts = [NSArray yy_modelArrayWithClass:[SVProfileItem class] json:@[dict0, dict1, dict2, dict3, dict4]];
    }
    return _abouts;
}

@end

//
//  SVLoginManager.m
//  Immers
//
//  Created by developer on 2022/6/13.
//

#import "SVLoginManager.h"
#import <AuthenticationServices/AuthenticationServices.h>

static NSString *const kWXAppid = @"wx4eb1cb9fa7f43371";
static NSString *const kWXSecret = @"2b489b2cf65f1e32385ce6287a793cca";
static NSString *const kWXUniversalLink = @"https://immers.download.smartsuperv.com";

@interface SVLoginManager () <ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

@property (nonatomic, copy) void((^completion)(BOOL isSuccess, BOOL isCancelled, NSDictionary *parameters));

@end

@implementation SVLoginManager

/// 登录单例
+ (instancetype)sharedManager {
    static SVLoginManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [WXApi registerApp:kWXAppid universalLink:kWXUniversalLink];
    });
    return instance;
}

/// 第三方登录
/// @param event 事件
/// @param completion 回调
- (void)login:(SVButtonEvent)event completion:(void(^)(BOOL, BOOL, NSDictionary *))completion {
    if (event == SVButtonEventApple) {
        [self appleCompletion:completion];
        
    } else if (event == SVButtonEventWechat) {
        [self wechatCompletion:completion];
        
    } else if (event == SVButtonEventFacebook) {
       // [self facebookCompletion:completion];
    }
}

// MARK: - 苹果登录
/// 苹果登录
- (void)appleCompletion:(void (^)(BOOL, BOOL, NSDictionary *))completion {
    if (@available(iOS 13.0, *)) {
        // 发起授权
        ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
        ASAuthorizationAppleIDRequest *request = [provider createRequest];
        request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        ASAuthorizationController *viewController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
        viewController.delegate = self;
        viewController.presentationContextProvider = self;
        [viewController performRequests];
        self.completion = completion;
    }
}

//  回调 ASAuthorizationControllerDelegate
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)){
    if (@available(iOS 13.0, *)) {
        if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
            ASAuthorizationAppleIDCredential *credential = authorization.credential;
            NSData *identifyToken = credential.identityToken;
            NSString *token = [[NSString alloc] initWithData:identifyToken encoding:NSUTF8StringEncoding];
            NSPersonNameComponents *fullName = credential.fullName;
            NSString *nickName;
            if ([[SVLanguage local] hasPrefix:@"zh-"]) {
                nickName = [NSString stringWithFormat:@"%@%@", fullName.familyName ?: @"", fullName.givenName ?: @""];
            } else {
                nickName = [NSString stringWithFormat:@"%@%@", fullName.givenName ?: @"", fullName.familyName ?: @""];
            }
            
            if (nickName.length <= 0) {
                nickName = @"Immers";
            }
            
            NSDictionary *dict = @{ @"identityToken" : token, @"userName" : nickName };
            
            if (self.completion) {
                self.completion(YES, NO, dict);
            }
        } else {
            if (self.completion) {
                self.completion(NO, NO, nil);
            }
        }
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    if (self.completion) { // 1001 取消
        self.completion(NO, 1001 == error.code, nil);
    }
}

- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
    return [UIApplication sharedApplication].keyWindow;
}

// MARK: - 微信登录
/// 微信登录
- (void)wechatCompletion:(void (^)(BOOL, BOOL, NSDictionary *))completion {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"userinfo";
    [WXApi sendReq:req completion:^(BOOL success) {
        if (!success) {
            completion(NO, NO, nil);
        }
    }];
    _completion = completion;
}

/// 微信响应
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *res = (SendAuthResp *)resp;
        if (_completion) {
            if (0 == res.errCode) {
                kWself
                NSDictionary *dict = @{ @"code" : res.code, @"appid" : kWXAppid, @"secret" : kWXSecret, @"grant_type" : @"authorization_code" };
                [SVUserService userInfo:dict completion:^(NSInteger errorCode, NSDictionary *info) {
                    kSself
                    if (0 == errorCode) {
                        NSString *headImg = info[@"headimgurl"] ? : @"";
                        NSString *openid = info[@"openid"] ? : @"";
                        NSString *nickname = info[@"nickname"] ? : @"";
                        NSString *sex = [NSString stringWithFormat:@"%@", info[@"sex"]];
                        NSDictionary *dict = @{ @"headImg" : headImg, @"wxId" : openid, @"wxName" : nickname, @"sex" : sex };
                        sself->_completion(YES, NO, dict);
                    } else {
                        sself->_completion(NO, NO, info);
                    }
                }];
                
            } else {
                _completion(NO, YES, nil);
            }
        }
    }
}

/**
// MARK: - facebook登录
/// facebook登录
- (void)facebookCompletion:(void (^)(BOOL, BOOL, NSDictionary *))completion {
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logInWithPermissions:@[@"public_profile", @"email"] fromViewController:viewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (completion) {
            if (error) {
                completion(NO, NO, nil);
             } else if (result.isCancelled) {
                 completion(NO, YES, nil);
             } else {
                 DebugLog(@"result: %@", result);
//                 FBSDKAccessToken *token;
   //              NSString *facebookId =  result.token.userID;
                //用户的facebookId 传给后台 判断该用户是否绑定手机号，如果绑定了直接登录，如果没绑定跳绑定手机号页面
             }
        }

    }];
}
*/
@end

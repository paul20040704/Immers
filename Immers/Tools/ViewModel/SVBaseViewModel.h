//
//  SVBaseViewModel.h
//  Immers
//
//  Created by developer on 2022/5/30.
//

#import <Foundation/Foundation.h>
#import "SVGlobalMacro.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SVSuccessCompletion)(BOOL isSuccess, NSString * _Nullable message);
typedef void(^SVCodeCompletion)(NSInteger errorCode, NSString * _Nullable message);
typedef void(^SVMessageCompletion)(NSString *message);
typedef void(^SVResultCompletion)(BOOL isSuccess, NSString * _Nullable message, _Nullable id result);

@interface SVBaseViewModel : NSObject

@end

NS_ASSUME_NONNULL_END

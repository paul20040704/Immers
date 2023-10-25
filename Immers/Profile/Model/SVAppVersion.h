//
//  SVAppVersion.h
//  Immers
//
//  Created by developer on 2022/12/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVAppVersion : NSObject
/// 构建号
@property (nonatomic, copy) NSString *code;
/// 版本号
@property (nonatomic, copy) NSString *apkVersion;
/// 更新内容
@property (nonatomic, copy) NSString *content;
/// 是否强制更新（0否1是）
@property (nonatomic, assign) BOOL updateForce;
@end

NS_ASSUME_NONNULL_END

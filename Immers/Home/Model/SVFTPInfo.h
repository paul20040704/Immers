//
//  SVFTPInfo.h
//  Immers
//
//  Created by developer on 2022/9/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVFTPInfo : NSObject

/// 帐号 ftp 名字
@property (nonatomic, copy) NSString *account;
/// 地址
@property (nonatomic, copy) NSString *addrees;
/// 密码
@property (nonatomic, copy) NSString *password;
/// 是否打开ftp
@property (nonatomic, assign) BOOL isOpen;

@end

NS_ASSUME_NONNULL_END

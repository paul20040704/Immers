//
//  NSData+Extension.h
//  Immers
//
//  Created by developer on 2022/5/12.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Extension)

- (NSString *)md5String;


+ (unsigned long long)fileSizeAtPath:(NSString *)filePath;
@end

NS_ASSUME_NONNULL_END

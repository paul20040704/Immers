//
//  SVUploadFilePath.h
//  Immers
//
//  Created by developer on 2022/11/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVUploadFilePath : NSObject
/// 是否打开文件上传
@property (nonatomic, assign) BOOL isOpen;
/// 上传地址
@property (nonatomic, copy) NSString *url;
@end

NS_ASSUME_NONNULL_END

//
//  SVFTPViewController.h
//  Immers
//
//  Created by developer on 2022/9/6.
//

#import "SVBaseViewController.h"
#import "SVFTPInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVFTPViewController : UIAlertController
//
//@property (nonatomic, strong) SVFTPInfo *info;
//
//@property (nonatomic, copy) NSString *filePath;

+ (instancetype)viewControllerWithPath:(NSString *)filePath serviceInfo:(SVFTPInfo *)serviceInfo;

@end

NS_ASSUME_NONNULL_END

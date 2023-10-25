//
//  SVScannerViewController.h
//  Immers
//
//  Created by developer on 2022/6/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 扫描控制器
@interface SVScannerViewController : UIViewController

/// 实例化扫描控制器
///
/// @param completion 完成回调
///
/// @return 扫描控制器
- (instancetype)initWithCompletion:(void (^)(NSString *stringValue))completion;


@end

NS_ASSUME_NONNULL_END

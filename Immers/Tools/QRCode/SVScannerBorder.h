//
//  SVScannerBorder.h
//  Immers
//
//  Created by developer on 2022/6/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVScannerBorder : UIView

/// 开始扫描动画
- (void)startScannerAnimating;
/// 停止扫描动画
- (void)stopScannerAnimating;

@end

NS_ASSUME_NONNULL_END

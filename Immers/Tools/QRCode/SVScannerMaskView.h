//
//  SVScannerMaskView.h
//  Immers
//
//  Created by developer on 2022/6/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 扫描遮罩视图
@interface SVScannerMaskView : UIView

/// 使用裁切区域实例化遮罩视图
///
/// @param frame    视图区域
/// @param cropRect 裁切区域
///
/// @return 遮罩视图
+ (instancetype)maskViewWithFrame:(CGRect)frame cropRect:(CGRect)cropRect;

/// 裁切区域
@property (nonatomic) CGRect cropRect;

@end

NS_ASSUME_NONNULL_END

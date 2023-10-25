//
//  SVSheetViewController.h
//  Immers
//
//  Created by developer on 2022/5/21.
//

#import "SVBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVSheetItem : NSObject


/// 创建item
/// @param text 标题
/// @param callback 回调
+ (instancetype)item:(nullable NSString *)text callback:(void(^)(void))callback;

/// 创建item
/// @param icon 图标
/// @param text 标题
/// @param callback 回调
+ (instancetype)item:(nullable NSString *)icon text:(nullable NSString *)text callback:(void(^)(void))callback;

/// 创建item
/// @param text 标题
/// @param textColor 默认颜色
/// @param callback 回调
+ (instancetype)item:(nullable NSString *)text textColor:(nullable UIColor *)textColor callback:(void(^)(void))callback;

/// 创建item
/// @param icon 图标
/// @param text 标题
/// @param textColor 默认颜色
/// @param selectedColor 选中颜色
/// @param selected 是否选中
/// @param callback 回调
+ (instancetype)item:(nullable NSString *)icon text:(nullable NSString *)text textColor:(nullable UIColor *)textColor selectedColor:(nullable UIColor *)selectedColor selected:(BOOL)selected callback:(void(^)(void))callback;

/// 图片名
@property (nonatomic, copy) NSString *icon;
/// 标题
@property (nonatomic, copy) NSString *text;
/// 默认颜色  默认【白色】
@property (nonatomic, strong) UIColor *textColor;
/// 选中颜色
@property (nonatomic, strong) UIColor *selectedColor;
/// 是否选中
@property (nonatomic, assign) BOOL selected;
/// 回调
@property (nonatomic, copy) void(^selectedCallback)(void);

@end

@interface SVSheetViewController : SVBaseViewController

/// 显示多少个，0为全部显示
@property (nonatomic, assign) NSInteger showCount;


+ (instancetype)sheetController:(NSArray<SVSheetItem *> *)items;

@end

NS_ASSUME_NONNULL_END

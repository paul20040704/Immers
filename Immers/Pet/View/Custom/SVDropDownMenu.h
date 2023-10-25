//
//  SVDropDownMenu.h
//  Immers
//
//  Created by developer on 2022/11/17.
//

#import <UIKit/UIKit.h>
#import "SVGlobalMacro.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVDropDownMenu : UIView
@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, strong) NSArray * datas;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIColor *indicatorColor;

@property (nonatomic, strong) UIFont * font;
//选中后自动收起
@property (nonatomic, assign) BOOL autoCloseWhenSelected;

//选中回调
@property (nonatomic, copy) void(^cellClickedBlock)(NSString *title,NSInteger index);
//打开回调
@property (nonatomic, copy) void(^openMenuBlock)(BOOL isOpen);
//无设备回调
@property (nonatomic, copy) void(^noDeviceBlock)(void);

- (void)closeMenu;
@end

NS_ASSUME_NONNULL_END

//
//  SVPlayItem.h
//  Immers
//
//  Created by developer on 2022/5/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVPlayItem : NSObject

/// 图标
@property (nonatomic, copy) NSString *icon;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 文本
@property (nonatomic, copy) NSString *text;
/// 点击事件
@property (nonatomic, copy) NSString *sel;
/// 是否选中
@property (nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END

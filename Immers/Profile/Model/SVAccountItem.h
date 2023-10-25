//
//  SVAccountItem.h
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVAccountItem : NSObject

/// 标题
@property (nonatomic, copy) NSString *title;

/// 图标/头像
@property (nonatomic, copy) NSString *icon;

/// 文本
@property (nonatomic, copy) NSString *text;

/// 方法
@property (nonatomic, copy) NSString *sel;

/// 是否可用
@property (nonatomic, assign, readonly) BOOL enabled;

@end

NS_ASSUME_NONNULL_END

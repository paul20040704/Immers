//
//  SVProfileItem.h
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVProfileItem : NSObject

/// 类型
@property (nonatomic, copy) NSString *className;
/// 图标
@property (nonatomic, copy) NSString *icon;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 文本
@property (nonatomic, copy) NSString *text;
/// 提示数量
@property (nonatomic, assign) NSInteger count;
/// 是否有更新
@property (nonatomic, assign, getter=isUpdate) BOOL update;

@end

NS_ASSUME_NONNULL_END

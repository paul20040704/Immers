//
//  SVSetting.h
//  Immers
//
//  Created by developer on 2022/5/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVSettings : NSObject

/// 标题
@property (nonatomic, copy) NSString *title;
/// 文本
@property (nonatomic, copy) NSString *text;

/// 方法名
@property (nonatomic, copy) NSString *sel;

@end

NS_ASSUME_NONNULL_END

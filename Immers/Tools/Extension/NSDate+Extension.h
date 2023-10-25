//
//  NSDate+Extension.h
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Extension)

/// 时间描述格式
///  - 刚刚
///  - X分钟前
///  - X小时前 (当天)
///  - 昨天 HH:mm (昨天)
///  - MM-dd HH:mm (一年内)
///  - yyyy-MM-dd HH:mm (更早)
- (NSString *)dateDescription;

/// 时间描述格式
///  - X分钟前
///  - X小时前 (当天)
///  - 昨天 HH:mm (昨天)
///  - 昨天 HH:mm (前天)
///  - MM-dd HH:mm (一年内)
///  - yyyy-MM-dd HH:mm (更早)
- (NSString *)formatDescription;

- (NSString *)timeDescription;

/// 日期描述字符串
- (NSString *)dateFormat:(NSString *)format;

@end

NS_ASSUME_NONNULL_END

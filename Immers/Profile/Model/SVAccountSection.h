//
//  SVAccountSection.h
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import <Foundation/Foundation.h>
#import "SVAccountItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVAccountSection : NSObject

/// 组名
@property (nonatomic, copy) NSString *title;

/// 帐号信息
@property (nonatomic, strong) NSArray<SVAccountItem *> *items;

@end

NS_ASSUME_NONNULL_END

//
//  SVPlaySection.h
//  Immers
//
//  Created by developer on 2022/5/21.
//

#import <Foundation/Foundation.h>
#import "SVPlayItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVPlaySection : NSObject
/// 组名
@property (nonatomic, copy) NSString *title;

/// 播放设置
@property (nonatomic, strong) NSArray<SVPlayItem *> *items;

@end

NS_ASSUME_NONNULL_END

//
//  SVProfileViewModel.h
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import <Foundation/Foundation.h>
#import "SVProfileItem.h"
#import "SVAccountSection.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVProfileViewModel : NSObject

/// 我的 选项
@property (nonatomic, strong) NSArray<SVProfileItem *> *profileItems;

/// 设置 分组
@property (nonatomic, strong, nullable) NSArray<SVAccountSection *> *sections;

/// 关于 选项
@property (nonatomic, strong) NSArray<SVProfileItem *> *abouts;


@end

NS_ASSUME_NONNULL_END

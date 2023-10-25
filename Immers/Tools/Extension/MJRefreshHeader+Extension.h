//
//  MJRefreshHeader+Extension.h
//  Immers
//
//  Created by ssv on 2022/11/7.
//

#import "MJRefreshHeader.h"
#import "SVGlobalMacro.h"
NS_ASSUME_NONNULL_BEGIN

@interface MJRefreshHeader (Extension)

+ (MJRefreshNormalHeader * )getNormalRefreshHeaderWithRefreshingBlock:(MJRefreshComponentAction)refreshingBlock;

@end

NS_ASSUME_NONNULL_END

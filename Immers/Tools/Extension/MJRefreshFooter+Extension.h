//
//  MJRefreshFooter+Extension.h
//  Immers
//
//  Created by ssv on 2022/11/8.
//

#import "MJRefreshFooter.h"
#import "SVGlobalMacro.h"
NS_ASSUME_NONNULL_BEGIN

@interface MJRefreshFooter (Extension)
+ (MJRefreshBackStateFooter * )getNormalRefreshFooterWithRefreshingBlock:(MJRefreshComponentAction)refreshingBlock;
@end

NS_ASSUME_NONNULL_END

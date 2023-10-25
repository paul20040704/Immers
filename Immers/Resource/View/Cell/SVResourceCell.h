//
//  SVResourceCell.h
//  Immers
//
//  Created by ssv on 2022/11/11.
//

#import "SVCollectionViewCell.h"
#import "SVResourceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVResourceCell : SVCollectionViewCell
/// 资源
@property (nonatomic, strong) SVResourceModel *resource;
/// 长按回调
@property (nonatomic, copy) void(^longPressBlock)(void);
@end

NS_ASSUME_NONNULL_END

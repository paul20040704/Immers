//
//  SVAICell.h
//  Immers
//
//  Created by Paul on 2023/7/25.
//

#import "SVCollectionViewCell.h"
#import "SVAIModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVAICell : SVCollectionViewCell
/// 资源
@property (nonatomic, strong) SVAIModel *resource;

@end

NS_ASSUME_NONNULL_END

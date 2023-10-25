//
//  SVCollectionViewCell.h
//  Immers
//
//  Created by developer on 2022/5/16.
//

#import <UIKit/UIKit.h>
#import "SVGlobalMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVCollectionViewCell : UICollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

+ (NSString *)identifier;

@end

NS_ASSUME_NONNULL_END

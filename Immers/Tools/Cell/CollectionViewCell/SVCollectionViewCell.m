//
//  SVCollectionViewCell.m
//  Immers
//
//  Created by developer on 2022/5/16.
//

#import "SVCollectionViewCell.h"

@implementation SVCollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:[self identifier] forIndexPath:indexPath];
}

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

@end

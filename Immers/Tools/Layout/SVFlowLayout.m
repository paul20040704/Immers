//
//  SVFlowLayout.m
//  Immers
//
//  Created by developer on 2022/5/16.
//

#import "SVFlowLayout.h"
#import "SVGlobalMacro.h"

@implementation SVDeviceLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat width = (self.collectionView.bounds.size.width - kWidth(142) -kWidth(24) - kWidth(20));
    CGFloat height = self.collectionView.bounds.size.height;
    
    self.itemSize = CGSizeMake(width/kDeviceScale, height/kDeviceScale);
    self.minimumLineSpacing = -10;
    CGFloat inset = (self.collectionView.frame.size.width - width) * 0.5 * kDeviceScale;
    self.sectionInset = UIEdgeInsetsMake(self.sectionInset.top,
                                         inset,
                                         self.sectionInset.top,
                                         inset);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}

/// 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attributes in array) {
        if (ABS(minDelta) > ABS(attributes.center.x - centerX)) {
            minDelta = attributes.center.x - centerX;
        }
    }
    
    proposedContentOffset.x += minDelta;
    proposedContentOffset.x = proposedContentOffset.x<0?0:proposedContentOffset.x;
    proposedContentOffset.x = proposedContentOffset.x>floor(self.collectionView.contentSize.width - kScreenWidth)?floor(self.collectionView.contentSize.width - kScreenWidth):proposedContentOffset.x;
    return proposedContentOffset;
    
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    CGFloat scale = kDeviceScale-1; //调节值
    NSArray *superAttributes = [super layoutAttributesForElementsInRect:rect];
    NSArray *attributes = [[NSArray alloc] initWithArray:superAttributes copyItems:YES];
    
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x,
                                    self.collectionView.contentOffset.y,
                                    self.collectionView.frame.size.width,
                                    self.collectionView.frame.size.height);
    CGFloat offset = CGRectGetMidX(visibleRect);
    
    [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat distance = offset - attribute.center.x;
        CGFloat scaleForDistance = distance / self.itemSize.height;
        CGFloat scaleForCell = 1 + scale * (1 - fabs(scaleForDistance));
        
        // 仅仅操作y
        attribute.transform3D = CATransform3DMakeScale(scaleForCell, scaleForCell, 1);
        attribute.zIndex = scaleForCell>1.3?2:1;
    }];
    
    return attributes;
}



@end

// MARK: - SVFilesLayout

@implementation SVFilesLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat space = kWidth(7);
    CGFloat width = (self.collectionView.bounds.size.width - 2 * (kWidth(24) + space)) / 3.0;
    CGFloat height = width;
    
    self.itemSize = CGSizeMake(width, height);
    self.minimumLineSpacing = space;
    self.minimumInteritemSpacing = space;
    
    self.sectionInset = UIEdgeInsetsMake(kHeight(20), kWidth(24), kHeight(20), kWidth(24));
    self.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}

@end


@implementation SVAlbumLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    // 手机是3列 iPad是6列
    NSInteger column = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 6 : 3;
//    CGFloat space = kHeight(1);
//    CGFloat width = (self.collectionView.bounds.size.width - (column -1) * space) / column;
    CGFloat width = self.collectionView.bounds.size.width / column;
    CGFloat height = width*1.34;
    
    self.itemSize = CGSizeMake(width, height);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    
//    self.sectionInset = UIEdgeInsetsMake(kHeight(20), kWidth(24), kHeight(20), kWidth(24));
    self.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}

@end


@implementation SVPhotoFrameLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    // 手机是3列 iPad是6列
    NSInteger column = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 6 : 3;
    CGFloat space = kHeight(14);
    CGFloat width = (self.collectionView.bounds.size.width - (column -1) * space) / column;
    CGFloat height = 1.3 * width;
    
    self.itemSize = CGSizeMake(width, height);
    self.minimumLineSpacing = space;
    self.minimumInteritemSpacing = space;
    
    self.sectionInset = UIEdgeInsetsZero;
    self.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}

@end

/// 资源
@implementation SVResourceFrameLayout
- (void)prepareLayout {
    [super prepareLayout];
    
    // 手机是2列 iPad是4列
    NSInteger column = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 4 : 2;
    CGFloat space = kHeight(7);
    CGFloat width = (self.collectionView.bounds.size.width - (column -1) * space - kWidth(20)) / column;
    CGFloat height = 1.34 * width;
    
    self.itemSize = CGSizeMake(width, height);
    self.minimumLineSpacing = space;
    self.minimumInteritemSpacing = space;
    
    self.sectionInset = UIEdgeInsetsMake(kHeight(20), kWidth(10), kHeight(20), kWidth(10));
    self.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}
@end

/// AI
@implementation SVAIFrameLayout
- (void)prepareLayout {
    [super prepareLayout];
    
    // 手机是2列 iPad是4列
    NSInteger column = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 4 : 2;
    CGFloat space = kHeight(7);
    CGFloat width = (self.collectionView.bounds.size.width - (column -1) * space - kWidth(20)) / column;
    CGFloat height = 1.34 * width;
    
    self.itemSize = CGSizeMake(width, height);
    self.minimumLineSpacing = space;
    self.minimumInteritemSpacing = space;
    
    self.sectionInset = UIEdgeInsetsMake(kHeight(20), kWidth(10), kHeight(20), kWidth(10));
    self.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}
@end

/// 宠物
@implementation SVPetFrameLayout
- (void)prepareLayout {
    [super prepareLayout];
    
    // 手机是2列 iPad是4列
    NSInteger column = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 4 : 2;
    CGFloat space = kHeight(7);
    CGFloat width = (self.collectionView.bounds.size.width - (column -1) * space - kWidth(48)) / column;
    CGFloat height = 1.25 * width;
    
    self.itemSize = CGSizeMake(width, height);
    self.minimumLineSpacing = space;
    self.minimumInteritemSpacing = space;
    
    self.sectionInset = UIEdgeInsetsMake(kHeight(26), kWidth(24), kHeight(26), kWidth(24));
    self.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}
@end
/// 宠物动作
@implementation SVPetActionFrameLayout
- (void)prepareLayout {
    [super prepareLayout];
    
    // 手机是2列 iPad是4列
    NSInteger column = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 4 : 2;
    CGFloat space = kHeight(30);
    CGFloat width = (self.collectionView.bounds.size.width - (column -1) * space - kWidth(52)) / column;
    CGFloat height = 0.8 * width;
    
    self.itemSize = CGSizeMake(width, height);
    self.minimumLineSpacing = space;
    self.minimumInteritemSpacing = kHeight(20);
    
    self.sectionInset = UIEdgeInsetsMake(kHeight(26), kWidth(28), kHeight(26), kWidth(28));
    self.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}

@end

//
//  SVDeviceView.m
//  Immers
//
//  Created by developer on 2022/5/16.
//

#import "SVDeviceView.h"
#import "SVDeviceViewCell.h"
#import "SVGlobalMacro.h"
#import "SVOfflineView.h"

@interface SVDeviceView () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation SVDeviceView {
    NSIndexPath *_selectedIndexPath;
    SVOfflineView *_offlineView;
}

- (void)updateDeviceStatus {
    for (SVDevice *device in self.devices) {
        if (device.selected) {
            _offlineView.hidden = device.onlineStatus;
        }
    }
    
    [self reloadData];
}

// MARK: - setter
- (void)setDevices:(NSMutableArray<SVDevice *> *)devices {
    _devices = devices;
    if (_devices.count>_selectedIndexPath.row) {
        [self updateSelected:_selectedIndexPath.row];
        [self scrollToItemAtIndexPath:_selectedIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }else{
        [self updateSelected:0];
    }
    
}

// MARK: - 初始化
- (instancetype)init {
    if (self = [super initWithFrame:CGRectZero collectionViewLayout:[[SVDeviceLayout alloc] init]]) {
        [self prepareSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:[[SVDeviceLayout alloc] init]]) {
        [self prepareSubviews];
    }
    return self;
}

- (void)updateSelected:(NSInteger)selectedIndex {
    NSInteger index = 0;
    for (SVDevice *device in self.devices) {
        device.selected = index == selectedIndex;
        index += 1;
        // 选中 及 回调
        if (device.selected && self.updateSelectedDeviceCallback) {
            // 回调选中设备
            self.updateSelectedDeviceCallback(device);
        }
    }
    // 更新在线状态
    for (SVDevice *device in self.devices) {
        if (device.selected) {
            [self updateDeviceStatus];
            break;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
    });
    
}

// MARK: - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.devices.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SVDeviceViewCell *deviceCell = [SVDeviceViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    deviceCell.device = self.devices[indexPath.item];
    return deviceCell;
}

// MARK: - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SVDevice *device = self.devices[indexPath.item];
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    if (!device.selected) {
        [self updateSelected:indexPath.item];
        _selectedIndexPath = indexPath; // 记录选中
        return;
    }
}

- (void)scrollViewDidEndDecelerating:(UICollectionView *)collectionView {
    NSArray<SVDeviceViewCell *> *cells = collectionView.visibleCells;

    for (SVDeviceViewCell *cell in cells) {
        CGRect cellRect = [collectionView convertRect:cell.frame toView:collectionView];
        CGRect superRect = [collectionView convertRect:cellRect toView:collectionView.superview];
        
        // 最小x / 最大x
        CGFloat minX = CGRectGetMinX(superRect);
        CGFloat maxX = CGRectGetMaxX(superRect);
        // 判断是否在 屏幕上
        if (minX > 0 && maxX < kScreenWidth) {
            NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
            // 判断选中是否一样
            if ([_selectedIndexPath isEqual:indexPath] ) { break; }
            [self updateSelected:indexPath.item];
            _selectedIndexPath = indexPath; // 记录选中
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(SVDeviceLayout *)layout insetForSectionAtIndex:(NSInteger)section {
    if (self.devices.count == 1) { // 只绑定一台设备 布局
        CGFloat offset = (collectionView.bounds.size.width - layout.itemSize.width) / 2.0;
        return UIEdgeInsetsMake(0, offset, 0, offset);
    } else { // 多台设备布局
        return layout.sectionInset;
    }
}

// MARK: - UI
/// 子视图
- (void)prepareSubviews {
    self.dataSource = self;
    self.delegate = self;
    
    self.backgroundColor = [UIColor clearColor];
    
    [self registerClass:[SVDeviceViewCell class] forCellWithReuseIdentifier:SVDeviceViewCell.identifier];
    
    _offlineView = [SVOfflineView offlineView];
    _offlineView.hidden = YES;
    [self addSubview:_offlineView];
    
    kWself
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        kSself
        if (sself) {
            [sself->_offlineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(sself);
                make.centerX.equalTo(sself.superview);
                make.size.mas_equalTo(sself->_offlineView.bounds.size);
            }];
        }
    });
}

@end

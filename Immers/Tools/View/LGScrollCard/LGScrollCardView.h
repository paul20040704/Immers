//
//  LGScrollCardView.h
//  SonkwoApp
//
//  Created by zdby on 2022/6/21.
//  Copyright © 2022 ceasia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGScrollCardView;


/**
 * 数据协议
 */
@protocol LGScrollCardDataSource <NSObject>

@required
/**
 * 需要展示overlap(重叠的个数)
 */
- (NSInteger)overlapCountOfEasyScrollCard:(LGScrollCardView *_Nonnull)card;

/**
 * 需要展示的数据，要传入URL地址的字符串数组
 */
- (NSArray<NSString*>*_Nonnull)cardListOfEasyScrollCard:(LGScrollCardView *_Nonnull)card;

@optional

/**
 * 是否可以循环滚动 默认为true
 */
- (BOOL)canLoopScrollOfEasyScrollCard:(LGScrollCardView *)card;

/**
 * 图片垂直偏移的顶部距离 默认为10
 */
- (CGFloat)imageRowMarginOfEasyScrollCard:(LGScrollCardView *)card;
/**
 * 图片水平偏移的距离 默认为10
 */
- (CGFloat)imageLineMarginOfEasyScrollCard:(LGScrollCardView *)card;

/**
 * 滑动距离相当于自身宽度多少的时候算做一次滑动 默认0.4
 */
- (CGFloat)panMinMarginScaleOfEasyScrollCard:(LGScrollCardView *)card;

/**
 * 滑动结束时候 执行滑动的最低速度 默认值为200
 */
- (CGFloat)panMinVelocityValueOfEasyScrollCard:(LGScrollCardView *)card;

/**
 * 图片在最顶层时候的圆角 默认为24
 */
- (CGFloat)imageMaxCornerRadiusOfEasyScrollCard:(LGScrollCardView *)card;
/**
 * 图片在最底层时候的圆角 默认为16
 */
- (CGFloat)imageMinCornerRadiusOfEasyScrollCard:(LGScrollCardView *)card;


@end


/**
 * 其他事件协议
 */
@protocol LGScrollCardDelegate <NSObject>

@optional

/**
 * 点击了card的回调
 * @param index 当前显示的主图下标
 */
- (void)easyCard:(LGScrollCardView*_Nonnull)easyCard itemClickWithIndex:(NSInteger)index;

/**
 * 将要开始滑动的时候的回调
 * @param index 当前显示的主图下标
 */
- (void)easyCard:(LGScrollCardView*_Nonnull)easyCard willBeginScrollWithIndex:(NSInteger)index;

/**
 * 将近结束的时候的回调
 * @param fromIndex 来自哪个数组下标
 * @param toIndex 下一个展示的数据下标
 */
- (void)easyCard:(LGScrollCardView*_Nonnull)easyCard willEndScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

@end



@interface LGScrollCardView : UIView
/// 数据协议代理
@property (nonatomic,weak)id<LGScrollCardDataSource> dataSource;
/// 其他代理
@property (nonatomic,weak)id<LGScrollCardDelegate> delegate;
@end



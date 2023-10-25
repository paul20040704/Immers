//
//  LGScrollCardView.m
//  SonkwoApp
//
//  Created by zdby on 2022/6/21.
//  Copyright © 2022 ceasia. All rights reserved.
//

#import "LGScrollCardView.h"
#import "LGScrollCardImgView.h"
#import "LGScrollCardConfig.h"
#import "LGScrollCardLayout.h"
#import "UIView+AutoLayout.h"
#import "SVGlobalMacro.h"
@interface LGScrollCardView ()<UIGestureRecognizerDelegate>

@property (nonatomic,weak)UIView *emptyView;

/// 内部的展示的图片view都包裹在内部
@property (nonatomic,weak)UIView *contentView;

@property (nonatomic,weak)UILabel *countLabel;

/// 卡片数据
@property (nonatomic,strong)NSArray <NSString*>*cardList;
/// 真实展示数据的数据，
@property (nonatomic,strong)NSArray <NSString*>*loopList;
/// 展示的数据个数
@property (nonatomic,assign)NSInteger overloopCount;

@property (nonatomic,assign)BOOL canLoop;
/// 数据上是否支持循环
@property (nonatomic,assign)BOOL dataSupportLoop;

/// 结束滑动时候相对于自身的最小比例，才能执行一次滑动
@property (nonatomic,assign)CGFloat scrollPanMinScale;
/// 结束滑动时候的最小速度
@property (nonatomic,assign)CGFloat scrollPanMinVelocity;


/// 在切换内部view的Z位置的时候做标记
@property (nonatomic,assign)BOOL hadTransZIndex;
/// 是否向左滑
@property (nonatomic,assign)BOOL trunScrollToLeft;
/// 是否正在end动画过程中
@property (nonatomic,assign)BOOL isInEndPageAnimation;
/// 当前正在拖动的imgview
@property (nonatomic,weak)LGScrollCardImgView *currentPanImgView;
/// 当前展示主图数据 相对于 传入所有数据的下标
/// 比如传入的总共数据有10个，默认展示的主图的tag为0，假如第一次右滑的时候，那么则应该展示的index为9
@property (nonatomic,assign)NSInteger currentMainImgDataIndex;


@end


@implementation LGScrollCardView

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _trunScrollToLeft = true;
        
        UIView *emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        emptyView.backgroundColor = UIColor.grayColor;
        self.emptyView = emptyView;
        [self addSubview:emptyView];
        
        // 第一张张及更多图片的内容view
        UIView *contentView = [[UIView alloc]initWithFrame:self.bounds];
        contentView.backgroundColor = UIColor.clearColor;//[self mainWhiteBackGroundColor];
        contentView.clipsToBounds = true;
        self.contentView = contentView;
        [self addSubview:contentView];
        
        // 给contenview 添加拖动手势
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panTheContentPage:)];
        panGesture.delegate = self;
        [contentView addGestureRecognizer:panGesture];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheContentPage)];
        [contentView addGestureRecognizer:tapGesture];
        
        UILabel *emptyLabel = [[UILabel alloc]init];
        emptyLabel.text = @"暂无数据";
        emptyLabel.textColor = [UIColor whiteColor];
        emptyLabel.font = [UIFont systemFontOfSize:15];
        emptyLabel.numberOfLines = 0;
        emptyLabel.textAlignment = NSTextAlignmentCenter;
        [emptyView addSubview:emptyLabel];
        [emptyLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [emptyLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        //显示张数
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(20), frame.size.height - kHeight(30), frame.size.width - kWidth(40), kHeight(20))];
        countLabel.textColor = UIColor.whiteColor;
        countLabel.font = kSystemFont(12);
        countLabel.textAlignment = NSTextAlignmentRight;
        self.countLabel = countLabel;
        [self addSubview:countLabel];
        
    }
    return self;
}

/**
 * 背景色
 */
- (UIColor*)mainWhiteBackGroundColor
{
    if(@available(iOS 13.0, *)) {
        return  [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trait) {
            if (trait.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor colorWithRed:0.07 green:0.07 blue:0.08 alpha:1];
            } else {
                return [UIColor whiteColor];
            }
        }];
    }else{
        return [UIColor whiteColor];
    }
}

/**
 * 在控件被加载到父控件上的时候被调用，
 * 这个时候展示卡片数据
 */
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if(self.superview){
        CGFloat corner = LG_EASY_CARD_CORNER_24;
        if([self.dataSource respondsToSelector:@selector(imageMaxCornerRadiusOfEasyScrollCard:)]){
            CGFloat value = [self.dataSource imageMaxCornerRadiusOfEasyScrollCard:self];
            if(value != 0){
                corner = value;
            }
        }
        [self.emptyView.layer setMaskedCorners:corner];
        self.emptyView.layer.masksToBounds = true;
        [self reloadCardData];
    }
}

/**
 * 重新展示卡片数据
 */
- (void)reloadCardData
{
    // 1、清空contentView内部的所有子控件
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 2、初始主index为0
    _currentMainImgDataIndex = 0;
    // 3、获取当前的所有卡片数据
    NSArray *cardList = [self.dataSource cardListOfEasyScrollCard:self];
    self.countLabel.text = [NSString stringWithFormat:@"%ld%@",cardList.count,SVLocalized(@"home_resource_count")];
    _cardList = cardList;
    if(cardList.count == 0){
        self.contentView.hidden = true;
        self.emptyView.hidden = false;
        return;
    }
    self.contentView.hidden = false;
    self.emptyView.hidden = true;
    // 4、更新当前展示数据的个数
    self.overloopCount = [self.dataSource overlapCountOfEasyScrollCard:self];
    // 5、更新滑动比例和速度
    CGFloat panMinScale = LG_EASY_CARD_PAN_MIN_MARGIN_SCALE;
    if([self.dataSource respondsToSelector:@selector(panMinMarginScaleOfEasyScrollCard:)]){
        CGFloat scale_value = [self.dataSource panMinMarginScaleOfEasyScrollCard:self];
        if(scale_value > 0){
            panMinScale = scale_value;
        }
    }
    self.scrollPanMinScale = panMinScale;
    
    CGFloat panMinVelocity = LG_EASY_CARD_PAN_MIN_VELOCITY_VALUE;
    if([self.dataSource respondsToSelector:@selector(panMinVelocityValueOfEasyScrollCard:)]){
        CGFloat velocity_value = [self.dataSource panMinVelocityValueOfEasyScrollCard:self];
        if(velocity_value > 0){
            panMinVelocity = velocity_value;
        }
    }
    self.scrollPanMinVelocity = panMinVelocity;
    
    // 6、是否可以循环滚动
    if([self.dataSource respondsToSelector:@selector(canLoopScrollOfEasyScrollCard:)]){
        self.canLoop = [self.dataSource canLoopScrollOfEasyScrollCard:self];
    }else{
        
    }self.canLoop = true;
    
    // 7、布局子控件
    [self setUpChildWLoopImages];
    
}

#pragma mark - 子控件ImageView的布局

/**
 * 初始化轮回布局
 */
- (void)setUpChildWLoopImages
{
    // 如果支持右滑动，则需要多一个图片展示
    NSInteger maxShowCount = self.overloopCount + 1;
    if(self.cardList.count >= maxShowCount){
        self.loopList = [self.cardList subarrayWithRange:NSMakeRange(0, maxShowCount)];
        self.dataSupportLoop = true;
    }else{
        self.loopList = self.cardList;
    }
    CGRect imgFrame = self.contentView.bounds;
    UIView *lastView = nil;
    // 创建布局对象
     LGScrollCardLayout *imgLayout = [self createImgLayout];
    for (int i = 0; i<self.loopList.count; i++) {
        NSString *imgData = self.loopList[i];
      LGScrollCardImgView *imageView = [[LGScrollCardImgView alloc]initWithFrame:imgFrame imgLayout:imgLayout];
        imageView.imgUrl = imgData;
        // 必须要写i+1，后面会通过viewWithTag的方式获取对应的imgview，如果为0，则不能正常取到
        imageView.tag = i+1;
        
        if(self.dataSupportLoop && i == self.loopList.count - 1){
            imageView.istemp = true;
        }
        imageView.position = i;
        if(lastView){
            [self.contentView insertSubview:imageView belowSubview:lastView];
        }else{
            [self.contentView addSubview:imageView];
        }
        lastView = imageView;
    }
}

/**
 * 根据用户数据源 实现方式创建布局对象
 */
- (LGScrollCardLayout*)createImgLayout
{
    LGScrollCardLayout *layout = [[LGScrollCardLayout alloc]init];
    layout.overloopCount = self.overloopCount;
    // 行间距
    if([self.dataSource respondsToSelector:@selector(imageLineMarginOfEasyScrollCard:)]){
        layout.lineMargin = [self.dataSource imageLineMarginOfEasyScrollCard:self];
    }else{
        layout.lineMargin = LG_EASY_CARD_PHOTO_LINE_MARGIN;
    }
    // 列间距
    if([self.dataSource respondsToSelector:@selector(imageRowMarginOfEasyScrollCard:)]){
        layout.rowMargin = [self.dataSource imageRowMarginOfEasyScrollCard:self];
    }else{
        layout.rowMargin = LG_EASY_CARD_PHOTO_ROW_MARGIN;
    }
    // 最大圆角
    if([self.dataSource respondsToSelector:@selector(imageMaxCornerRadiusOfEasyScrollCard:)]){
        layout.maxCornerRadius = [self.dataSource imageMaxCornerRadiusOfEasyScrollCard:self];
    }else{
        layout.maxCornerRadius = LG_EASY_CARD_CORNER_24;
    }
    // 最小圆角
    if([self.dataSource respondsToSelector:@selector(imageMinCornerRadiusOfEasyScrollCard:)]){
        layout.minCornerRadius = [self.dataSource imageMinCornerRadiusOfEasyScrollCard:self];
    }else{
        layout.minCornerRadius = LG_EASY_CARD_CORNER_16;
    }
    return layout;
}

#pragma mark - UIGestureRecognizerDelegate
/**
 * 解决外界上滑时候 无法滑动的问题
 * 这个方法是用来处理多手势共存的，返回NO则响应一个手势，返回YES为同时响应
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    CGPoint translation = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:self];
    // 如果translation.y的绝对值大于translation.x的绝对值就可以看成是上下方向
    if(fabs(translation.y) > fabs(translation.x)){
        return true;
    }
    return false;
}

#pragma mark - 手势单击事件

/**
 * 单击事件回调
 */
- (void)tapTheContentPage
{
    if([self.delegate respondsToSelector:@selector(easyCard:itemClickWithIndex:)]){
        [self.delegate easyCard:self itemClickWithIndex:self.currentMainImgDataIndex];
    }
}

#pragma mark - 手势拖动事件

- (void)panTheContentPage:(UIPanGestureRecognizer*)gesture
{
    CGPoint point = [gesture translationInView:gesture.view];
    if(self.isInEndPageAnimation){
        [gesture setTranslation:CGPointZero inView:gesture.view];
        return;
    }
    if(self.canLoop){
        if(!self.dataSupportLoop){
            [gesture setTranslation:CGPointZero inView:gesture.view];
            return;
        }
    }else{
        if(self.loopList.count <= 1){
            [gesture setTranslation:CGPointZero inView:gesture.view];
            return;
        }
    }
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            if([self.delegate respondsToSelector:@selector(easyCard:willBeginScrollWithIndex:)]){
                [self.delegate easyCard:self willBeginScrollWithIndex:self.currentMainImgDataIndex];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self panMoveWithPoint:point];
        }
            
            break;
        case UIGestureRecognizerStateEnded:
        {
            // 速递
            CGPoint finalpoint = [gesture velocityInView:self];
            [self endMoveWithvelocity:finalpoint];
        }
            
            break;
        case UIGestureRecognizerStateCancelled:
        {
            CGPoint finalpoint = [gesture velocityInView:self];
            [self endMoveWithvelocity:finalpoint];
        }
            
            break;
        case UIGestureRecognizerStateFailed:
            
            break;
            
        default:
            break;
    }
}

#pragma mark - 正在滑动手势处理
/**
 * 正在拖动的过程
 * @note 在支持无限轮回滑动的情况下，每个view的tag值会切换
 * @note 在不轮回滑动的情况下，只是根据当前的主index，判断是否距离支持滑动，内部的布局和滑动逻辑与上面保持一致
 */
- (BOOL)panMoveWithPoint:(CGPoint)point
{
    // 支持循环的情况下
    // 向右滑动
    if(point.x > 0){
        // 如果当前是第一张，则无法在继续右滑
        if(!self.canLoop && self.currentMainImgDataIndex == 0){
            return false;
        }
        if(self.trunScrollToLeft){
            self.hadTransZIndex = false;
            self.trunScrollToLeft = false;
        }
        // 将最底部的图片提到最上面，做右滑操作
        LGScrollCardImgView *botImageView = [self.contentView viewWithTag:self.overloopCount+1];
        if(!self.hadTransZIndex){
            // 修改器内部图片的位置
            [botImageView setPosition:-1];
            CGRect botImageFrame = botImageView.frame;
            botImageFrame.origin.x = -botImageFrame.size.width;
            botImageView.frame = botImageFrame;
            [self.contentView bringSubviewToFront:botImageView];
            
            // 重置图片，默认为currentMainImgDataIndex + 1 + 1
            NSString *imgData = [self getTempShowImgDataIsTurnToLeft:false];
            botImageView.imgUrl = imgData;
            
            self.currentPanImgView = botImageView;
            self.hadTransZIndex = true;
        }
        CGRect botImageFrame = botImageView.frame;
        // 这里用1.5是想右滑的时候，页面往右出现的更快一些
        botImageFrame.origin.x = (-botImageFrame.size.width + point.x * 1.5);
        botImageView.frame = botImageFrame;
        CGFloat positionScale = fabs(point.x) * 1.5 / botImageFrame.size.width;
        if(positionScale > 1)positionScale = 1;
        // 其他的只需要更新内部的position即可
        [self updateOtherImagePositionWithoutTag:self.overloopCount+1 positionScale:positionScale];
    }else{
        if(!self.canLoop && self.currentMainImgDataIndex == self.cardList.count-1){
            return false;
        }
        if(!self.trunScrollToLeft){
            self.hadTransZIndex = false;
            self.trunScrollToLeft = true;
        }
      LGScrollCardImgView *topImageView = [self.contentView viewWithTag:1];
        if(!self.hadTransZIndex){
          LGScrollCardImgView *botImageView = [self.contentView viewWithTag:self.overloopCount+1];
            [botImageView setPosition:self.overloopCount];
            botImageView.frame = self.bounds;
            [self.contentView sendSubviewToBack:botImageView];
            [self.contentView bringSubviewToFront:topImageView];
            
            // 重置图片，默认为currentMainImgDataIndex + 1 + 1
            NSString *imgData = [self getTempShowImgDataIsTurnToLeft:true];
            // 为nil说明是非轮回滑动的情况，在超出图片展示下标位置的时候，隐藏图片即可达到这种效果
            if(imgData == nil){
                botImageView.imgUrl = nil;
            }else{
                botImageView.imgUrl = imgData;
            }
            self.currentPanImgView = topImageView;
            self.hadTransZIndex = true;
        }
        // 计算向左滑动的position
        CGRect topImageFrame = topImageView.frame;
        topImageFrame.origin.x = point.x;
        topImageView.frame = topImageFrame;
        // 其他的只需要更新内部的position即可
        CGFloat positionScale = fabs(point.x) * 1.5 / topImageFrame.size.width;
        if(positionScale > 1)positionScale = 1;
        [self updateOtherImagePositionWithoutTag:1 positionScale:-positionScale];
    }
    return true;
    
}

/**
 * 从左至右滑的时候，根据当前主下标获取上一张图的数据
 * 从右至左滑的时候，则获取的是主下标 下一张图的数据
 */
- (NSString*)getTempShowImgDataIsTurnToLeft:(BOOL)isTurnToLeft
{
    NSInteger index = 0;
    if(isTurnToLeft){
        index = self.currentMainImgDataIndex + self.overloopCount;
        if(index > self.cardList.count - 1){
            if(!self.canLoop){
                return nil;
            }
            index = index - (self.cardList.count-1) - 1;
        }
    }else{
        index = self.currentMainImgDataIndex - 1;
        if(index < 0){
            index = self.cardList.count-1;
        }
    }
    return self.cardList[index];
}

/**
 * 在轮回滑动过程中更新其他图片view的内部image的position
 * @param tag 顶部参与移动的view的tag
 * @param positionScale 移动的一个比例 负数表示向左滑动 正数表示向右滑动
 */
- (void)updateOtherImagePositionWithoutTag:(NSInteger)tag positionScale:(CGFloat)positionScale
{
    for (LGScrollCardImgView *imgView in self.contentView.subviews) {
        if(imgView.tag != tag){
            imgView.position = imgView.tag-1 + positionScale;
        }
    }
}

#pragma mark - 结束滑动处理
/**
 * 结束拖动
 * @param velocity 惯性速度
 */
- (void)endMoveWithvelocity:(CGPoint)velocity
{
    // 做一个容错处理，判断是否存在拖动的view
    if(!self.currentPanImgView)return;
    self.isInEndPageAnimation = true;
    // 根据滑动停止后的位置 和 速度判断
    // 假设滑动的距离超过了本身宽度的40%，则就算滑过一次动作
    // 假设滑动速率的绝对值超过200，则也算滑过一次动作
    // 当左滑的时候 frame.orgin.x的大小为滑动的距离；当右滑的时候，滑动的距离为宽度加上frame.orgin.x值
    CGRect panImgFrame = self.currentPanImgView.frame;
    CGFloat moveMargin = 0;
    if(self.trunScrollToLeft){
        moveMargin = fabs(self.currentPanImgView.frame.origin.x);
    }else{
        moveMargin = panImgFrame.origin.x + panImgFrame.size.width;
    }
    // 是否可以算作一次滑动
    BOOL canContinueScroll = false;
    if(moveMargin >= panImgFrame.size.width * self.scrollPanMinScale){
        canContinueScroll = true;
    }else{
        if(fabs(velocity.x) >= self.scrollPanMinVelocity){
            canContinueScroll = true;
        }
    }
    // 结束时候的目标frame
    CGRect destinationFrame = panImgFrame;
    // imageview 内部的position,只有成功执行滚动操作的时候才需要更新为新值
    // 当往左滑动时，其他的position-1，往右则position+1
    CGFloat postion_value = 0;
    if(canContinueScroll){
        if(self.trunScrollToLeft){
            destinationFrame.origin.x = -panImgFrame.size.width;
            postion_value = -1;
        }else{
            destinationFrame.origin.x = 0;
            postion_value = 1;
        }
    }else{
        if(self.trunScrollToLeft){
            destinationFrame.origin.x = 0;
        }else{
            destinationFrame.origin.x = -panImgFrame.size.width;
        }
    }
    NSInteger currentPanTag = self.currentPanImgView.tag;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.currentPanImgView.frame = destinationFrame;
        // 更新其他 imgview的内部position
        [self updateOtherImagePositionWithoutTag:currentPanTag positionScale:postion_value];
    } completion:^(BOOL finished) {
        [self updateImgViewFrameWhenEndWithContinue:canContinueScroll];
        // 结束一次拖动事件后，重置hadTransZIndex
        self.hadTransZIndex = false;
        self.isInEndPageAnimation = false;
    }];
}

/**
 * 在结束滚动并结束动画的时候 重置frame
 * @param isContinue 是否能继续执行滑动
 */
- (void)updateImgViewFrameWhenEndWithContinue:(BOOL)isContinue
{
    /// 当是轮回滑动的情况下，需要重置tag、并切换试图ZIndex
    if(!isContinue)return;
    [self updateImgViewTranszationEndWithIsTurnLeft:self.trunScrollToLeft];
    // 更新当前主图展示的下标
    [self updateCurrentMainImgIndex];
    // 清除当前的拖动view
    self.currentPanImgView = nil;
}

/**
 * 结束滑动时候更新img的tag值以及zindex位置
 */
- (void)updateImgViewTranszationEndWithIsTurnLeft:(BOOL)turnLeft {
    
    // 当向左滑动的时候，
    // 1、需要将self.currentPanImgView的移动到最底层,设置istemp属性为true，
    // 2、将最倒数第二层的imgView的istemp属性设置为false
    // 3、更新contentview内的所有imgview的tag值
    if(turnLeft){
        [self removeAllTempSignWhenEnd];
        self.currentPanImgView.istemp = true;
        [self.contentView sendSubviewToBack:self.currentPanImgView];
        // 更新其他的tag
        [self updateAllImgViewTagWithScrollToLeft:turnLeft withoutTag:self.currentPanImgView.tag];
        // 再更新当前拖动的imgview的tag
        self.currentPanImgView.tag = self.overloopCount + 1;
    }else{
        // 先将当前拖动的view的istemp设置为false
        self.currentPanImgView.istemp = false;
        [self updateAllImgViewTagWithScrollToLeft:turnLeft withoutTag:self.currentPanImgView.tag];
        self.currentPanImgView.tag = 1;
        [self updateTempValueWhenAfterUpdateTag];
    }
}

// 在执行一次完整的滑动事件后，更新当前的主图index
- (void)updateCurrentMainImgIndex
{
    int index_value = self.trunScrollToLeft ? 1 : -1;
    NSInteger mainIndex = self.currentMainImgDataIndex + index_value;
    if(mainIndex < 0){
        mainIndex = self.cardList.count-1;
    }else if(mainIndex >= self.cardList.count){
        mainIndex = 0;
    }
    // 回调出去
    if([self.delegate respondsToSelector:@selector(easyCard:willEndScrollFromIndex:toIndex:)]){
        [self.delegate easyCard:self willEndScrollFromIndex:self.currentMainImgDataIndex toIndex:mainIndex];
    }
    self.currentMainImgDataIndex = mainIndex;
}

/**
 * 清除所有的temp标记
 */
- (void)removeAllTempSignWhenEnd
{
    for (LGScrollCardImgView *imgView in self.contentView.subviews) {
        imgView.istemp = false;
    }
}
/**
 * 根据滑动方向更新tag值
 */
- (void)updateAllImgViewTagWithScrollToLeft:(BOOL)scrollToLeft withoutTag:(NSInteger)tag
{
    NSInteger tag_value = scrollToLeft ? -1 : 1;
    for (LGScrollCardImgView *imgView in self.contentView.subviews) {
        if(imgView.tag != tag){
            imgView.tag += tag_value;
        }
    }
}

// 在更新完tag后更新temp属性
// temp属性主要是在imgview内部position内部位移设置用的
- (void)updateTempValueWhenAfterUpdateTag
{
    for (LGScrollCardImgView *imgView in self.contentView.subviews) {
        if(imgView.tag == self.overloopCount + 1){
            imgView.istemp = true;
        }
    }
}

@end

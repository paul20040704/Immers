//
//  SVResourceHeadView.h
//  Immers
//
//  Created by ssv on 2022/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVResourceHeadView : UIView
@property (nonatomic,copy)void (^clickAction)(NSInteger index);//0 图片/1 视频/ 2 选择/取消选择
- (void)resetSelectStatus;
@end

NS_ASSUME_NONNULL_END

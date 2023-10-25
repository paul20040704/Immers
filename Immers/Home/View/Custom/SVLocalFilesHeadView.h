//
//  SVLocalFilesHeadView.h
//  Immers
//
//  Created by developer on 2022/11/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVLocalFilesHeadView : UIView
@property (nonatomic,copy)void (^clickAction)(NSInteger index);//0 选择/取消选择 1 本地/2 U盘/
- (void)resetSelectStatus;
@end

NS_ASSUME_NONNULL_END

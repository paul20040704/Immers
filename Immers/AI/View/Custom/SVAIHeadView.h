//
//  SVAIHeadView.h
//  Immers
//
//  Created by Paul on 2023/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVAIHeadView : UIView
@property (nonatomic,copy)void (^clickAction)(NSInteger index, NSString *keyword);//0 选择/取消选择 /1 搜尋

@property (nonatomic, strong) UITextField *searchTextFeild;

- (void)resetSelectStatus;
@end

NS_ASSUME_NONNULL_END

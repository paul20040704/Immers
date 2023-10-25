//
//  SVLocalFileBottomView.h
//  Immers
//
//  Created by developer on 2022/11/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVLocalFileBottomView : UIView
@property (nonatomic,copy)void (^addAction)(void);
@property (nonatomic,copy)void(^deleteAction)(void);
@property (nonatomic,assign)NSInteger storageType;//1本地、2U盘
- (void)updateSize:(NSString *)text;
- (void)changeSelectStatus:(BOOL )showSelect;
@end

NS_ASSUME_NONNULL_END

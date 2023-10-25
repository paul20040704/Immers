//
//  SVEventButton.h
//  Immers
//
//  Created by developer on 2022/10/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVEventButton : UIButton

+ (instancetype)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName sizeType:(NSInteger )sizeType;//0 :首页设置/文件/播放... 1:首页控制

@property (nonatomic, assign) NSInteger count;

@end

NS_ASSUME_NONNULL_END

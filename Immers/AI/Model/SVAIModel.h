//
//  SVAIModel.h
//  Immers
//
//  Created by Paul on 2023/7/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVAIModel : NSObject

/// 链接
@property (nonatomic, strong) UIImage *image;
/// 是否显示 选中 icon
@property (nonatomic, assign) BOOL show;
/// 是否选中
@property (nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END

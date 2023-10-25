//
//  SVPhotoFrameView.h
//  Immers
//
//  Created by developer on 2022/9/13.
//

#import <UIKit/UIKit.h>
#import "SVGlobalMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVPhotoFrameView : UIView

@property (nonatomic, assign) BOOL selectAll;
@property (nonatomic, assign) BOOL submitAble;
@property (nonatomic, assign) BOOL selectAble;
@property (nonatomic, assign) SVButtonEvent eventType;
/// 回调
@property (nonatomic, copy) void(^frameEventCallback)(SVButtonEvent event);

@end

NS_ASSUME_NONNULL_END

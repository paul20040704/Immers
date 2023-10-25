//
//  LGScrollCardLayout.h
//  SonkwoApp
//
//  Created by zdby on 2022/6/21.
//  Copyright © 2022 ceasia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface LGScrollCardLayout : NSObject
@property (nonatomic,assign)NSInteger overloopCount;
@property (nonatomic,assign)CGFloat lineMargin;
@property (nonatomic,assign)CGFloat rowMargin;
@property (nonatomic,assign)CGFloat maxCornerRadius;
@property (nonatomic,assign)CGFloat minCornerRadius;

@end

NS_ASSUME_NONNULL_END

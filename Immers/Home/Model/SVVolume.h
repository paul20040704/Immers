//
//  SVVolume.h
//  Immers
//
//  Created by developer on 2022/11/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVVolume : NSObject
/// 当前音量
@property (nonatomic, assign) NSInteger currentVolume;
/// 最大音量
@property (nonatomic, assign) NSInteger maxVolume;
/// 最小音量
@property (nonatomic, assign) NSInteger minVolume;
@end

NS_ASSUME_NONNULL_END

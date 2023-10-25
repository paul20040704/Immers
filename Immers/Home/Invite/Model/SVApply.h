//
//  SVApply.h
//  Immers
//
//  Created by developer on 2023/3/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVApply : NSObject

@property (nonatomic, copy) NSString *applyEmail;
@property (nonatomic, copy) NSString *applyHeadUrl;
@property (nonatomic, copy) NSString *applyName;

@property (nonatomic, copy) NSString *applyPhone;
@property (nonatomic, copy) NSString *applyUserId;

@property (nonatomic, copy) NSString *explain;
@property (nonatomic, copy) NSString *framePhotoName;

/// 申请id
@property (nonatomic, copy) NSString *aid;
/// 状态
@property (nonatomic, assign) NSInteger status;


@end

NS_ASSUME_NONNULL_END

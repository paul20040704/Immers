//
//  SVApns.h
//  Immers
//
//  Created by developer on 2023/3/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//aps =     {
//    alert = "hhhInvite you to join his photo frame\U201cholo1\U201cPlease go to handle it";
//    badge = 1;
//    sound = happy;
//};


@interface SVAps : NSObject

@property (nonatomic, copy) NSString *alert;

@end

@interface SVApns : NSObject

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *msgId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *framePhotoId;
@property (nonatomic, strong) SVAps *aps;

@end

NS_ASSUME_NONNULL_END

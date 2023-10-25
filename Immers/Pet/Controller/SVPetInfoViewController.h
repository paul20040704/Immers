//
//  SVPetInfoViewController.h
//  Immers
//
//  Created by ssv on 2022/11/10.
//

#import "SVBaseViewController.h"
#import "SVPetModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVPetInfoViewController : SVBaseViewController
@property (nonatomic,strong) SVPetModel *petModel;
@property (nonatomic,copy) NSString *deviceId;
@end

NS_ASSUME_NONNULL_END

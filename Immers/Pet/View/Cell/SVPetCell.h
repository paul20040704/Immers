//
//  SVPetCell.h
//  Immers
//
//  Created by ssv on 2022/11/14.
//

#import "SVCollectionViewCell.h"
#import "SVPetModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVPetCell : SVCollectionViewCell
@property (nonatomic,strong)SVPetModel *petModel;
@property (nonatomic,assign)NSInteger percent;//进度 -1代表相框没有该资源组下载任务
@property (nonatomic,copy) void(^clickAction)(NSInteger type);//0 领养 1 取消领养 2 重新领养
@end

NS_ASSUME_NONNULL_END

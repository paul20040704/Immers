//
//  SVResourceModel.h
//  Immers
//
//  Created by ssv on 2022/11/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVResourceModel : NSObject
/// 内容名称
@property (nonatomic, copy) NSString *name;
/// 资源类型
@property (nonatomic, copy) NSString *type;//0图片，1视频
/// 资源大小
@property (nonatomic, copy) NSString *uploadSize;
/// 链接
@property (nonatomic, copy) NSString *uploadUrl;
/// 封面图
@property (nonatomic, copy) NSString *coverPicture;
/// 是否显示 选中 icon
@property (nonatomic, assign) BOOL show;
/// 是否选中
@property (nonatomic, assign) BOOL selected;
@end

NS_ASSUME_NONNULL_END

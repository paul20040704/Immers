//
//  SVPickerViewController.h
//  Immers
//
//  Created by Paul on 2023/7/27.
//

#import <UIKit/UIKit.h>
#import "SVCodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVChooseViewController : UIViewController

///區碼模型
@property (nonatomic, strong) NSArray *codeModelArray;

/// 選擇區碼事件 回调
@property (nonatomic, copy) void(^codeCallback)(SVCodeModel* codeModel);

@end

NS_ASSUME_NONNULL_END

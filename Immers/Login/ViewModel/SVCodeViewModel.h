//
//  SVCodeViewModel.h
//  Immers
//
//  Created by Paul on 2023/7/27.
//

#import "SVBaseViewModel.h"
#import "SVCodeModel.h"
#import "SVNumberModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVCodeViewModel : SVBaseViewModel
                                 
@property (nonatomic,strong)NSMutableArray<SVCodeModel *> *codeModel;//區碼列表

//取得手機國碼
- (void)getCode:(SVSuccessCompletion)completion;

typedef void(^CodeSuccessCompletion)(BOOL isSuccess, NSString * _Nullable code, NSString * _Nullable number);
//取得國際手機標準格式
- (void)getNationalNumber:(NSDictionary *)parameters completion:(CodeSuccessCompletion)completion;

@end

NS_ASSUME_NONNULL_END

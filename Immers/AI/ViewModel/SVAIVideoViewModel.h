//
//  SVAIVideoViewModel.h
//  Immers
//
//  Created by Paul on 2023/8/10.
//

#import "SVBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVAIVideoViewModel : SVBaseViewModel
@property (nonatomic,strong)NSMutableArray<NSString *> *uuids;//AI影片Id

//取得AI影片
- (void)getAIVideo:(NSData *)data text:(NSString *)text voiceType:(NSString *)type completion:(SVSuccessCompletion)completion;

//取得合成影片狀態
- (void)getVideoProcess:(NSString *)paramter completion:(SVSuccessCompletion)completion;

//取得特定條件語句
-(void)getSentences:(NSString *)type completion:(SVSuccessCompletion)completion;
@end

NS_ASSUME_NONNULL_END

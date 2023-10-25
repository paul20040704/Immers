//
//  SVCodeModel.h
//  Immers
//
//  Created by Paul on 2023/7/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVCodeModel : NSObject

//國家代號
@property (nonatomic, copy) NSString *countryID;
//國家國碼
@property (nonatomic, copy) NSString *countryCode;
//國家名稱
@property (nonatomic, copy) NSString *fullname;

@end

NS_ASSUME_NONNULL_END

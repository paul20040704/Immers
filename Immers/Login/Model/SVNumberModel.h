//
//  SVNumberModel.h
//  Immers
//
//  Created by Paul on 2023/8/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVNumberModel : NSObject

//國家國碼
@property (nonatomic, copy) NSString *countryCode;
//國際標準號碼
@property (nonatomic, copy) NSString *nationalNumber;

@end

NS_ASSUME_NONNULL_END

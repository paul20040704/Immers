//
//  SVCodeViewModel.m
//  Immers
//
//  Created by Paul on 2023/7/27.
//

#import "SVCodeViewModel.h"

@implementation SVCodeViewModel

//取得國碼
- (void)getCode:(SVSuccessCompletion)completion {
    NSURL *url = [NSURL URLWithString:@"https://frontend-api.nuwo.ai/api/countries/summary"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
    //[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            //請求失敗
            DebugLog(@"Error: %@", error.localizedDescription);
            completion(NO, error.localizedDescription);
        }else {
            NSError *jsonError;
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            [self.codeModel removeAllObjects];
            for (NSDictionary *codeDict in jsonArray) {
                SVCodeModel *model = [[SVCodeModel alloc]init];
                model.countryID = codeDict[@"id"];
                model.countryCode = codeDict[@"countryCode"];
                model.fullname = codeDict[@"fullname"];
                [self.codeModel addObject:model];
            }
            completion(YES, nil);
        }
    }];
    [dataTask resume];
}

//取得國際手機標準格式
- (void)getNationalNumber:(NSDictionary *)parameters completion:(CodeSuccessCompletion)completion {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:@"https://frontend-api.nuwo.ai/api/phone-numbers/national-number"];
    
    NSMutableArray *queryItems = [NSMutableArray array];
    for (NSString *key in parameters) {
        NSString *value = parameters[key];
        NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:key value:value];
        [queryItems addObject:queryItem];
    }
    urlComponents.queryItems = queryItems;
    
    NSURL *url = urlComponents.URL;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            //請求失敗
            DebugLog(@"Error: %@", error.localizedDescription);
            completion(NO, error.localizedDescription, @"");
        }else {
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            NSString *code = jsonDict[@"countryCode"];
            NSString *number = jsonDict[@"nationalNumber"];
            completion(YES, code, number);
        }
    }];
    [dataTask resume];
}



// MARK: - Lazy
- (NSMutableArray<SVCodeModel *> *)codeModel {
    if(!_codeModel){
        _codeModel = @[].mutableCopy;
    }
    return _codeModel;
}

@end

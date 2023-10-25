//
//  SVAIViewModel.m
//  Immers
//
//  Created by Paul on 2023/7/21.
//

#import "SVAIViewModel.h"

@implementation SVAIViewModel


//取得AI圖片
- (void)getAIResources:(NSString *)paramter completion:(SVSuccessCompletion)completion {
    NSURL *url = [NSURL URLWithString:@"http://20.239.190.62:4000/txt2img"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSDictionary *params = @{@"prompt": paramter,
                             @"batch_size": @"6",
                             @"height": @"640",
                             @"width": @"480"
    };
    NSError *error;
    if (error) {
        //JSON編碼失敗
        DebugLog(@"JSON Error: %@", error.localizedDescription);
        completion(NO, error.localizedDescription);
    }
    
    
    NSString *boundary = @"Boundary1234567890";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    // 構建 HTTP body
    NSMutableData *httpBody = [NSMutableData data];
    // 添加參數到 HTTP body
    [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    // 添加結束符號
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    request.HTTPBody = httpBody;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            //請求失敗
            DebugLog(@"Error: %@", error.localizedDescription);
            completion(NO, error.localizedDescription);
        }else {
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            NSArray *imageArray = jsonDict[@"images"];
            [self.resources removeAllObjects];
            for (NSString *imageString in imageArray){
                SVAIModel *model = [[SVAIModel alloc] init];
                NSData *imageData = [[NSData alloc] initWithBase64EncodedString:imageString options:NSDataBase64DecodingIgnoreUnknownCharacters];
                model.image = [UIImage imageWithData:imageData];
                model.show = NO;
                model.selected = NO;
                [self.resources addObject:model];
            }
            completion(YES, nil);
        }
    }];
    [dataTask resume];
}


// MARK: - Lazy
- (NSMutableArray<SVAIModel *> *)resources {
    if(!_resources){
        _resources = @[].mutableCopy;
    }
    return _resources;
}

- (NSMutableArray <SVAIModel *> *)selectResources {
    if(!_selectResources){
        _selectResources = @[].mutableCopy;
    }
    return  _selectResources;
}
@end

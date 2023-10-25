//
//  SVAIVideoViewModel.m
//  Immers
//
//  Created by Paul on 2023/8/10.
//

#import "SVAIVideoViewModel.h"
#import <Photos/Photos.h>

@implementation SVAIVideoViewModel 

//取得AI影片
- (void)getAIVideo:(NSData *)data text:(NSString *)text voiceType:(NSString *)type completion:(SVSuccessCompletion)completion {
    NSURL *url = [NSURL URLWithString:@"http://20.239.190.62:4000/img2video"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSArray *words = @[@"en-US-", type, @"Neural"];
    NSString *setence = [words componentsJoinedByString:@""];
    
    NSDictionary *params = @{@"text": text,
                             @"voice": setence,
    };
    
    NSString *boundary = @"BoundaryString";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    if (data) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"file.png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:data];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    // 添加參數到 HTTP body
    [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    request.HTTPBody = body;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            //請求失敗
            DebugLog(@"Error: %@", error.localizedDescription);
            completion(NO, error.localizedDescription);
        }else {
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            NSLog(@"%@", jsonDict[@"data"]);
            completion(YES, jsonDict[@"data"]);
        }
    }];
    [dataTask resume];
}

//取得合成影片狀態
- (void)getVideoProcess:(NSString *)paramter completion:(SVSuccessCompletion)completion {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:@"http://20.239.190.62:4000/video"];
    urlComponents.queryItems = @[[NSURLQueryItem queryItemWithName:@"uuid" value:paramter]];
    
    NSURL *url = urlComponents.URL;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            //請求失敗
            DebugLog(@"Error: %@", error.localizedDescription);
            completion(NO, error.localizedDescription);
        }else {
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            NSDictionary *dict = jsonDict[@"data"];
            NSString *status = dict[@"status"];
            NSString *url = dict[@"url"];
            if ([status isEqual: @"process"]){
                completion(NO, @"process");
            }else if ([status isEqual:@"success"]){
                NSLog(@"%@", status);
                [self downloadVideoFromURL:url];
                completion(YES, nil);
            }else {
                NSLog(@"%@", status);
                completion(YES, nil);
            }
        }
    }];
    [dataTask resume];
}

//下載影片
-(void)downloadVideoFromURL:(NSString *)urlStr {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:urlStr];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"tempFile.mp4"];
        
        [data writeToFile:filePath atomically:YES];
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:filePath]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    [SVProgressHUD showInfoWithStatus:SVLocalized(@"ai_video_success")];
                    NSLog(@"downloadVideoFromURL success.");
                }else {
                    [SVProgressHUD showInfoWithStatus:SVLocalized(@"ai_video_fail")];
                    NSLog(@"downloadVideoFromURL fail.");
                }
            });
        }];
    });
}

//取得特定條件語句
-(void)getSentences:(NSString *)type completion:(SVSuccessCompletion)completion {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:@"https://frontend-api.nuwo.ai/api/sentence"];
    
    NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:@"SentenceType" value:type];
    urlComponents.queryItems = @[queryItem];
    
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
            completion(NO, error.localizedDescription);
        }else {
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            NSString *text = jsonDict[@"sentence"];
            completion(YES, text);
        }
    }];
    [dataTask resume];
}


// MARK: - Lazy
- (NSMutableArray<NSString *> *)uuids {
    if(!_uuids){
        _uuids = @[].mutableCopy;
    }
    return _uuids;
}

@end

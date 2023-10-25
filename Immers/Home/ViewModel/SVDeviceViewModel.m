//
//  SVDeviceViewModel.m
//  Immers
//
//  Created by developer on 2022/5/18.
//

#import "SVDeviceViewModel.h"
#import "SVDeviceService.h"
#import "SVFileService.h"
#import "SVGlobalMacro.h"

@implementation SVDeviceViewModel
{
    SVResultCompletion  _fileOtherCompletion;
}
/// 用户设备列表
- (void)devicesCompletion:(SVSuccessCompletion)completion {
    [SVDeviceService devicesCompletion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            [self.devices removeAllObjects];
            [self.devices addObjectsFromArray:[NSArray yy_modelArrayWithClass:[SVDevice class] json:info]];
            completion(YES, nil);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 绑定设备
- (void)bindDevice:(NSDictionary *)parameters completion:(SVCodeCompletion)completion {
    [SVDeviceService bindDevice:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        0 == errorCode ? completion(errorCode, SVLocalized(@"tip_binding_succeed")) : completion(errorCode, info[KErrorMsg]);
    }];
}

/// 解绑设备
- (void)unbindDevice:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVDeviceService unbindDevice:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        0 == errorCode ? completion(YES, SVLocalized(@"tip_unbinding_succeed")) : completion(NO, info[KErrorMsg]);
    }];
}

/// 设备信息
- (void)deviceInfo:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVDeviceService deviceInfo:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            SVSettings *settings0 = self.settings.firstObject;
            settings0.text = info[@"name"];
            SVSettings *noNetsettings0 = self.noNetSettings.firstObject;
            noNetsettings0.text = info[@"name"];
            
            NSInteger surplusCapacity = [info[@"surplusCapacity"] integerValue];
            NSInteger totalCapacity = [info[@"totalCapacity"] integerValue];
            
            SVSettings *setting1 = self.settings.lastObject;
            setting1.text = [NSString stringWithFormat:SVLocalized(@"home_remained"), [self byte2gb:surplusCapacity], [self byte2gb:totalCapacity]];
            SVSettings *noNetsettings1 = self.noNetSettings.lastObject;
            noNetsettings1.text = setting1.text;
            
            if (surplusCapacity < kNotStorage) { // 相框存储小于50M 弹提示
                NSString *deviceId = info[@"id"]?:@"";
                [[SVMQTTManager sharedManager] sendControl:@{ kCmd : @(SVMQTTCmdEventNotMoreStorage),kFromId:deviceId} handler:nil];
            }
            
            self.deviceData = [SVDeviceData yy_modelWithJSON:info];
            if (self.deviceData.isShare) {
                SVSettings *setting = self.settings[2];
                setting.title = [SVLanguage localizedForKey:@"home_exit_device"];
            }

            completion(YES, [NSString stringWithFormat:@"%@", info[@"onlineStatus"]]);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 设备信息/在线状态
/// @param parameters 参数
/// @param completion 完成回调
- (void)deviceStatus:(NSDictionary *)parameters completion:(SVCodeCompletion)completion {
    [SVDeviceService deviceInfo:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            // 0: 未绑定 1:别人绑定(跳转申请加入界面) 2:自己绑定, 3:别人绑定
            NSInteger status = [info[@"bindStatus"] integerValue];
            if (0 == status) {
                completion(errorCode, [NSString stringWithFormat:@"%@", info[@"onlineStatus"]]);
            } else if (1 == status) {
                completion(-19, nil);
            } else {
                completion(-20, SVLocalized(@"home_device_has_bind"));
            }
            
        } else {
            completion(errorCode, info[KErrorMsg]);
        }
    }];
}

/// 设备存储空间
/// @param parameters 参数
/// @param completion 完成回调
- (void)deviceRAM:(NSDictionary *)parameters completion:(SVCodeCompletion)completion {
    [SVDeviceService deviceInfo:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            NSInteger surplusCapacity = [info[@"surplusCapacity"] integerValue];
            NSInteger totalCapacity = [info[@"totalCapacity"] integerValue];
           NSString *text = [NSString stringWithFormat:@"%@%.2fG/%@%.2fG",SVLocalized(@"home_used"),[self byte2gb:totalCapacity-surplusCapacity],SVLocalized(@"home_remaining"),[self byte2gb:surplusCapacity]];

            completion(errorCode, text);
        } else {
            completion(errorCode, info[KErrorMsg]);
        }
    }];
}

- (CGFloat)byte2gb:(NSInteger)byte {
    return byte / (1024 * 1024 * 1024.0);
}

/// 设备名称
- (void)deviceName:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVDeviceService deviceName:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            SVSettings *settings0 = self.settings.firstObject;
            settings0.text = info[@"framePhotoName"];
            completion(YES, nil);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

- (void)deviceOnline:(NSDictionary *)parameters completion:(SVResultCompletion)completion {
    [SVDeviceService deviceOnline:parameters completion:^(NSInteger errorCode, NSDictionary * _Nonnull info) {
        if (0 == errorCode) {
            NSNumber *online = (NSNumber *)info;
            completion(YES, nil,online);
        } else {
            completion(NO, info[KErrorMsg],nil);
        }
    }];
}

- (void)taskNum:(NSDictionary *)parameters completion:(SVResultCompletion)completion {
    [SVDeviceService taskNum:parameters completion:^(NSInteger errorCode, NSDictionary * _Nonnull info) {
        if (0 == errorCode) {
            NSNumber *online = (NSNumber *)info;
            completion(YES, nil,online);
        } else {
            completion(NO, info[KErrorMsg],nil);
        }
    }];
}

// MARK: - 图集

/// 增加设备图集
- (void)addGallery:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVDeviceService addGallery:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            SVAsset *asset = [SVAsset yy_modelWithJSON:info];
            asset.icon = @"home_file_image";
            [self.assets addObject: asset];
            completion(YES, nil);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 删除设备图集
- (void)removeGallery:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVDeviceService removeGallery:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        (0 == errorCode) ? completion(YES, SVLocalized(@"tip_delete_succeed")) : completion(NO, info[KErrorMsg]);
    }];
}

/// 设备的图集列表
- (void)galleries:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVDeviceService galleries:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            NSArray <NSDictionary *> *list = info[@"framePhotoGalleryVoList"];
            for (NSDictionary *dict in list) {
                SVAsset *asset = [SVAsset yy_modelWithJSON:dict];
                asset.icon = @"home_file_image";
                [self.assets addObject: asset];
            }
            completion(YES, nil);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 图集的图片（视频）
- (void)galleryImages:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVDeviceService galleryImages:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            NSArray <NSDictionary *> *list = info[@"uploadImgVoList"];
            if (list.count > 0) {
                [self.files addObjectsFromArray:[NSArray yy_modelArrayWithClass:[SVFile class] json:list]];
            }
            completion(YES, nil);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 获取相框下载列表
/// @param parameters 参数
/// @param completion 完成回调
- (void)tasks:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVDeviceService tasks:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            [self.downs removeAllObjects];
            [self.downs addObjectsFromArray:[NSArray yy_modelArrayWithClass:[SVDown class] json:info]];
            completion(YES, nil);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

// MARK: - 上传
/// 上传图片
- (void)uploadImage:(NSData *)data parameters:(NSDictionary *)parameters progress:(nullable void(^)(double uploadProgress))progress completion:(SVSuccessCompletion)completion {
    // 获取2转3 上传链接
    [SVDeviceService uploadApi:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            // 上传图片到台湾（2转3）
            NSString *type = parameters[@"fileType"];
            [SVFileService uploadURL:info[@"updateApi"] convertId:info[@"convertId"] image:data fileType:type progress:progress completion:^(NSString *path, BOOL isSuccess) {
                if (isSuccess) {
                    // 获取 图片密钥 key
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
                    [dict setValue:path ? : @"" forKey:@"token"];
                    if ([parameters[@"fileType"] isEqual:@"1"]) {
                        [dict setValue:@(0) forKey:@"type"];
                    }else {
                        [dict setValue:@(1) forKey:@"type"];
                    }
                    // 同步到深圳服务器
                    [self syncFile:dict completion:completion];
                    
                } else {
                    completion(NO, SVLocalized(@"tip_uploading_failed"));
                }
            }];
            
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 上传图片(视频)信息
- (void)syncFile:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVDeviceService syncFile:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        (0 == errorCode) ? completion(YES, parameters[@"token"]) : completion(NO, info[KErrorMsg]);
    }];
}

/// 删除图集的单（多）个图片（视频）
- (void)removeFiles:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVDeviceService removeFiles:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            NSMutableArray <NSString *> *ids = parameters[@"ids"];
            NSMutableArray <SVFile *> *removeFiles = [NSMutableArray arrayWithCapacity:ids.count];
            for (NSString *fid in ids) {
                for (SVFile *file in self.files) {
                    if ([file.fid isEqualToString:fid]) {
                        [removeFiles addObject:file];
                    }
                }
            }
            [self.files removeObjectsInArray:removeFiles];
            completion(YES, SVLocalized(@"tip_delete_succeed"));
        } else {
            completion(NO, info[KErrorMsg]);
        }
//        0 == errorCode ? completion(YES, @"删除成功") : completion(NO, info[KErrorMsg]);
    }];
}


/// 返回相框图片
- (void)framePhoto:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVDeviceService framePhoto:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            NSArray <NSDictionary *> *list = info[@"framePhotoVos"];
            if (![list isKindOfClass:[NSArray class]]) {
                completion(NO, info[KErrorMsg]);
                return;
            }
            NSInteger startPage = [parameters[@"startPage"] integerValue];
            if (1 == startPage) {
                [self.photos removeAllObjects];
            }
            if (list.count > 0) {
                [self.photos addObjectsFromArray:[NSArray yy_modelArrayWithClass:[SVPhoto class] json:list]];
            }
            completion(YES, info[@"totalPage"]);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 2转3 转换进度
/// @param urlString 路径
/// @param completion 完成回调
- (void)converted:(NSString *)urlString completion:(SVCodeCompletion)completion {
    [SVFileService converted:urlString completion:^(BOOL isSuccess, NSDictionary *info) {
        if (isSuccess) {
            // 0为等待，1为正在转换
            NSInteger code = [info[@"code"] integerValue];
            completion(code, [NSString stringWithFormat:@"%@", info[@"progress"]]);
        } else {
            completion(9999, SVLocalized(@"tip_request_failed"));
        }
    }];
}

// MARK: - 排序
/// 图集图片（视频）排序
- (void)sort:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVDeviceService sort:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            DebugLog(@"");
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}


// MARK: - 文件管理
/// 获取文件列表
///
- (void)localFiles:(BOOL )reload storageType:(NSInteger )storageType completion:(SVSuccessCompletion)completion {
    SVLocalFileRequest *request = (storageType==1)?self.localFile:self.usbFile;
    if (reload) {
        request.page = 1;
        request.noMoreData = NO;
    }else{
        request.page++;
    }
    NSDictionary *dict = @{ kCmd : @(SVMQTTCmdEventGetLocalFiles), kFromId : _deviceId?:@"",
                            kExt : @{kStorageType:@(request.storageType),kFileType:@(request.fileType),kPage:@(request.page),kSize:@(request.size),@"isGetPic":[NSNumber numberWithBool:false]}};
    
    [[SVMQTTManager sharedManager] sendControl:dict handler:^(NSError *error) {
        if (nil == error) {
            completion(YES,nil);
        }
    }];
}

- (void)requestLocalFiles:(SVSuccessCompletion)completion {
    kWself
    [[SVMQTTManager sharedManager] receiveMessage:[self hash] handler:^(NSDictionary * _Nonnull message) {
        kSself
        NSInteger cmd = [message[kCmd] integerValue];
        NSString *fromId = message[kFromId];
        if (![fromId isEqualToString:sself.deviceId]) {
            return;
        }
        if (cmd == SVMQTTCmdEventLocalFiles) {
            NSDictionary <NSString *, id> *ext = message[kExt];
            NSInteger storageType = [ext[kStorageType] integerValue];
            NSInteger totalSize = [ext[kTotalSize] integerValue];
            NSInteger page = [ext[kPage] integerValue];
            SVLocalFileRequest *request = (storageType==1)?wself.localFile:wself.usbFile;
            if (page==1) {
                [request.localFiles removeAllObjects];
            }
            if (page<=request.page) {
                [request.localFiles addObjectsFromArray:[NSArray yy_modelArrayWithClass:SVLocalFile.class json:ext[kList]]];
            }
            NSArray *arr = ext[kList];
            if ((totalSize<=request.localFiles.count)|| (request.localFiles.count%request.size!=0) || (arr.count==0)) {
                request.noMoreData = YES;
            }
            completion(YES,ext[kStorageType]);
        } else if (cmd == SVMQTTCmdEventDeleteLocalFilesRes){
            BOOL ext = message[kExt];
            if (ext) {
                [wself.localFile.localFiles removeObjectsInArray:wself.selectLocalFiles];
                [wself.usbFile.localFiles removeObjectsInArray:wself.selectLocalFiles];
            }
            if (sself->_fileOtherCompletion) {
                sself->_fileOtherCompletion(ext,nil,@{@"cmd":@(cmd)});
            }
        }else if (cmd == SVMQTTCmdEventAddFilesToPlayRes){
            BOOL ext = message[kExt];
            if (sself->_fileOtherCompletion) {
                sself->_fileOtherCompletion(ext,nil,@{@"cmd":@(cmd)});
            }
        }else if (cmd == SVMQTTCmdEventGetFilesCoverResult){
            NSDictionary *ext = message[kExt];
            NSInteger state = [(NSNumber *)ext[@"state"] integerValue];
            BOOL isLocal = [(NSNumber *)ext[@"isLocal"] boolValue];
            NSString *path = ext[@"path"];
            NSString *cover = ext[@"cover"];
            SVLocalFileRequest *request = (isLocal)?wself.localFile:wself.usbFile;
            [request.localFiles enumerateObjectsUsingBlock:^(SVLocalFile * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.path isEqualToString:path]) {
                    //获取封面成功
                    if (state==1) {
                        obj.cover = cover;
                        obj.getCoverState = 3;
                    }else{
                        //获取封面失败
                        obj.getCoverState = 2;
                    }
                    //返回获取封面结果
                    if (sself->_fileOtherCompletion) {
                        sself->_fileOtherCompletion(YES,nil,@{@"cmd":@(cmd),@"isLocal":@(isLocal),@"index":@(idx)});
                    }
                    *stop = YES;
                }
            }];

        }
    }];

}

- (void)localFileCover:(NSString *)path completion:(SVSuccessCompletion)completion {
    NSDictionary *dict = @{ kCmd : @(SVMQTTCmdEventGetFilesCover), kFromId : _deviceId?:@"",
                            kExt : @{@"path":path?:@""}};
    
    [[SVMQTTManager sharedManager] sendControl:dict handler:^(NSError *error) {
        if (nil == error) {
            completion(YES,nil);
        }
    }];
}

- (void)requestFileOtherResult:(SVResultCompletion)completion {
    _fileOtherCompletion = completion;
}

/// 删除本地文件
- (void)deleteLocalFile:(SVSuccessCompletion)completion {
    NSMutableArray *list = @[].mutableCopy;
    for (SVLocalFile *file in self.selectLocalFiles) {
        [list addObject:@{@"id":file.fileId,@"path":file.path}];
    }
    NSDictionary *dict = @{kCmd:@(SVMQTTCmdEventDeleteLocalFiles), kFromId : _deviceId?:@"", kExt:@{@"list":list}};
    [[SVMQTTManager sharedManager] sendControl:dict handler:^(NSError * _Nonnull error) {
        if (nil == error) {
            completion(YES,nil);
        }
    }];
}

/// 添加到播放列表
- (void)addFileToPlay:(SVSuccessCompletion)completion {
    NSMutableArray *list = @[].mutableCopy;
    for (SVLocalFile *file in self.selectLocalFiles) {
        [list addObject:@{@"id":file.fileId,@"path":file.path}];
    }
    NSDictionary *dict = @{kCmd:@(SVMQTTCmdEventAddFilesToPlay), kFromId : _deviceId?:@"", kExt:@{@"list":list}};
    [[SVMQTTManager sharedManager] sendControl:dict handler:^(NSError * _Nonnull error) {
        if (nil == error) {
            completion(YES,nil);
        }else {
            completion(NO,nil);
        }
    }];
}

// MARK: - lazy
/// 设置选项
- (NSArray<SVSettings *> *)settings {
    if (!_settings) {
        
        NSDictionary *dict0 = @{ @"title": SVLocalized(@"home_device_name"), @"sel" : @"setDeviceName:" };
        NSDictionary *dict1 = @{ @"title": SVLocalized(@"home_wifi_set_up"), @"sel" : @"setNetwork" };
        NSDictionary *dict2 = @{ @"title": SVLocalized(@"home_device_unbind"), @"sel" : @"unbindDevice" };
        NSDictionary *dict3 = @{ @"title": SVLocalized(@"home_power_off"), @"sel" : @"shutdown" };
        NSDictionary *dict4 = @{ @"title": SVLocalized(@"home_storage"), @"text" : @"0.0G/0.0G",@"sel" : @"toFileManager" };
        
        NSArray <NSDictionary *> *list = @[dict0, dict1, dict2, dict3, dict4];
        
        _settings = [NSArray yy_modelArrayWithClass:[SVSettings class] json:list];
        
    }
    return _settings;
}

- (NSArray<SVSettings *> *)noNetSettings {
    if (!_noNetSettings) {
        
        NSDictionary *dict0 = @{ @"title": SVLocalized(@"home_device_name"), @"sel" : @"setDeviceName:" };
        NSDictionary *dict1 = @{ @"title": SVLocalized(@"home_device_unbind"), @"sel" : @"unbindDevice" };
        NSDictionary *dict2 = @{ @"title": SVLocalized(@"home_power_off"), @"sel" : @"shutdown" };
        NSDictionary *dict3 = @{ @"title": SVLocalized(@"home_storage"), @"text" : @"0.0G/0.0G",@"sel" : @"toFileManager" };
        
        NSArray <NSDictionary *> *list = @[dict0, dict1, dict2, dict3];
        
        _noNetSettings = [NSArray yy_modelArrayWithClass:[SVSettings class] json:list];
        
    }
    return _noNetSettings;
}

/// 播放设置
- (NSArray<SVPlaySection *> *)sections {
    if (!_sections) {
        NSDictionary *dict0 = @{ @"icon" : @"image", @"text" : @"", @"title": SVLocalized(@"home_image_playback"), @"sel" : @"playImages" };
//        NSDictionary *dict1 = @{ @"icon" : @"video", @"title": SVLocalized(@"home_video_playback"), @"sel" : @"playVideos" };
        NSDictionary *dict2 = @{ @"icon" : @"time", @"title": SVLocalized(@"home_clock_mode"), @"sel" : @"playTimeMode" };
        NSDictionary *dict3 = @{ @"icon" : @"sort", @"title": SVLocalized(@"home_play_order"),  @"text" : @"", @"sel" : @"playSort:" };
        NSDictionary *dict4 = @{ @"icon" : @"gallery", @"title": SVLocalized(@"home_gallery"),  @"text" : @"", @"sel" : @"playSecondMode:" };
        
        NSDictionary *section0 = @{ @"title" : SVLocalized(@"home_playback_mode"), @"items" : @[dict0, /*dict1,*/ dict2] };
        NSDictionary *section1 = @{ @"title" : SVLocalized(@"home_my_setting"), @"items" : @[dict3, dict4] };
        
        _sections = [NSArray yy_modelArrayWithClass:[SVPlaySection class] json:@[section0, section1]];
    }
    return _sections;
}

- (NSMutableArray<SVAsset *> *)assets {
    if (!_assets) {
        _assets = [[NSMutableArray alloc] init];
    }
    return _assets;
}

- (NSMutableArray<SVDevice *> *)devices {
    if (!_devices) {
        _devices = [[NSMutableArray alloc] init];
    }
    return _devices;
}

- (NSMutableArray<SVFile *> *)files {
    if (!_files) {
        _files = [[NSMutableArray alloc] init];
    }
    return _files;
}

- (NSMutableArray<SVPhoto *> *)photos {
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}

- (NSMutableArray<SVDown *> *)downs {
    if (!_downs) {
        _downs = [[NSMutableArray alloc] init];
    }
    return _downs;
}

- (SVLocalFileRequest *)localFile {
    if (!_localFile) {
        _localFile = [[SVLocalFileRequest alloc] init];
        _localFile.localFiles = @[].mutableCopy;
        _localFile.page = 1;
        _localFile.storageType = 1;
        _localFile.size = 12;
        _localFile.fileType = 0;
    }
    return _localFile;;
}

- (SVLocalFileRequest *)usbFile {
    if (!_usbFile) {
        _usbFile = [[SVLocalFileRequest alloc] init];
        _usbFile.localFiles = @[].mutableCopy;
        _usbFile.page = 1;
        _usbFile.storageType = 2;
        _usbFile.size = 12;
        _usbFile.fileType = 0;
    }
    return _usbFile;
}

- (NSMutableArray<SVLocalFile *> *)selectLocalFiles {
    if (!_selectLocalFiles) {
        _selectLocalFiles = @[].mutableCopy;
    }
    return _selectLocalFiles;;
}

- (void)dealloc {
    [[SVMQTTManager sharedManager] removeHandler:[self hash]];
}
@end

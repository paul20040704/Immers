//
//  SVMQTTMacro.h
//  Immers
//
//  Created by developer on 2022/5/31.
//

#ifndef SVMQTTMacro_h
#define SVMQTTMacro_h

// TOPIC
/// 设备在线（设备端发布在线主题）
static NSString *const kMQTTTopicStatusOnline = @"/ssv/immers/online-status/online";

/// 设备离线（设备端用遗嘱机制发送离线主题）
static NSString *const kMQTTTopicStatusOffline = @"/ssv/immers/online-status/offline";

/// 手机操作设备（手机端发送操作命令给设备主题） ssv/immers/device/(deviceId)/操作
static NSString *const kMQTTTopicDevice = @"/ssv/immers/device/";

static NSString *const kCmd = @"cmd"; // 指令
static NSString *const kExt = @"ext"; // 扩展
static NSString *const kList = @"list"; // 列表
static NSString *const kFromId = @"fromId"; // 来源设备id
static NSString *const kPlayType = @"playType"; // 播放方式: 1:正常  2:时钟模式
static NSString *const kPlaySort = @"playSort"; // 播放顺序: 1:顺序播放 2:随机播放
static NSString *const kImageStayTime = @"imageStayTime"; // 图片停留时间
static NSString *const kPlayStatus = @"playStatus"; // 0:未播放 1:已经播放 2:暂停
static NSString *const kStorageType = @"storageType";//0:全部(包含SD卡内容) 1:本机内容 2:SD内容
static NSString *const kFileType = @"fileType";//0:全部 1:图片 2:视频

static NSString *const kTotalSize = @"totalSize"; // 总数量
static NSString *const kPage = @"page"; // 页码
static NSString *const kSize = @"size"; // 大小
static NSString *const kTitle = @"title"; // 标题
//static NSInteger const k

/// 事件类型
typedef NS_ENUM(NSInteger, SVMQTTCmdEvent) {
    // 在线状态
    SVMQTTCmdEventOnline = 100, // 设备在线
    SVMQTTCmdEventOffline = 101, // 设备离线
    // MARK: - 控制
    SVMQTTCmdEventVolumeUp = 200, // 音量+
    SVMQTTCmdEventVolumeDown = 201, // 音量-
    SVMQTTCmdEventFilePrevious = 202, // 上一张图片
    SVMQTTCmdEventFileNext = 203, // 下一张图片
    SVMQTTCmdEventFileChangeRes = 202203,//切换图片响应结果
    
    // MARK: - 设置
    SVMQTTCmdEventBind = 300, // 绑定
    SVMQTTCmdEventUnbindAndClear = 301, // 解绑并清除数据
    SVMQTTCmdEventUnbind = 3010, // 解绑不清除数据
    SVMQTTCmdEventOpenWiFi = 302, // 打开Wi-Fi
    SVMQTTCmdEventCloseWiFi = 303, // 关闭Wi-Fi
    SVMQTTCmdEventWiFiList = 304, // Wi-Fi列表
    SVMQTTCmdEventSetWiFi = 305, // 远程设置Wi-Fi
    SVMQTTCmdEventWiFiStatus = 306, // 相框连接Wi-Fi连接状态
    SVMQTTCmdEventPalyType = 3070, // 播放模式切换(13版本以上)
    SVMQTTCmdEventPalyTypeRes = 3071, // 播放模式切换结果(13版本以上)
    SVMQTTCmdEventRandom = 310, // 随机播放（图片/视频）
    SVMQTTCmdEventSort = 311, // 排序播放（图片/视频）
    SVMQTTCmdEventSortAny = 3100,//切换播放顺序(29版本以上)
    SVMQTTCmdEventSortAnyRes = 3101,//切换播放顺序结果(29版本以上)
    SVMQTTCmdEventPalyModeAny = 3120, //  图集模式（输入时间，单位毫秒）
    SVMQTTCmdEventPalyModeAnyResult = 3121, //  图集模式返回结果
    SVMQTTCmdEventNotStorage = 315, // 相框存储空间不足
    SVMQTTCmdEventNotMoreStorage = 3150, // 相框存储空间不足
    SVMQTTCmdEventRemoveImage = 316, // 删除图片
    SVMQTTCmdEventRemoveVideo = 317, // 删除视频
    SVMQTTCmdEventSyncFile = 318, // 同步上传图片视频
    SVMQTTCmdEventFileList = 3181, // 获取相框播放列表
    SVMQTTCmdEventRemoveFiles = 3182, // 删除播放(多个)
    SVMQTTCmdEventRemoveSuccess = 3183, // 删除成功
    SVMQTTCmdEventFilesSort = 3184, // 排序
    SVMQTTCmdEventSortSuccess = 3185, // 排序成功
    SVMQTTCmdEventEnter = 319, // 控制设备进入播放
    SVMQTTCmdEventEnterRes = 3191, // 控制设备进入播放结果返回
    SVMQTTCmdEventSingleCycle = 320, // 控制设备单个循环
    SVMQTTCmdEventQuit = 321, // 控制设备退出播放
    SVMQTTCmdEventStatus = 322, // 当前播放状态 // 0:未播放 1已经播放 2暂停
    SVMQTTCmdEventAllCycle = 323, // 控制设备全部循环
    SVMQTTCmdEventpause = 324, // 控制设备暂停播放
    SVMQTTCmdEventResume = 325, // 控制设备恢复播放
    
    SVMQTTCmdEventWiFiConnected = 401, // Wi-Fi连接成功
    SVMQTTCmdEventCancelSend = 402, // 取消发送401指令
    SVMQTTCmdEventReconnect = 403, // 重新配网 取消发送401指令
    
    SVMQTTCmdEventGetDeviceInfo = 500,// 手机端获取设备信息
    SVMQTTCmdEventDeviceInfo = 501,// 相框返回设备信息
    SVMQTTCmdEventShutdown = 600,// 设备关机
    
    SVMQTTCmdEventTaskCount = 701,// 获取相框上报下载任务数量和任务列表
    SVMQTTCmdEventTaskList = 7010,// 上报下载任务数量和任务列表
    SVMQTTCmdEventTaskDown = 702,// 上报下载任务情况
    
    SVMQTTCmdEventGetResourceGroupTaskList = 705,//获取资源组(宠物等)任务数量和任务列表
    SVMQTTCmdEventResourceGroupTaskList = 7050,//上报资源组(宠物等)任务数量和任务列表
    SVMQTTCmdEventResourceGroupProgress = 706,//上报资源组(宠物等)任务进度
    
    SVMQTTCmdEventGetLocalFiles = 801,// 手机获取设备文件列表
    SVMQTTCmdEventLocalFiles = 8010,// 设备返回文件列表
    SVMQTTCmdEventDeleteLocalFiles = 802,// 删除设备文件
    SVMQTTCmdEventDeleteLocalFilesRes = 8020,// 删除设备文件结果
    SVMQTTCmdEventAddFilesToPlay = 803,// 将设备文件添加到播放列表
    SVMQTTCmdEventAddFilesToPlayRes = 8030,// 将设备文件添加到播放列表结果
    SVMQTTCmdEventGetFilesCover = 805,// 获取文件封面
    SVMQTTCmdEventGetFilesCoverResult = 8050,// 获取文件封面结果
    
    SVMQTTCmdEventPlayResource = 901,//播放资源组(包括宠物)
    SVMQTTCmdEventPlayResourceResult = 9010,//播放资源组(包括宠物)结果
    SVMQTTCmdEventStopPlayResource = 902,//停止播放资源组(包括宠物)
    SVMQTTCmdEventStopPlayResourceResult = 9020,//停止播放资源组(包括宠物)结果
    SVMQTTCmdEventStartPlayResource = 908,//开始播放资源组(进入宠物详情)
    SVMQTTCmdEventStartPlayResourceResult = 9080,//开始播放资源组返回结果
};

#endif /* SVMQTTMacro_h */

//
//  SVDown.m
//  Immers
//
//  Created by developer on 2022/10/17.
//

#import "SVDown.h"
#import "SVGlobalMacro.h"

@implementation SVDown

+ (NSDictionary <NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"did" : @"id" };
}

/// 0: 失败  1: 完成  2: 停止  3: 等待  4:下载中  5:预处理 6:预处理完成 7:删除任务
- (NSString *)stateText {
    NSInteger state = self.state;
    if (self.percent <= 0.0) {
        state = 3;
        self.state = state;
    }
    if (0 == state) {
        return SVLocalized(@"home_download_failed");
    } else if (1 == state) {
        return SVLocalized(@"home_download_completes");
    } else if (4 == state) {
        return SVLocalized(@"home_downloading");
    } else if (7 == state) {
        return SVLocalized(@"home_delete_task");
    } else {
        if (self.download==2) {
            return SVLocalized(@"tip_converting_new");
        }
        return SVLocalized(@"home_download_waiting");
    }
}

- (NSString *)progressText {
    NSInteger state = self.state;
    if (4 == state) {
        return [NSString stringWithFormat:@"%.0f%@", self.percent, @"%"];
    } else {
        return @"";
    }
}

@end

//
//  SVOfflineView.m
//  Immers
//
//  Created by developer on 2022/6/17.
//

#import "SVOfflineView.h"
#import "SVGlobalMacro.h"

@implementation SVOfflineView

/// 离线视图
+ (instancetype)offlineView {
    return [[self alloc] init];
}

/// 离线视图
- (instancetype)init {
    if (self = [super init]) {
        [self prepareSubviews];
    }
    return self;
}

/// 子视图
- (void)prepareSubviews {
    self.titleLabel.font = kSystemFont(12);
    self.titleLabel.numberOfLines = 0;
    
    NSString *title = SVLocalized(@"home_device_offline");
    CGSize size = [title boundingRectWithSize:CGSizeMake(kWidth(240), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : kSystemFont(12) } context:nil].size;
    
    [self setImage:[UIImage imageNamed:@"home_offline_tip"] forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, -kWidth(8), 0, 0)];
    
    self.backgroundColor = [UIColor grayColor5];
    
    self.frame = CGRectMake(0, 0, size.width+kWidth(70), size.height+kHeight(10));
    [self corner];
}


@end

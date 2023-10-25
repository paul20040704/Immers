//
//  SVHeaderFooterView.m
//  Immers
//
//  Created by developer on 2022/5/19.
//

#import "SVHeaderFooterView.h"

@implementation SVHeaderFooterView

+ (instancetype)viewWithTableView:(UITableView *)tableView {
    NSString *identifier = NSStringFromClass([self class]);
    SVHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!view) {
        view = [[self alloc] initWithReuseIdentifier:identifier];
        view.tintColor = [UIColor whiteColor];
    }
    
    return view;
}

@end

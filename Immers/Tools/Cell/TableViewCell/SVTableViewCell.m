//
//  SVTableViewCell.m
//  Immers
//
//  Created by developer on 2022/5/16.
//

#import "SVTableViewCell.h"

@implementation SVTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    NSString *identifier = NSStringFromClass([self class]);
    
    SVTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

@end

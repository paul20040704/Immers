//
//  SVAccountItem.m
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import "SVAccountItem.h"

@implementation SVAccountItem

- (BOOL)enabled {
    return nil != self.sel && self.sel.length > 0;
}

@end

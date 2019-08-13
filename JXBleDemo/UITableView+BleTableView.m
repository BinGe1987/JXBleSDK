//
//  UITableView+BleTableView.m
//  JXBleDemo
//
//  Created by BinGe on 2019/8/13.
//  Copyright © 2019 JX. All rights reserved.
//

#import "UITableView+BleTableView.h"

@implementation UITableView (BleTableView)

- (void)addScanResultModel:(ScanResultModel *)model {
    NSLog(@"搜索到设备：%@", model.name);
}

@end

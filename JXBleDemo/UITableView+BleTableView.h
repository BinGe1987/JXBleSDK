//
//  UITableView+BleTableView.h
//  JXBleDemo
//
//  Created by BinGe on 2019/8/13.
//  Copyright © 2019 JX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanResultModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (BleTableView)

- (void)addScanResultModel:(ScanResultModel *)model;

@end

NS_ASSUME_NONNULL_END

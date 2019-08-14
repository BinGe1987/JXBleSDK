//
//  BleModelManager.h
//  JXBleDemo
//
//  Created by BinGe on 2019/8/14.
//  Copyright © 2019 JX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ScanResultModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BleModelManager : NSObject

- (instancetype)initWithTableView:(UITableView *)tableView;

- (void)cleanModels;

- (void)addScanResultModel:(ScanResultModel *)model;

@end

NS_ASSUME_NONNULL_END

//
//  ScanResultModel.h
//  JXBleDemo
//
//  Created by BinGe on 2019/8/13.
//  Copyright © 2019 JX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScanResultModel : NSObject

//源数据
@property (nonatomic, assign) id peripheral;


//外设名称
@property (nonatomic, copy) NSString *name;

//蓝牙地址
@property (nonatomic, copy) NSString *mac;

//蓝牙设备全部的 SERVICEUUID、CHARACTERISTICUUD
@property (nonatomic, copy) NSMutableArray *service;

//蓝牙设备广播内容(字节流或十六进制字符串)
@property (nonatomic, copy) NSString *content;

@end

NS_ASSUME_NONNULL_END

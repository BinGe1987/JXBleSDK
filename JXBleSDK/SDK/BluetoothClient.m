//
//  BluetoothClient.m
//  JXBlueSDK
//
//  Created by BinGe on 2019/8/12.
//  Copyright © 2019 JX. All rights reserved.
//

#import "BluetoothClient.h"
#import "BabyBluetooth.h"

@implementation BluetoothClient

BabyBluetooth *baby;

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"BluetoothClient create.");
        //初始化BabyBluetooth 蓝牙库
        baby = [BabyBluetooth shareBabyBluetooth];
        //设置蓝牙委托
        [self babyDelegate];
//        baby.scanForPeripherals().begin();
    }
    return self;
}

//设置蓝牙委托
-(void)babyDelegate{
    
    
    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
    }];
    
    //过滤器
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        //最常用的场景是查找某一个前缀开头的设备 most common usage is discover for peripheral that name has common prefix
        //if ([peripheralName hasPrefix:@"Pxxxx"] ) {
        //    return YES;
        //}
        //return NO;
        //设置查找规则是名称大于1 ， the search rule is peripheral.name length > 1
        if (peripheralName.length >1) {
            return YES;
        }
        return NO;
    }];
}

- (void)setOnBleStateChangeListener:(_Nullable BleStateChangeListener) listener {
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (listener) {
            listener(central.state == CBManagerStatePoweredOn);
        }
    }];
}


- (BOOL)isBleOpen {
    return baby.centralManager.state == CBManagerStatePoweredOn;
}


- (BOOL)openBle {
     //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态
//    return baby.scanForPeripherals().begin();
    NSURL *url = [NSURL URLWithString:@"app-Prefs:root=Bluetooth"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
    return YES;
}

- (void)scan:(BTScanRequestOptions * _Nullable)request onStarted:(void(^)(void))onStarted onDeviceFound:(void (^)(ScanResultModel *model))onDeviceFound onStopped:(void(^)(void))onStopped onCanceled:(void(^)(void))onCanceled {
    baby.scanForPeripherals().begin().stop(request.duration / 1000.0f);
}

@end

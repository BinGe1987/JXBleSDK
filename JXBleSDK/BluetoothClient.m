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
    }
    return self;
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
    NSURL *url = [NSURL URLWithString:@"app-Prefs:root=Bluetooth"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
    return YES;
}

- (void)scan:(BTScanRequestOptions * _Nullable)request onStarted:(void(^)(void))onStarted onDeviceFound:(void (^)(ScanResultModel *model))onDeviceFound onStopped:(void(^)(void))onStopped onCanceled:(void(^)(void))onCanceled {
    
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {

        if (peripheralName.length > 1) {
            return YES;
        }
        
//        if ([peripheralName hasPrefix:@"H"]||[peripheralName hasPrefix:@"h"]||
//            [peripheralName hasPrefix:@"T"]||[peripheralName hasPrefix:@"t"]||
//            [peripheralName hasPrefix:@"E"]||[peripheralName hasPrefix:@"e"])
//        {
//            NSLog(@"搜索到了设备过滤器2:%@",peripheralName);
//            return YES;
//        }
        return NO;
    }];
    
//    baby setb
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        if (onDeviceFound) {
            ScanResultModel *model = [[ScanResultModel alloc] init];
            model.name = peripheral.name;
            NSData *data = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
            if (data) {
                NSString *kCBAdvDataManufacturerString = [NSString stringWithFormat:@"%@", data];
                kCBAdvDataManufacturerString = [kCBAdvDataManufacturerString stringByReplacingOccurrencesOfString:@" " withString:@""];
                if (kCBAdvDataManufacturerString.length > 14 && [kCBAdvDataManufacturerString hasPrefix:@"<"] && [kCBAdvDataManufacturerString hasSuffix:@">"]) {
                    NSMutableString *macString = [[NSMutableString alloc] init];
                    [macString appendString:[[kCBAdvDataManufacturerString substringWithRange:NSMakeRange(1, 2)] uppercaseString]];
                    [macString appendString:@":"];
                    [macString appendString:[[kCBAdvDataManufacturerString substringWithRange:NSMakeRange(3, 2)] uppercaseString]];
                    [macString appendString:@":"];
                    [macString appendString:[[kCBAdvDataManufacturerString substringWithRange:NSMakeRange(5, 2)] uppercaseString]];
                    [macString appendString:@":"];
                    [macString appendString:[[kCBAdvDataManufacturerString substringWithRange:NSMakeRange(7, 2)] uppercaseString]];
                    [macString appendString:@":"];
                    [macString appendString:[[kCBAdvDataManufacturerString substringWithRange:NSMakeRange(9, 2)] uppercaseString]];
                    [macString appendString:@":"];
                    [macString appendString:[[kCBAdvDataManufacturerString substringWithRange:NSMakeRange(11, 2)] uppercaseString]];
                    model.mac = macString;
                    NSLog(@"mac = %@", model.mac);
                    onDeviceFound(model);
                }
            }
        }
        
    }];
    
    [baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        if (onStopped) {
            onStopped();
        }
    }];
    
    baby.scanForPeripherals().begin().stop(request.duration / 1000.0f);
    if (onStarted) {
        onStarted();
    }
}

- (void)stop {
    baby.scanForPeripherals().stop(0);
}

@end

//
//  BluetoothClient.h
//  JXBlueSDK
//
//  Created by BinGe on 2019/8/12.
//  Copyright © 2019 JX. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 蓝牙状态监听器

 @param isBleOpen 参数为蓝牙的开关状态
 */
typedef void (^BleStateChangeListener)(BOOL isBleOpen);



@interface BluetoothClient : NSObject


/**
 设置蓝牙状态监听器

 @param listener 监听器代理
 */
- (void)setOnBleStateChangeListener:(_Nullable BleStateChangeListener) listener;

/**
 判断蓝牙是否已打开

 @return 打开返回YES，关闭返回NO
 */
- (BOOL)isBleOpen;


/**
 打开蓝牙

 @return 打开成功返回YES，打开失败返回NO
 */
- (BOOL)openBle;


/**
 搜索
 */
//- (void)scan:();

@end

NS_ASSUME_NONNULL_END

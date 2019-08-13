//
//  ViewController.m
//  JXBleDemo
//
//  Created by BinGe on 2019/8/12.
//  Copyright © 2019 JX. All rights reserved.
//

#import "ViewController.h"
#import "JXBleSDK.h"

@interface ViewController ()

@property (nonatomic, strong) BluetoothClient *ble;

@property (weak, nonatomic) IBOutlet UILabel *bleStatus;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化蓝牙
    self.ble = [BluetoothClientManager getClient];
    
    //设置蓝牙开关状态监听器
    __weak typeof(self) weakSelf = self;
    [self.ble setOnBleStateChangeListener:^(BOOL isBleOpen) {
        weakSelf.bleStatus.text = [NSString stringWithFormat:@"状态:%@", isBleOpen? @"开":@"关"];
    }];
}


/**
 开始搜索按钮
 */
- (IBAction)startScan:(id)sender {
    NSLog(@"startScan");
    [self.ble scan:[[BTScanRequestOptions alloc] initWithDuration:5000 retryTimes:3] onStarted:^{
        
    } onDeviceFound:^(ScanResultModel *model){
        
    } onStopped:^{
        
    } onCanceled:^{
        
    }];
     
}

/**
 停止搜索按钮
 */
- (IBAction)stopScan:(id)sender {
    NSLog(@"stopScan");
}

/**
 断开连接按钮
 */
- (IBAction)disconnect:(id)sender {
    NSLog(@"disconnect");
}

@end

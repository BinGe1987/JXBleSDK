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
    
    self.ble = [BluetoothClientManager getClient];
//    NSLog(@"ViewController start! %@", [self.ble isBleOpen]? @"蓝牙已打开":@"蓝牙已关闭");
    __weak typeof(self) weakSelf = self;
    [self.ble setOnBleStateChangeListener:^(BOOL isBleOpen) {
        weakSelf.bleStatus.text = [NSString stringWithFormat:@"状态:%@", isBleOpen? @"开":@"关"];
    }];
}
- (IBAction)startScan:(id)sender {
    NSLog(@"startScan");
    [self.ble scan:nil onStarted:^{
        
    } onDeviceFound:^(ScanResultModel *model){
        
    } onStopped:^{
        
    } onCanceled:^{
        
    }];
     
}
- (IBAction)stopScan:(id)sender {
    NSLog(@"stopScan");
}
- (IBAction)disconnect:(id)sender {
    NSLog(@"disconnect");
}

@end

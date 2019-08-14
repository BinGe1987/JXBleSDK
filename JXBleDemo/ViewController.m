//
//  ViewController.m
//  JXBleDemo
//
//  Created by BinGe on 2019/8/12.
//  Copyright © 2019 JX. All rights reserved.
//

#import "ViewController.h"
#import "JXBleSDK.h"
#import "BleModelManager.h"

@interface ViewController ()

@property (nonatomic, strong) BluetoothClient *ble;

//蓝牙开关状态
@property (strong, nonatomic) IBOutlet UILabel *bleStatus;
//蓝牙设备列表
@property (strong, nonatomic) IBOutlet UITableView *bleTableView;
//用于管理tableview的数据，将tableView列表代码与viewController的代码分开
@property (strong, nonatomic) BleModelManager *manager;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //将tableView交给Manager管理
    self.manager = [[BleModelManager alloc] initWithTableView:self.bleTableView];
    
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
    
    [self.manager cleanModels];
    
    __weak typeof(self) weakSelf = self;
    [self.ble scan:[[BTScanRequestOptions alloc] initWithDuration:5000 retryTimes:3] onStarted:^{
        NSLog(@"开始搜索");
    } onDeviceFound:^(ScanResultModel *model){
        NSLog(@"搜索到设备：%@", model.name);
        [weakSelf.manager addScanResultModel:model];
    } onStopped:^{
        NSLog(@"停止搜索");
    } onCanceled:^{
        NSLog(@"取消搜索");
    }];
     
}

/**
 停止搜索按钮
 */
- (IBAction)stopScan:(id)sender {
    NSLog(@"stopScan");
    [self.ble stop];
}

/**
 断开连接按钮
 */
- (IBAction)disconnect:(id)sender {
    NSLog(@"disconnect");
}

@end

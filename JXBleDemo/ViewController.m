//
//  ViewController.m
//  JXBleDemo
//
//  Created by BinGe on 2019/8/12.
//  Copyright © 2019 JX. All rights reserved.
//

#import <TechphantBleLibrary/TechphantBleLibrary.h>
#import "ViewController.h"
#import "ProgressHUB+Utils.h"
#import "Cloud.h"
#import "LoginViewController.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) BluetoothClient *ble;

//显示当前已连接的设备
@property (strong, nonatomic) IBOutlet UILabel *connectedLabel;
//蓝牙开关状态
@property (strong, nonatomic) IBOutlet UILabel *bleStatus;
//蓝牙设备列表
@property (strong, nonatomic) IBOutlet UITableView *bleTableView;
//tableView 数据源
@property (strong, nonatomic) NSMutableArray *modelArray;
@property (strong, nonatomic) NSMutableDictionary *modelDic;
//当前列表中选中的设备
@property (strong, nonatomic) ScanResultModel *currentModel;
//当前已连接的设备
@property (strong, nonatomic) ScanResultModel *connectedModel;
//
@property (assign, nonatomic) BOOL conn;

@property (copy, nonatomic) NSString *commandId;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *hex = @"ff0ff0ff0";
//    NSData *data = [StringUtils hexStringToBytes:hex];
//    NSString *hex2 = [StringUtils Char2Hex:data];
    
    self.bleTableView.dataSource = self;
    self.bleTableView.delegate = self;
    self.modelArray = [NSMutableArray new];
    self.modelDic = [NSMutableDictionary new];
   
    if (![Cloud isLogin]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self presentViewController:loginVC animated:NO completion:nil];
        });
    }
    
    if (![TechphantBleUtils isBluetoothEnable]) {
        //IOS蓝牙无法用代码打开，可以在此处提醒用户手动打开蓝牙开头
    }
    
    //设置蓝牙开关状态监听器
    __weak typeof(self) weakSelf = self;
    self.ble = [BluetoothClientManager getClient];
    [self.ble setOnBleStateChangeListener:^(BOOL isBleOpen) {
        weakSelf.bleStatus.text = [NSString stringWithFormat:@"状态:%@", isBleOpen? @"开":@"关"];
    }];
    
//    [self autoConnect];
    
}

- (void)viewWillAppear:(BOOL)animated {
    if ([Cloud isLogin]) {
        [self autoConnect];
    }
}

- (void)autoConnect {
//    [[NSUserDefaults standardUserDefaults] setObject:@"1123" forKey:@"last_connected"];
    
    NSString *mac = [[NSUserDefaults standardUserDefaults] objectForKey:@"last_connected"];
    if (mac && [mac length] > 0) {
        __weak typeof(self) weakSelf = self;
        BTConnectOptions *options = [[BTConnectOptions alloc] initWithConnectRetry:3 connectTimeout:5000];
        [[BluetoothClientManager getClient] connect:mac options:options onConnectedStateChange:^(NSInteger state) {
            weakSelf.conn = NO;
            weakSelf.connectedModel = [ScanResultModel new];
            weakSelf.connectedModel.address = mac;
            if (state == TP_CODE_CONNECT) {
                weakSelf.connectedLabel.text = [NSString stringWithFormat:@"连接成功：%@", mac];
            } else {
                weakSelf.connectedLabel.text = [NSString stringWithFormat:@"断开连接"];
                return;
            }
        } onReadChanged:^(NSString * _Nonnull uuid, NSInteger status, NSString * _Nonnull value) {
            NSLog(@"读取特征值 : %@", value);
        } onWriteChanged:^(NSString * _Nonnull uuid, NSInteger status, NSString * _Nonnull value) {
            NSLog(@"写数据 : %@", value);
        } onReceivedChanged:^(NSString * _Nonnull uuid, NSArray * _Nonnull values) {
            
        }];
    }
}


/**
 开始搜索按钮
 */
- (IBAction)startScan:(id)sender {
    NSLog(@"startScan");
    
    [self.modelArray removeAllObjects];
    [self.modelDic removeAllObjects];
    [self.bleTableView reloadData];
    
    __weak typeof(self) weakSelf = self;
    BTScanRequestOptions *options = [[BTScanRequestOptions alloc] initWithDuration:5000 retryTimes:3];
    [[BluetoothClientManager getClient] startScan:options onStarted:^{
        NSLog(@"开始搜索");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    } onDeviceFound:^(ScanResultModel *model) {
        ScanResultModel *oldModel = [weakSelf.modelDic objectForKey:model.address];
        if (oldModel) {
            oldModel.peripheral = model.peripheral;
            oldModel.rssi = model.rssi;
             [weakSelf.bleTableView reloadData];
        } else {
            [weakSelf.modelDic setObject:model forKey:model.address];
            [weakSelf.modelArray addObject:model];
            [weakSelf.bleTableView reloadData];
        }
    } onStopped:^{
        NSLog(@"停止搜索");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } onCanceled:^{
        NSLog(@"取消搜索");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
     
}

/**
 停止搜索按钮
 */
- (IBAction)stopScan:(id)sender {
    NSLog(@"stopScan");
    [self.ble stopScan];
}

/**
 断开连接按钮
 */
- (IBAction)disconnect:(id)sender {
    NSLog(@"disconnect");
    [self.ble disconnect:self.connectedModel.address];
}


/**
 下发验证码
 */
- (IBAction)sendVerifyCode:(id)sender {
    NSLog(@"sendVerifyCode");
    if (self.connectedModel) {
        [Cloud deviceBinding:^(NSDictionary * _Nonnull data, NSError * _Nonnull err) {
            if (err) {
                [ProgressHUB toast:[NSString stringWithFormat:@"获取配置失败：%@", err.domain]];
                return;
            }
            self.commandId = data[@"commandId"];
            dispatch_async(dispatch_get_main_queue(), ^{

                NSArray *values = data[@"sendCommand"];
                NSMutableArray *commands = [NSMutableArray new];
                for (int i=0; i < [values count]; i++) {
                    int index = i + 1;
                    NSDictionary *value = values[i];
                    NSString *key = [NSString stringWithFormat:@"key_%d",index];
                    NSString *command = value[key];
                    [commands addObject:command];
                }
                [[BluetoothClientManager getClient] send:self.connectedModel.address command:commands];
            });
        }];
        
//        [[BluetoothClientManager getClient] readCharacterInfo:UUID_DEVICES_BLE_VERSION_CODE];
    } else {
        [ProgressHUB toast:@"蓝牙未连接"];
    }
}


#pragma mark "TableView 代理"

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *identifier = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    ScanResultModel *model = self.modelArray[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text =[NSString stringWithFormat:@"%@ (%lddbm)",model.address, model.rssi] ;
    
    //添加loading
    UIActivityIndicatorView *activityIndicator = [cell.contentView viewWithTag:1];
    if (!activityIndicator) {
        activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        activityIndicator.center = CGPointMake(CGRectGetWidth(cell.contentView.frame) - 100,CGRectGetHeight(cell.contentView.frame)/2);
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [cell.contentView addSubview:activityIndicator];
        activityIndicator.tag = 1;
        activityIndicator.hidden = YES;
    }
    activityIndicator.hidden = !self.conn;
    activityIndicator.hidden ?  [activityIndicator stopAnimating] : [activityIndicator startAnimating];

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //如果当前正在连接设备，直接返回
    if(self.conn) {
        return;
    }
    self.conn = YES;
    self.currentModel =  self.modelArray[indexPath.row];
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    [tableView endUpdates];
    
    self.currentModel =  self.modelArray[indexPath.row];
    self.connectedLabel.text = [NSString stringWithFormat:@"正在连接：%@", self.currentModel.name];
    
    __weak typeof(self) weakSelf = self;
    BTConnectOptions *options = [[BTConnectOptions alloc] initWithConnectRetry:3 connectTimeout:5000];
    NSString *mac = self.currentModel.address;
    NSLog(@"mac : %@", mac);
    [[BluetoothClientManager getClient] connect:self.currentModel.address options:options onConnectedStateChange:^(NSInteger state) {
        self.conn = NO;
        if (mac) {
            [[NSUserDefaults standardUserDefaults] setObject:mac forKey:@"last_connected"];
        }
        if (state == TP_CODE_CONNECT) {
            weakSelf.connectedModel = weakSelf.currentModel;
            weakSelf.connectedLabel.text = [NSString stringWithFormat:@"连接成功：%@", weakSelf.currentModel.name];
        } else {
            weakSelf.connectedLabel.text = [NSString stringWithFormat:@"断开连接"];
            return;
        }
        [tableView reloadData];
    } onReadChanged:^(NSString * _Nonnull uuid, NSInteger status, NSString * _Nonnull value) {
        NSLog(@"读取特征值 : %@", value);
    } onWriteChanged:^(NSString * _Nonnull uuid, NSInteger status, NSString * _Nonnull value) {
        NSLog(@"写数据 : %@", value);
    } onReceivedChanged:^(NSString * _Nonnull uuid, NSArray * _Nonnull values) {
        NSDictionary *data = @{
                              @"imei": @"867726036503458",
                              @"commandId": self.commandId,
                              @"content": values
                              };
       [Cloud response:data block:^(NSDictionary * _Nonnull data, NSError * _Nonnull err) {
           [ProgressHUB toast:@"发送完成"];
       }];
    }];

    
    
}


@end

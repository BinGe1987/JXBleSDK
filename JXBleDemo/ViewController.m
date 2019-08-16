//
//  ViewController.m
//  JXBleDemo
//
//  Created by BinGe on 2019/8/12.
//  Copyright © 2019 JX. All rights reserved.
//

#import "ViewController.h"
#import "JXBleSDK.h"
#import "Tools.h"
#import "ProgressHUB+Utils.h"
#import "Cloud.h"


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
//当前选中的设备
@property (strong, nonatomic) ScanResultModel *currentModel;
//当前已连接的设备
@property (strong, nonatomic) ScanResultModel *connectedModel;

@property (copy, nonatomic) NSString *token;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bleTableView.dataSource = self;
    self.bleTableView.delegate = self;
    self.modelArray = [NSMutableArray new];
    self.modelDic = [NSMutableDictionary new];
    
    //初始化蓝牙
    self.ble = [BluetoothClientManager getClient];
    
    //设置蓝牙开关状态监听器
    __weak typeof(self) weakSelf = self;
    [self.ble setOnBleStateChangeListener:^(BOOL isBleOpen) {
        weakSelf.bleStatus.text = [NSString stringWithFormat:@"状态:%@", isBleOpen? @"开":@"关"];
    }];
   
    [ProgressHUB loading];
    [Cloud login:^(NSString * _Nonnull token, NSError * _Nonnull err) {
        [ProgressHUB dismiss];
        if (err) {
            
        } else {
            self.token = token;
        }
    }];
    
}


/**
 开始搜索按钮
 */
- (IBAction)startScan:(id)sender {
    NSLog(@"startScan");
    
    [self.modelArray removeAllObjects];
    [self.bleTableView reloadData];
    
    __weak typeof(self) weakSelf = self;
    [self.ble startScan:[[BTScanRequestOptions alloc] initWithDuration:5000 retryTimes:3] onStarted:^{
        NSLog(@"开始搜索");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    } onDeviceFound:^(ScanResultModel *model) {
        ScanResultModel *oldModel = [weakSelf.modelDic objectForKey:model.mac];
        if (oldModel) {
            oldModel.peripheral = model.peripheral;
        } else {
            [weakSelf.modelDic setObject:model forKey:model.mac];
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
    [self.ble disconnect:nil];
}


/**
 下发验证k码
 */
- (IBAction)sendVerifyCode:(id)sender {
    NSLog(@"sendVerifyCode");
    if (self.connectedModel) {
        NSString *key_1 = @"9A20010F071951C5B313226E01C489E032256A99";
        NSData *key_1Data = [Tools convertHexStringToData:key_1];
        [self.ble sendWithService:@"FFF0" characteristic:@"FFF6" value:key_1Data];
        
        NSString *key_2 = @"9A20020F61471BCD515223B5B10426C86D27BEE7";
        NSData *key_2Data = [Tools convertHexStringToData:key_2];
        [self.ble sendWithService:@"FFF0" characteristic:@"FFF6" value:key_2Data];
        
        NSString *key_3 = @"9A200302BD9804";
        NSData *key_3Data = [Tools convertHexStringToData:key_3];
        [self.ble sendWithService:@"FFF0" characteristic:@"FFF6" value:key_3Data];
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
    cell.detailTextLabel.text = model.mac;
    
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
    activityIndicator.hidden = !(self.currentModel && (model == self.currentModel));
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
    if(self.currentModel) {
        return;
    }
    self.currentModel =  self.modelArray[indexPath.row];
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    [tableView endUpdates];
    
    self.currentModel =  self.modelArray[indexPath.row];
    self.connectedLabel.text = [NSString stringWithFormat:@"正在连接：%@", self.currentModel.name];
    
    __weak typeof(self) weakSelf = self;
    [self.ble connect:self.currentModel onConnectedStateChange:^(int state) {
        switch (state) {
            default:
            case 0://断开连接
                weakSelf.connectedModel = nil;
                weakSelf.connectedLabel.text = [NSString stringWithFormat:@"断开连接"];
                break;
            case 1://连接成功
                weakSelf.connectedModel = weakSelf.currentModel;
                weakSelf.connectedLabel.text = [NSString stringWithFormat:@"连接成功：%@", weakSelf.currentModel.name];
                break;
            case -1://连接失败
                weakSelf.connectedModel = nil;
                weakSelf.connectedLabel.text = [NSString stringWithFormat:@"连接失败"];
                break;
        }
        
        weakSelf.currentModel = nil;
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        [tableView endUpdates];
        
    } onServiceDiscover:^{
        
    } onCharacteristicChange:^(NSString * _Nonnull serviceUUID, NSString * _Nonnull characterUUID, NSData * _Nonnull value) {
        
    } onCharacteristicWrite:^(NSString * _Nonnull serviceUUID, NSString * _Nonnull characterUUID, NSData * _Nonnull value) {
        
    } onCharacteristicRead:^(NSString * _Nonnull serviceUUID, NSString * _Nonnull characterUUID, NSData * _Nonnull value) {
        
    }];
    
}

- (BOOL)mergeData:(Byte[])buffer sourceData:(NSString *)source{
    if (!buffer) {
        return NO;
    }
    
    Byte bufHeader = buffer[0];
    if (bufHeader != 0x9A) {
        return NO;
    }
    
    return NO;
}

//-(BOOL) mergeReceiveData2(Byte[] buffer) {
//    if (nil == buffer) return NO;
//
//    byte bufHeader = buffer[0];
//    if (bufHeader != (byte) 0x9A) { //若不是0x9A开头，则取消
//        return false;
//    }
//    byte bufLength = buffer[1];
//    //包编号
//    byte bufNumber = buffer[2];
//    //有效数据长度 如果是E / 1开头表示蓝牙协议
//    String originData = Char2Hex(buffer);
//    String commandId = originData.substring(6, 7);
//    String dataLenStr = originData.substring(7, 8);
//    byte dataLength = (byte) 0x01;
//    if (commandId.equalsIgnoreCase("E")
//        || commandId.equalsIgnoreCase("1")) {//蓝牙协议
//        dataLength = LockCommand.hexStringToBytes(dataLenStr)[0];
//    } else {
//        dataLength = LockCommand.hexStringToBytes(dataLenStr)[0];//buffer[3];
//    }
//    //数据错误，返回
//    if (byteToInt(dataLength) < 1 || byteToInt(dataLength) > 16) {
//        isFinishReceiveState = true;
//        return false;
//    }
//    if (bufNumber == (byte) 0x01) { //如果是第一包，则把之前的缓存数据清空
//        recDataList.clear();
//    }
//    int listIndex = byteToInt(bufNumber) - 1;
//    if (recDataList.size() < listIndex) { //判断当清楚数据时，突然有上一包的数据出现
//        Log.d("vincent", "MISS RECEIVE DATA===" + LockCommand.getInstance().Char2Hex(buffer));
//        isFinishReceiveState = true;
//        return false;
//    }
//    //把每小包加入到列表中
//    recDataList.add(listIndex, buffer);
//
//    //判断数据总长度 如果超过15个字节，则有分包，继续监听数据
//    int dataTotalLength = buffer[1] & 0xFF;
//    //分包数
//    double split_length = Double.parseDouble(15 + "");
//    int splitCount = (int) Math.ceil(dataTotalLength / split_length);
//    if (dataTotalLength > 15 && bufNumber < splitCount) {
//        return true;
//    }
//
//    if (mBluetoothCallbackListener != null) {
//        ReceiverModel model = new ReceiverModel();
//        model.setOriginRecData(recDataList);
//        mBluetoothCallbackListener.ReceiverDevicesData(model);
//    }
//    recDataList.clear();
//    return false;
//}

@end

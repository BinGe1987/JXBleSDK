//
//  BleModelManager.m
//  JXBleDemo
//
//  Created by BinGe on 2019/8/14.
//  Copyright © 2019 JX. All rights reserved.
//

#import "BleModelManager.h"

@interface BleModelManager()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *bleTableView;
@property (strong, nonatomic) NSMutableArray *modelArray;

@end

@implementation BleModelManager

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.bleTableView = tableView;
        self.bleTableView.delegate = self;
        self.bleTableView.dataSource = self;
        self.modelArray = [NSMutableArray new];
    }
    return self;
}

- (void)cleanModels {
    [self.modelArray removeAllObjects];
    [self.bleTableView reloadData];
}

- (void)addScanResultModel:(ScanResultModel *)model {
    [self.modelArray addObject:model];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.modelArray.count-1 inSection:0];
    [self.bleTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *identifier = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    ScanResultModel *model = self.modelArray[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.mac;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

@end

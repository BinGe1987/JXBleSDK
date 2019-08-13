//
//  BTScanRequestOptions.h
//  JXBleDemo
//
//  Created by BinGe on 2019/8/13.
//  Copyright © 2019 JX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTScanRequestOptions : NSObject

@property (atomic, assign) NSInteger duration;
@property (atomic, assign) NSInteger retryTimes;

-(instancetype)init;

-(instancetype)initWithDuration:(int)ms retryTimes:(int)times;

@end

NS_ASSUME_NONNULL_END

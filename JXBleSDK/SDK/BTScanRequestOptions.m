//
//  BTScanRequestOptions.m
//  JXBleDemo
//
//  Created by BinGe on 2019/8/13.
//  Copyright © 2019 JX. All rights reserved.
//

#import "BTScanRequestOptions.h"

@interface BTScanRequestOptions(){
    int duration;
    int retryTimes;
}
@end

@implementation BTScanRequestOptions



-(instancetype)init {
    return [self initWithDuration:5000 retryTimes:3];
}

-(instancetype)initWithDuration:(int)ms retryTimes:(int)times {
    self = [super init];
    if (self) {
        duration = ms;
        retryTimes = times;
    }
    return self;
}

@end

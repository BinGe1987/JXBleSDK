//
//  Tools.m
//  JXBleDemo
//
//  Created by BinGe on 2019/8/14.
//  Copyright © 2019 JX. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+ (NSString *)convertToNSStringWithNSData:(NSData *)data {
    NSMutableString *strTemp = [NSMutableString stringWithCapacity:[data length]*2];
    const unsigned char *szBuffer = [data bytes];
    for (NSInteger i=0; i < [data length]; ++i) {
        [strTemp appendFormat:@"%02lx",(unsigned long)szBuffer[i]];
    }
    return strTemp;
}

@end

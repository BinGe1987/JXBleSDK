//
//  Tools.m
//  JXBleDemo
//
//  Created by BinGe on 2019/8/15.
//  Copyright © 2019 JX. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+ (NSData *)convertHexStringToData:(NSString *)hexString
{
    if (!hexString || [hexString length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([hexString length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [hexString length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [hexString substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    Byte *bytes = (Byte *)[hexData bytes];
    for(int i=0;i<[hexData length];i++) {
        NSLog(@"byte[%d] = %x\n",i, bytes[i]);
    }
    return hexData;
}

@end

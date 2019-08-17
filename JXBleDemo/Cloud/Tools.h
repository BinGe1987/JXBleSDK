//
//  Tools.h
//  JXBleDemo
//
//  Created by BinGe on 2019/8/15.
//  Copyright © 2019 JX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tools : NSObject

+ (Byte *)hexStringToBytes:(NSString *)hexString;

+ (NSData *)convertHexStringToData:(NSString *)hexString;

@end

NS_ASSUME_NONNULL_END

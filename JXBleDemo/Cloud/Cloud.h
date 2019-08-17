//
//  Cloud.h
//  JXBleDemo
//
//  Created by BinGe on 2019/8/16.
//  Copyright © 2019 JX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Cloud : NSObject

+ (BOOL)isLogin;

+ (void)login:(void (^)(NSError *err))block;

+ (void)deviceBinding:(void (^)(NSDictionary *data, NSError *err))block;

+ (void)response:(NSDictionary *)data block:(void (^)(NSDictionary *data, NSError *err))block;

@end

NS_ASSUME_NONNULL_END

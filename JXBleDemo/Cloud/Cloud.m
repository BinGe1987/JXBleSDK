//
//  Cloud.m
//  JXBleDemo
//
//  Created by BinGe on 2019/8/16.
//  Copyright © 2019 JX. All rights reserved.
//

#import "Cloud.h"
#import "Http.h"

@implementation Cloud

static NSString *token;

+ (BOOL)isLogin {
    return token;
}

+ (void)login:(void (^)(NSError *err))block {
    HttpRequest *request = [[HttpRequest alloc] initWithHost:@"http://dev.techphant.net/webApi/v2.0.0" api:@"/application/login"];
    request.data = @{@"appId":@"tp_8tibgq1RWzd4",@"appSecret":@"ucV3lh0fLZkRb4Iy8z1CTwnMtB5PAevU"};
    [Http post:request reponse:^(HttpResponse * _Nonnull response) {
        if (response.error) {
            block(response.error);
        } else {
            int errCode = [response.data[@"errCode"] intValue];;
            if (errCode == 0) {
                token = response.data[@"accessToken"];
                block( nil);
            } else {
                block([NSError errorWithDomain:response.data[@"errMsg"] code:errCode userInfo:nil]);
            }
        }
    }];
}

+ (void)deviceBinding:(void (^)(NSDictionary *data, NSError *err))block {
    HttpRequest *request = [[HttpRequest alloc] initWithHost:@"http://dev.techphant.net/webApi/v2.0.0" api:@"/deviceBinding/867726036503458"];
    request.token = token;
    request.data = @{
                     @"actionCode":[NSNumber numberWithInt:2091],
                     @"type":[NSNumber numberWithInt:2],
                     @"content":
                            @{
                             @"verifyCode": @"MIBgVL",
                             @"appId": @"1234567890",
                             @"value": @"123456"
                             }
                     };
    [Http post:request reponse:^(HttpResponse * _Nonnull response) {
        if (response.error) {
            block(nil, response.error);
        } else {
            int errCode = [response.data[@"errCode"] intValue];;
            if (errCode == 0) {
                block(response.data[@"data"], nil);
            } else {
                block(nil, [NSError errorWithDomain:response.data[@"errMsg"] code:errCode userInfo:nil]);
            }
        }
    }];
}

+ (void)response:(NSDictionary *)data block:(void (^)(NSDictionary *data, NSError *err))block {
    HttpRequest *request = [[HttpRequest alloc] initWithHost:@"http://dev.techphant.net/webApi/v2.0.0" api:@"/bt/response/EE987AE8FE53"];
    request.token = token;
    request.data = data;
    [Http post:request reponse:^(HttpResponse * _Nonnull response) {
        if (response.error) {
            block(nil, response.error);
        } else {
            int errCode = [response.data[@"errCode"] intValue];;
            if (errCode == 0) {
                block(response.data[@"data"], nil);
            } else {
                block(nil, [NSError errorWithDomain:response.data[@"errMsg"] code:errCode userInfo:nil]);
            }
        }
    }];
}

@end

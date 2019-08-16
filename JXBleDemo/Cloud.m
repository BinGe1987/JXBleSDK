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

+ (void)login:(void (^)(NSString *token, NSError *err))block {
    HttpRequest *request = [[HttpRequest alloc] initWithHost:@"http://dev.techphant.net/webApi/v2.0.0" api:@"/application/login"];
    request.data = @{@"appId":@"tp_ZP6MO8x3hjBJ",@"appSecret":@"CrsQ0LXNlD9SBxP4iGpzgvHanY7OmwUj"};
    [Http post:request reponse:^(HttpResponse * _Nonnull response) {
        if (response.error) {
            block(nil, response.error);
        } else {
            int errCode = [response.data[@"errCode"] intValue];;
            if (errCode == 0) {
                block(response.data[@"accessToken"], nil);
            } else {
                block(nil, [NSError errorWithDomain:response.data[@"errMsg"] code:errCode userInfo:nil]);
            }
        }
    }];
}

@end

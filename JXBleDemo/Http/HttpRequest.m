//
//  HttpRequest.m
//  APP
//
//  Created by BinGe on 2019/1/3.
//

#import "HttpRequest.h"

@implementation HttpRequest

+ (instancetype)withHost:(NSString *)host api:(NSString *)api {
    return [[HttpRequest alloc] initWithHost:host api:api];
}

- (instancetype)initWithHost:(NSString *)host api:(NSString *)api {
    self = [super init];
    self.host = host;
    self.api = api;
    return self;
}

- (NSString *)requestURL {
    return [NSString stringWithFormat:@"%@%@", self.host, self.api];
}

- (NSTimeInterval)timeout {
    return _timeout ? _timeout : 6;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"HttpRequest:\n%@\n%@",self.requestURL, self.data];
}

@end

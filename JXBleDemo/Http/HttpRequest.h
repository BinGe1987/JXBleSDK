//
//  HttpRequest.h
//  APP
//
//  Created by BinGe on 2019/1/3.
//

#import <Foundation/Foundation.h>

#define HttpRequest(host, api)

NS_ASSUME_NONNULL_BEGIN

@interface HttpRequest : NSObject

@property (nonatomic, copy) NSString *host;

@property (nonatomic, copy) NSString *api;

@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, assign) NSTimeInterval timeout;

+ (instancetype)withHost:(NSString *)host api:(NSString *)api;

- (instancetype)initWithHost:(NSString *)host api:(NSString *)api;

- (NSString *)requestURL;

@end

NS_ASSUME_NONNULL_END

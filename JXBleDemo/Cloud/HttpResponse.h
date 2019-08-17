//
//  HttpResponse.h
//  APP
//
//  Created by BinGe on 2019/1/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HttpResponse : NSObject

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSError *error;

@property (nonatomic, strong) NSDictionary *data;

@end

NS_ASSUME_NONNULL_END

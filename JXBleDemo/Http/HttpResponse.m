//
//  HttpResponse.m
//  APP
//
//  Created by BinGe on 2019/1/3.
//

#import "HttpResponse.h"

@implementation HttpResponse

- (NSString *)description {
    return [NSString stringWithFormat:@"HttpResponse:\n%@\n%@",self.url, self.error ? self.error : self.data];
}

@end

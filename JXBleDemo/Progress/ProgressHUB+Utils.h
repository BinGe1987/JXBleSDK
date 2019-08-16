//
//  ProgressHUB+Utils.h
//  APP
//
//  Created by BinGe on 2018/12/30.
//

#import "ProgressHUB.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProgressHUB (Utils)

#pragma mark 小菊花
+ (void)loading;
+ (void)loadingTitle:(NSString *)title;
+ (void)loadingTitle:(NSString *)title detailText:(NSString *)detail;



+ (void)toast:(NSString *)title;

+ (void)errorTitle:(NSString *)title;

+ (void)showView:(UIView *)view;

+ (void)dismiss;

@end

NS_ASSUME_NONNULL_END

//
//  ProgressHUB+Tips.h
//  APP
//
//  Created by BinGe on 2019/1/5.
//

#import "ProgressHUB.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProgressHUB (Tips)

/**
 只显示一次，在提示完成之前，之次调用无效
 */
+ (void)showTips:(NSString *)tips;
+ (void)showTips:(NSString *)tips completion:(void (^ __nullable)(BOOL finished))completion;

/**
 多次调会顺序播放提示
 */
+ (void)postTips:(NSString *)tips;
+ (void)postTips:(NSString *)tips completion:(void (^ __nullable)(BOOL finished))completion;

@end

NS_ASSUME_NONNULL_END

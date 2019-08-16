//
//  ProgressHUB.h
//  APP
//
//  Created by BinGe on 2018/12/19.
//

#define TOP_WINDOW (UIWindow*)[UIApplication sharedApplication].delegate.window

#define STATUSBARHIEGHT ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define NVBARHIEGHT  self.navigationController.navigationBar.frame.size.height
#define TABBARHIEGHT self.tabBarController.tabBar.frame.size.height

#define SCREENWIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height

#define SCREENSCALE   SCREENWIDTH/375.0

#define ScaleValue(value)   value * SCREENSCALE

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProgressHUB : NSObject

@end

NS_ASSUME_NONNULL_END

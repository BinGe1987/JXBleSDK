//
//  ProgressHUB+Utils.m
//  APP
//
//  Created by BinGe on 2018/12/30.
//

#import "ProgressHUB+Utils.h"
#import "MBProgressHUD.h"
#import <UIKit/UIKit.h>

@implementation ProgressHUB (Utils)

+ (void)loading {
    [MBProgressHUD showHUDAddedTo:TOP_WINDOW animated:YES];
    
}
+ (void)loadingTitle:(NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:TOP_WINDOW animated:YES];
    hud.label.text = title;
}
+ (void)loadingTitle:(NSString *)title detailText:(NSString *)detail{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:TOP_WINDOW animated:YES];
    hud.label.text = title;
    hud.detailsLabel.text = detail;
}

+ (void)toast:(NSString *)title {
    if ([NSThread isMainThread]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:TOP_WINDOW animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = title;
        CGFloat offsetTop = [UIScreen mainScreen].bounds.size.height * 0.5;
//        hud.offset = CGPointMake(0.f, offsetTop);
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:2.0];
    }
    else {
        [ProgressHUB performSelectorOnMainThread:@selector(toast:) withObject:title waitUntilDone:NO];
    }
    
}

+ (void)errorTitle:(NSString *)title {
    if ([NSThread isMainThread]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:TOP_WINDOW animated:YES];
        hud.label.text = title;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:1.5];
    }
    else {
        [ProgressHUB performSelectorOnMainThread:@selector(errorTitle:) withObject:title waitUntilDone:NO];
    }
}

+ (void)showView:(UIView *)view {
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[ImageUtils imageWithColor:[UIColor whiteColor] size:view.bounds.size]];
//    [imageView addSubview:view];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:TOP_WINDOW animated:YES];
//    hud.mode = MBProgressHUDModeCustomView;
//    hud.customView = imageView;
//    hud.minSize = view.frame.size;
//    hud.margin = 0;
}

+ (void)dismiss {
    if ([NSThread isMainThread]) {
        [MBProgressHUD hideHUDForView:TOP_WINDOW animated:YES];
    }
    else {
        [ProgressHUB performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:NO];
    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [MBProgressHUD hideHUDForView:TOP_WINDOW animated:YES];
//    });
}

@end

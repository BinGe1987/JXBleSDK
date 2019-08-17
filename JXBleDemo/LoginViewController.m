//
//  LoginViewController.m
//  JXBleDemo
//
//  Created by BinGe on 2019/8/17.
//  Copyright © 2019 LI. All rights reserved.
//

#import "LoginViewController.h"
#import "ProgressHUB+Utils.h"
#import "Cloud.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loginAction:nil];
    
}

- (IBAction)loginAction:(id)sender {
    [ProgressHUB loading];
    [Cloud login:^(NSError * _Nonnull err) {
        [ProgressHUB dismiss];
        if (err) {
            [ProgressHUB toast:err.domain];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:NO completion:nil];
            });
        }
    }];
}


@end

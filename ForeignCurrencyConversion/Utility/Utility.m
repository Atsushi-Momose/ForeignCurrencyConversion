//
//  Utility.m
//  ForeignCurrencyConversion
//
//  Created by mmsc on 2018/09/16.
//  Copyright © 2018年 mmsc. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (void)showAlertController:(NSString *)titleText message:(NSString *)messageText {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleText
                                                                             message:messageText
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    // Cancel用のアクションを生成
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"閉じる"
                                                           style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       [Utility maskDismiss];
    }];
    
    [alertController addAction:cancelAction];
    
    [[Utility currentViewController] presentViewController:alertController animated:YES completion:nil];
}

// 最前面（現在表示中）のViewControllerを取得
+ (UIViewController *)currentViewController {
    
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return  viewController;
}

+ (void)showMask {
    
    UIViewController *currentViewController = [Utility currentViewController];
    
    UIView *view = [UIView new];
    view.frame = currentViewController.view.frame;
    view.backgroundColor = [UIColor whiteColor];
    view.tag = 99;
    
    [currentViewController.view addSubview:view];
}

+ (void)maskDismiss {
    UIViewController *currentViewController = [Utility currentViewController];
    
    UIView *view = currentViewController.view;
    
    UIView *mask = [view viewWithTag:99];
    
    [mask removeFromSuperview];
}

@end

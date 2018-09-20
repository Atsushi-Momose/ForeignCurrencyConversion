//
//  UIAlertController+Utility.m
//  ForeignCurrencyConversion
//
//  Created by mmsc on 2018/09/20.
//  Copyright © 2018年 mmsc. All rights reserved.
//

#import "UIAlertController+Utility.h"
#import "Utility.h"
#import "UIViewController+Utility.h"

@implementation UIAlertController (Utility)

- (void)showAlertController:(NSString *)titleText message:(NSString *)messageText {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleText
                                                                             message:messageText
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    // Cancel用のアクションを生成
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"閉じる"
                                                           style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                               [Utility maskDismiss];
                                                           }];
    
    [alertController addAction:cancelAction];
    
    [[UIAlertController topViewController] presentViewController:alertController animated:YES completion:nil];
}

@end

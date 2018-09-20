//
//  UIViewController+Utility.m
//  ForeignCurrencyConversion
//
//  Created by mmsc on 2018/09/20.
//  Copyright © 2018年 mmsc. All rights reserved.
//

#import "UIViewController+Utility.h"

@implementation UIViewController (Utility)

+ (UIViewController *)topViewController {
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return  viewController;
}

@end

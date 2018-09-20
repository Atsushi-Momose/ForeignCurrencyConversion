//
//  Utility.m
//  ForeignCurrencyConversion
//
//  Created by mmsc on 2018/09/16.
//  Copyright © 2018年 mmsc. All rights reserved.
//

#import "Utility.h"
#import "UIViewController+Utility.h"
@implementation Utility

+ (void)showMask {
    
    UIViewController *topViewController = [UIViewController topViewController];
    
    UIView *view = [UIView new];
    view.frame = topViewController.view.frame;
    view.backgroundColor = [UIColor whiteColor];
    view.tag = 99;
    
    [topViewController.view addSubview:view];
}

+ (void)maskDismiss {
    UIViewController *topViewController = [UIViewController topViewController];
    
    UIView *view = topViewController.view;
    
    UIView *mask = [view viewWithTag:99];
    
    [mask removeFromSuperview];
}

+ (NSString *)getValueUpToFiveDecimal:(double)value {
    float fValue = [[NSString stringWithFormat:@"%f", value] floatValue];
    return [NSString stringWithFormat:@"%.5f", fValue];
}

@end

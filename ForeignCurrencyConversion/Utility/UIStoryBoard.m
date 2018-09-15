//
//  UIStoryBoard.m
//  ForeignCurrencyConversion
//
//  Created by mmsc on 2018/09/15.
//  Copyright © 2018年 mmsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIStoryBoard.h"
#import "RateConversionViewController.h"

@implementation UIStoryBoard

+ (id)RateConversion {
    // SignInViewControllerのインスタンスを生成
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RateConversionView" bundle:nil];
    RateConversionViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"RateConversion"];
    return vc;
}

@end

//
//  FCCStoryBoard.m
//  ForeignCurrencyConversion
//
//  Created by mmsc on 2018/09/15.
//  Copyright © 2018年 mmsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCCStoryBoard.h"
#import "RateConversionViewController.h"

@implementation FCCStoryBoard

+ (id)RateConversion {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RateConversionView" bundle:nil];
    RateConversionViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"RateConversion"];
    return vc;
}

@end

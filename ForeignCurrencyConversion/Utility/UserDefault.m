//
//  UserDefault.m
//  ForeignCurrencyConversion
//
//  Created by mmsc on 2018/09/15.
//  Copyright © 2018年 mmsc. All rights reserved.
//

#import "UserDefault.h"

@implementation UserDefault

+ (NSString *)selectedCurrencyName {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:[UserDefault selectedCurrencyNameKey]];
}

+ (void)setSelectedCurrencyName:(NSString *)name {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:name forKey:[UserDefault selectedCurrencyNameKey]];
    [ud synchronize];
}

+ (NSString *)selectedCurrencyNameKey {
    return @"selectedCurrencyNameKey";
}

@end

//
//  Utility.h
//  ForeignCurrencyConversion
//
//  Created by mmsc on 2018/09/16.
//  Copyright © 2018年 mmsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility: NSObject

+ (void)showMask;

+ (void)maskDismiss;

// 小数点以下5位までのstringに変換
+ (NSString *)getValueUpToFiveDecimal:(double)value;

@end

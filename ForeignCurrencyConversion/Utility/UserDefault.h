//
//  UserDefault.h
//  ForeignCurrencyConversion
//
//  Created by mmsc on 2018/09/15.
//  Copyright © 2018年 mmsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefault: NSObject

// 選択中通貨
+ (void)setSelectedCurrencyName:(NSString *)name;
+ (NSString *)selectedCurrencyName;

@end

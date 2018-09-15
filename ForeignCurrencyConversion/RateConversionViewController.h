//
//  RateConversionViewController.h
//  ForeignCurrencyConversion
//
//  Created by mmsc on 2018/09/12.
//  Copyright © 2018年 mmsc. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface RateConversionViewController : UIViewController

// 通貨リスト
@property (nonatomic, retain) NSArray *currencyInfoList;

// 選択中通貨
@property (nonatomic, retain) NSMutableArray *selectedCurrency;

@end


//
//  RatePresenter.h
//  ForeignCurrencyConversion
//
//  Created by mmsc on 2018/09/20.
//  Copyright © 2018年 mmsc. All rights reserved.
//
#import "RateViewController.h"

@interface RatePresenter : NSObject

@property (nonatomic, retain) RatePresenter *presenter;
@property (nonatomic, retain) NSMutableArray *currencyInfoList; // 通貨リスト
@property (nonatomic, retain) NSMutableArray *selectedCurrency; // 選択中通貨

- (id)initWithRateViewController:(RateViewController *)viewController;

- (void)fetchCurrencyData;

- (void)didSelectPickerView:(NSInteger)selectedRow inComponent:(NSInteger)component;

- (NSArray *)sortCurrencyInfoList;

@end

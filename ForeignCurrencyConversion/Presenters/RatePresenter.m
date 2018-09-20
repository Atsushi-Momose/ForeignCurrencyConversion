//
//  RatePresenter.m
//  ForeignCurrencyConversion
//
//  Created by mmsc on 2018/09/20.
//  Copyright © 2018年 mmsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RatePresenter.h"
#import <SVProgressHUD.h>
#import "APIConnectionService.h"
#import "Utility.h"
#import "UIAlertController+Utility.h"
#import "UserDefault.h"

@implementation RatePresenter

static RateViewController *rateViewController = nil;

- (id)initWithRateViewController:(RateViewController *)viewController {
    
    if (self) {
        if (!rateViewController) {
            rateViewController = viewController;
        }
    }
    return self;
}

// MARK: 公開メソッド
- (void)fetchCurrencyData {
    _currencyInfoList = [NSMutableArray new];
    _selectedCurrency = [NSMutableArray new];
   
    // データ取得
    [self fetchForeignCurrencyInfo];
}

// MARK: 内部メソッド
- (void)fetchForeignCurrencyInfo {
   
    // ローディング
    [SVProgressHUD show];
    
    APIConnectionService *connectionService = [APIConnectionService new];
    
    UIAlertController *alertController = [UIAlertController new];
    
    RatePresenter __weak *weakSelf = self;
    [connectionService asyncRequest:^void (NSMutableArray *resultList, NSURLResponse *response) {
        
        if ([resultList count]) {
            weakSelf.currencyInfoList = resultList;
            dispatch_sync(dispatch_get_main_queue(), ^{
                // 画面表示更新
                [weakSelf refreshRateView];
            });
        } else if (response) { // 404等
            
            [SVProgressHUD dismiss];
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSString *statusCode = [NSString stringWithFormat:@"statusCode %ld", (long)httpResponse.statusCode];
            [alertController showAlertController:@"通信エラー" message:statusCode];
        }
        
        [SVProgressHUD dismiss];
    }
                            failure:^(NSError *error) {
                                [SVProgressHUD dismiss];
                                [alertController showAlertController:@"Error" message:error.localizedDescription];
                            }];
}

- (void)refreshRateView {
    
    [Utility maskDismiss];
    
    // 最終更新日更新
    [self updateLastModifiedLabel];
    
    // 選択中の通貨情報を通貨リストの先頭に移動
    [self sortCurrencyInfoList];
    
   // RateViewController *rvc = rateViewController;//[RateViewController sharedInstance];
    
    // pickerViewを選択状態に
    [rateViewController.currencyPickerView selectRow:0 inComponent:0 animated:NO];
    
    // 通貨ピッカー更新
    [rateViewController.currencyPickerView reloadAllComponents];
    
    [rateViewController.rateTableView reloadData];
}

- (void)updateLastModifiedLabel {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    [format setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    rateViewController.lastModifiedLabel.text = [NSString stringWithFormat:@"最終更新日時：%@", [format stringFromDate:[NSDate date]]];
}

// 通貨リストの先頭に選択中の通貨を移動
- (NSArray *)sortCurrencyInfoList {
    
    // 選択中の通貨が存在する場合
    NSString *savedCurrency = [UserDefault selectedCurrencyName];
    if ([savedCurrency length]) {
        
        // 通貨情報リストから該当データを取得
        _selectedCurrency = [NSMutableArray new];
        
        NSDictionary *sortTargetInfo = [NSDictionary new];
        
        int i = 0;
        for (NSDictionary *dic in _currencyInfoList) {
            if ([[[dic allKeys] firstObject] isEqualToString:savedCurrency]) {
                
                sortTargetInfo = dic;
                
                NSArray *array = [dic allValues];
                
                for (NSString *key in array[0]) {
                    [_selectedCurrency addObject:[NSDictionary dictionaryWithObject:array[0][key] forKey:key]];
                }
                break;
            }
            i++;
        }
        // 先頭に移動
        if ([sortTargetInfo count]) {
            [_currencyInfoList removeObjectAtIndex:i];
            [_currencyInfoList insertObject:sortTargetInfo atIndex:0];
        }
    }
    
    return _currencyInfoList;
}

- (void)didSelectPickerView:(NSInteger)selectedRow inComponent:(NSInteger)component {
    
    rateViewController.preSelectedLb = (UILabel *)[rateViewController.currencyPickerView viewForRow:selectedRow forComponent:component];
    
    // 選択中の通貨を設定
    NSArray *array = [_currencyInfoList[selectedRow] allValues];
    
    for (NSString *key in [array[0] allKeys]) {
        [_selectedCurrency addObject:[NSDictionary dictionaryWithObject:array[0][key] forKey:key]];
    }
    
    // 選択中通貨を保存
    [UserDefault setSelectedCurrencyName:[[_currencyInfoList[selectedRow] allKeys] firstObject]];
    
    [rateViewController.currencyPickerView reloadComponent:0];
    
    // tableView更新
    [rateViewController.rateTableView reloadData];
}

@end

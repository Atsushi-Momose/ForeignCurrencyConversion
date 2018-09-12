//
//  MainViewController.m
//  ForeignCurrencyConversion
//
//  Created by mmsc on 2018/09/12.
//  Copyright © 2018年 mmsc. All rights reserved.
//

#import "MainViewController.h"
#import "APIConnectionService.h"
#import <SVProgressHUD.h>

@interface MainViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

// 通貨リスト
@property (nonatomic) NSArray *currencyInfoList;

// 選択中通貨
@property (nonatomic) NSArray *selectedCurrency;

@property (weak, nonatomic) IBOutlet UIPickerView *currencyPickerView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [SVProgressHUD show];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 通信開始
    [self fetchForeignCurrencyInfo];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 選択中の通過に目印をつける
    self.currencyPickerView.showsSelectionIndicator = YES;
}

- (void)fetchForeignCurrencyInfo {
    
    APIConnectionService *connectionService = [APIConnectionService new];
    
    MainViewController __weak *weakSelf = self;
    [connectionService asyncRequest:^void (NSArray *resultList, NSURLResponse *response) {
        
        if ([resultList count]) {
            weakSelf.currencyInfoList = resultList;
            dispatch_sync(dispatch_get_main_queue(), ^{
                 [weakSelf.currencyPickerView reloadAllComponents];
            });
        } else if (response) {
            
        }
        
        [SVProgressHUD dismiss];
    }
     
    failure:^(NSError *error) {
        
         [SVProgressHUD dismiss];
    }];
}

// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// 行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if ([self.currencyInfoList count]) {
        return [self.currencyInfoList count];
    }
    return 0;
}

// 内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *currencyInfo = self.currencyInfoList[row];
    return currencyInfo.allKeys.firstObject;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

@end

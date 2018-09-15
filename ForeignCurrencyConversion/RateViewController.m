//
//  RateViewController.m
//  ForeignCurrencyConversion
//
//  Created by mmsc on 2018/09/12.
//  Copyright © 2018年 mmsc. All rights reserved.
//

#import "RateViewController.h"
#import "APIConnectionService.h"
#import <SVProgressHUD.h>
#import "RateConversionViewController.h"
#import "UIStoryBoard.h"

@interface RateViewController ()<UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSArray *currencyInfoList; // 通貨リスト
@property (nonatomic, retain) NSMutableArray *selectedCurrency; // 選択中通貨

@property (weak, nonatomic) IBOutlet UIPickerView *currencyPickerView;
@property (weak, nonatomic) IBOutlet UITableView *rateTableView;
@property (weak, nonatomic) IBOutlet UILabel *lastModifiedLabel;

- (IBAction)upDateButtonAction:(id)sender;
- (IBAction)nextButtonAction:(id)sender;

@end

@implementation RateViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _selectedCurrency = [NSMutableArray new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 通信開始
    [self fetchForeignCurrencyInfo];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 選択中の通過に目印をつける
    _currencyPickerView.showsSelectionIndicator = YES;
}

- (void)fetchForeignCurrencyInfo {
    
    // ローディング
    [SVProgressHUD show];
    
    APIConnectionService *connectionService = [APIConnectionService new];
    
    RateViewController __weak *weakSelf = self;
    [connectionService asyncRequest:^void (NSArray *resultList, NSURLResponse *response) {
        
        if ([resultList count]) {
            weakSelf.currencyInfoList = resultList;
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                // 通貨ピッカー更新
                [weakSelf.currencyPickerView reloadAllComponents];
                
                // 最終更新日更新
                [self refreshLastModifiedLabel];
                
                [self.rateTableView reloadData];
                
            });
        } else if (response) {
            
        }
        
        [SVProgressHUD dismiss];
    }
     
    failure:^(NSError *error) {
        
         [SVProgressHUD dismiss];
    }];
}

- (void)refreshLastModifiedLabel {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    [format setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    NSString *StTime = [format stringFromDate:[NSDate date]];
    
    _lastModifiedLabel.text = [NSString stringWithFormat:@"最終更新日時：%@", StTime];
}

// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// 行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if ([_currencyInfoList count]) {
        return [_currencyInfoList count];
    }
    return 0;
}

// 内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *currencyInfo = _currencyInfoList[row];
    return currencyInfo.allKeys.firstObject;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    // 選択中の通貨を設定
    _selectedCurrency = [NSMutableArray new];
   
    NSArray *array = [_currencyInfoList[row] allValues];
    
    for (NSString *key in [array[0] allKeys]) {
        [_selectedCurrency addObject:[NSDictionary dictionaryWithObject:array[0][key] forKey:key]];
    }
    
    // 選択中通貨を保存
    [self setSelectedCurrencyName:[[_currencyInfoList[row] allKeys] firstObject]];
    
    // tableView更新
    [_rateTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_selectedCurrency count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"rateTableViewCell";
    // 再利用できるセルがあれば再利用する
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        // 再利用できない場合は新規で作成
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *targetDictionary = _selectedCurrency[indexPath.row];
    
    // 通貨名
    UILabel *nameLbl = (UILabel *)[cell viewWithTag:1];
    nameLbl.text = [[targetDictionary allKeys] firstObject];
    
    // レート
    UILabel *rateLbl = (UILabel *)[cell viewWithTag:2];
    double rate = [[[targetDictionary allValues] firstObject] doubleValue];
    rateLbl.text = [NSString stringWithFormat:@"%3f", rate];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSString *)selectedCurrencyName {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:@"selectedCurrencyNameKey"];
}

- (void)setSelectedCurrencyName:(NSString *)name {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:name forKey:@"selectedCurrencyNameKey"];
    [ud synchronize];
}

- (IBAction)upDateButtonAction:(id)sender {
    [self fetchForeignCurrencyInfo];
}

- (IBAction)nextButtonAction:(id)sender {
    RateConversionViewController *vc = [UIStoryBoard RateConversion];
    vc.currencyInfoList = _currencyInfoList;
    vc.selectedCurrency = _selectedCurrency;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([[segue identifier] isEqualToString:@"rcSegue"]) {
//        //遷移先のViewController
//        RateConversionViewController *vc = (RateConversionViewController *)[segue destinationViewController];
//
//        vc.selectedCurrency = _selectedCurrency;
//    }
//}

@end

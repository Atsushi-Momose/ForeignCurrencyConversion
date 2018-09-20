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
#import "FCCStoryBoard.h"
#import "UserDefault.h"
#import "Utility.h"
#import "UIAlertController+Utility.h"

#define PICKER_ROW_HEIGHT 50

@interface RateViewController ()<UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource>

// MARK: IBOoutlet
@property (weak, nonatomic) IBOutlet UIPickerView *currencyPickerView;
@property (weak, nonatomic) IBOutlet UITableView *rateTableView;
@property (weak, nonatomic) IBOutlet UILabel *lastModifiedLabel;

// MARK: プロパティ
@property (nonatomic, retain) NSMutableArray *currencyInfoList; // 通貨リスト
@property (nonatomic, retain) NSMutableArray *selectedCurrency; // 選択中通貨
@property (nonatomic) UILabel *preSelectedLb;

@end

@implementation RateViewController

// MARK: View Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _currencyInfoList = [NSMutableArray new];
    _selectedCurrency = [NSMutableArray new];
    
    [Utility showMask];
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

// MARK: 内部メソッド
- (void)fetchForeignCurrencyInfo {
    
    // ローディング
    [SVProgressHUD show];
    
    APIConnectionService *connectionService = [APIConnectionService new];
    
    RateViewController __weak *weakSelf = self;
    [connectionService asyncRequest:^void (NSMutableArray *resultList, NSURLResponse *response) {
        
        if ([resultList count]) {
            weakSelf.currencyInfoList = resultList;
            dispatch_sync(dispatch_get_main_queue(), ^{
                // 画面表示更新
                [weakSelf refresh];
            });
        } else if (response) { // 404等
            
            [SVProgressHUD dismiss];
           
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSString *statusCode = [NSString stringWithFormat:@"statusCode %ld", (long)httpResponse.statusCode];
            [[UIAlertController new] showAlertController:@"通信エラー" message:statusCode];
        }
        
        [SVProgressHUD dismiss];
    }
     
    failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [[UIAlertController new] showAlertController:@"Error" message:error.localizedDescription];
    }];
}

- (void)refresh {
 
    [Utility maskDismiss];
    
    // 最終更新日更新
    [self updateLastModifiedLabel];
    
    // 選択中の通貨情報を通貨リストの先頭に移動
    [self sortCurrencyInfoList];
    
    // pickerViewを選択状態に
    [_currencyPickerView selectRow:0 inComponent:0 animated:NO];
    
    // 通貨ピッカー更新
    [self.currencyPickerView reloadAllComponents];
    
    [self.rateTableView reloadData];
}

- (void)updateLastModifiedLabel {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    [format setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    NSString *StTime = [format stringFromDate:[NSDate date]];
    
    _lastModifiedLabel.text = [NSString stringWithFormat:@"最終更新日時：%@", StTime];
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

// MARK: UIPickerViewDelegate

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

// 行高さ
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return PICKER_ROW_HEIGHT;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *lbl = [UILabel new];
    lbl.tag = 99;
    NSString *title = [[_currencyInfoList[row] allKeys] firstObject];
    
    NSMutableAttributedString *attrStr;
    // フォント
    attrStr = [[NSMutableAttributedString new] initWithString:title];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"HiraKakuProN-W3" size:24.]
                    range:NSMakeRange(0, [attrStr length])];
    
    // 文字色
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor grayColor]
                    range:NSMakeRange(0, [attrStr length])];
    
    lbl.attributedText = attrStr;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.frame = CGRectMake(0, 0, 200, PICKER_ROW_HEIGHT);
    // 角丸
    lbl.layer.masksToBounds = YES;
    lbl.layer.cornerRadius = 5.0;
    
    // 選択中のrowを取得
    NSInteger com0 = [_currencyPickerView selectedRowInComponent:0];
    
    if (row == com0) {
        _preSelectedLb = lbl;
        _preSelectedLb.backgroundColor = [UIColor orangeColor];
        _preSelectedLb.textColor = [UIColor whiteColor];
    }
    return lbl;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _preSelectedLb = (UILabel *)[pickerView viewForRow:row forComponent:component];
    
    // 選択中の通貨を設定
    _selectedCurrency = [NSMutableArray new];
   
    NSArray *array = [_currencyInfoList[row] allValues];
    
    for (NSString *key in [array[0] allKeys]) {
        [_selectedCurrency addObject:[NSDictionary dictionaryWithObject:array[0][key] forKey:key]];
    }
    
    // 選択中通貨を保存
    [UserDefault setSelectedCurrencyName:[[_currencyInfoList[row] allKeys] firstObject]];
    
    [pickerView reloadComponent:0];
    
    // tableView更新
    [_rateTableView reloadData];
}

// MARK: UITableViewDelegate

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
    rateLbl.text = [Utility getValueUpToFiveDecimal:rate];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

// MARK: IBActions

- (IBAction)updateAction:(id)sender {
    [self fetchForeignCurrencyInfo];
}

- (IBAction)nextAction:(id)sender {
    RateConversionViewController *vc = [FCCStoryBoard RateConversion];
    vc.currencyInfoList = [self sortCurrencyInfoList];
    vc.selectedCurrency = _selectedCurrency;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

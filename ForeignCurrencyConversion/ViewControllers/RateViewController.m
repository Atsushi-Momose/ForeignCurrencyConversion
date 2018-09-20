//
//  RateViewController.m
//  ForeignCurrencyConversion
//
//  Created by mmsc on 2018/09/12.
//  Copyright © 2018年 mmsc. All rights reserved.
//

#import "RateViewController.h"
#import "RateConversionViewController.h"
#import "FCCStoryBoard.h"
#import "Utility.h"
#import "RatePresenter.h"

#define PICKER_ROW_HEIGHT 50

@interface RateViewController ()<UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource>

//// MARK: プロパティ
@property (nonatomic, retain) RatePresenter *presenter;

@end

@implementation RateViewController

// MARK: View Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _presenter = [[RatePresenter alloc] initWithRateViewController:self];
    
    [Utility showMask];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // 通信開始
    [_presenter fetchCurrencyData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

// MARK: UIPickerViewDelegate

// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// 行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_presenter.currencyInfoList count];
}

// 行高さ
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return PICKER_ROW_HEIGHT;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *lbl = [UILabel new];
    lbl.tag = 99;
    NSString *title = [[_presenter.currencyInfoList[row] allKeys] firstObject];
    
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
    
    [ _presenter didSelectPickerView:row inComponent:component];
}

// MARK: UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_presenter.selectedCurrency count];
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
    
    NSDictionary *targetDictionary = _presenter.selectedCurrency[indexPath.row];
    
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
    [_presenter fetchCurrencyData];
}

- (IBAction)nextAction:(id)sender {
    RateConversionViewController *vc = [FCCStoryBoard RateConversion];
    vc.currencyInfoList = [_presenter sortCurrencyInfoList];
    vc.selectedCurrency = _presenter.selectedCurrency;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

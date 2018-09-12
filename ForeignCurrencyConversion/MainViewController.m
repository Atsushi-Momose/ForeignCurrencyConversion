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

@interface MainViewController ()<UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource>

// 通貨リスト
@property (nonatomic) NSArray *currencyInfoList;

// 選択中通貨
@property (nonatomic) NSMutableArray *selectedCurrency;

@property (weak, nonatomic) IBOutlet UIPickerView *currencyPickerView;

@property (weak, nonatomic) IBOutlet UITableView *rateTableView;
@property (weak, nonatomic) IBOutlet UILabel *lastModifiedLabel;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // ローディング
    [SVProgressHUD show];

    self.rateTableView.dataSource = self;
    self.rateTableView.delegate = self;
    self.selectedCurrency = [NSMutableArray new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 通信開始
    [self fetchForeignCurrencyInfo];
}

- (void)viewDidAppear:(BOOL)animated {
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
                
                // 通貨ピッカー更新
                [weakSelf.currencyPickerView reloadAllComponents];
                
                // 最終更新日更新
                [self refreshLastModifiedLabel];
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
    
    self.lastModifiedLabel.text = [NSString stringWithFormat:@"最終更新日時：%@", StTime];
}
// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// 行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
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
    
    // 選択中の通貨を設定
    self.selectedCurrency = [NSMutableArray new];
   
    NSArray *array = [self.currencyInfoList[row] allValues];
    
    for (NSString *key in [array[0] allKeys]) {
        [self.selectedCurrency addObject:[NSDictionary dictionaryWithObject:array[0][key] forKey:key]];
    }
    
    // 選択中通貨を保存
    [self setSelectedCurrencyName:[[self.currencyInfoList[row] allKeys] firstObject]];
    
    // tableView更新
    [self.rateTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.selectedCurrency count];
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
    
    NSDictionary *targetDictionary = self.selectedCurrency[indexPath.row];
    
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


@end

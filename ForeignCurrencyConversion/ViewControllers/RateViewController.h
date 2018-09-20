//
//  RateViewController.h
//  ForeignCurrencyConversion
//
//  Created by mmsc on 2018/09/12.
//  Copyright © 2018年 mmsc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RateViewController : UIViewController

// MARK: IBOoutlet
@property (weak, nonatomic) IBOutlet UIPickerView * _Nullable currencyPickerView;
@property (weak, nonatomic) IBOutlet UITableView * _Nullable rateTableView;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable lastModifiedLabel;
@property (nonatomic) UILabel * _Nonnull preSelectedLb;

@end


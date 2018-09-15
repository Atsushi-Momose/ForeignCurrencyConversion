//
//  RateConversionViewController.m
//  ForeignCurrencyConversion
//
//  Created by mmsc on 2018/09/12.
//  Copyright © 2018年 mmsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RateConversionViewController.h"
#import <MMNumberKeyboard.h>
#import "UserDefault.h"

@interface RateConversionViewController() <MMNumberKeyboardDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain) NSDictionary *targetCurrencyInfo; // 換算元の通貨
@property (nonatomic, retain) NSString *convertCurrency; // 換算先の通過

@property (weak, nonatomic) IBOutlet UIView *keyBoardView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *currencySelectCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *convertCurrencyCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end


@implementation RateConversionViewController

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self becomeFirstResponder];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [_inputTextField canBecomeFirstResponder];
    [_inputTextField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    MMNumberKeyboard *keyboard = [[MMNumberKeyboard alloc] initWithFrame: _keyBoardView.frame];
    keyboard.allowsDecimalPoint = YES;
    keyboard.delegate = self;
    [self.view addSubview:keyboard];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_currencyInfoList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [UICollectionViewCell new];
    
    NSDictionary *targetDictionary = _currencyInfoList[indexPath.row];
    
    if (collectionView == _currencySelectCollectionView) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"selectCollectionCell" forIndexPath:indexPath];
        
        // 前の画面で選択中の通貨かつ本画面のcurrencySelectCollectionViewで通貨を選択していない場合
        if ([[[targetDictionary allKeys] firstObject] isEqualToString:[UserDefault selectedCurrencyName]] && ![_targetCurrencyInfo count]) {
            [cell setSelected:YES];
       }
        
    } else if (collectionView == _convertCurrencyCollectionView) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"convertCollectionCell" forIndexPath:indexPath];
    }
    
    // 通貨名
    UILabel *nameLbl = (UILabel *)[cell.contentView viewWithTag:1];
    [nameLbl setText:[[targetDictionary allKeys] firstObject]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == _currencySelectCollectionView) { // 換算元
        
        NSDictionary *targetDictionary = _currencyInfoList[indexPath.row];
        
        if (![[[targetDictionary allKeys] firstObject] isEqualToString:[[_targetCurrencyInfo allKeys] firstObject]]) {
            _resultLabel.text = nil;
        }
        
        _targetCurrencyInfo = targetDictionary;
        
        // 前の画面で選択した通貨のハイライトをここで戻す
        if (![[[targetDictionary allKeys] firstObject] isEqualToString:[UserDefault selectedCurrencyName]] && [_targetCurrencyInfo count]) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            [_currencySelectCollectionView reloadItemsAtIndexPaths:@[index]];
        }
    } else { // 換算先
        
         NSDictionary *targetDictionary = _currencyInfoList[indexPath.row];
        _convertCurrency = [[targetDictionary allKeys] firstObject];
        
        if (![[[targetDictionary allKeys] firstObject] isEqualToString:[[_targetCurrencyInfo allKeys] firstObject]]) {
            _resultLabel.text = nil;
        }
    }
    
    // 換算
    [self rateConvertingCalculation];
}

- (void)rateConvertingCalculation {
    
    if (_inputTextField.text.length == 0 || ![_targetCurrencyInfo count] || _convertCurrency.length == 0) {
        return;
    }
    // 同じ通貨を選択した場合
    if ([[[_targetCurrencyInfo allKeys] firstObject] isEqualToString:_convertCurrency]) {
        _resultLabel.text = _inputTextField.text;
        return;
    }

    // 換算先通貨のレート
    double convertCurrencyValue = [[[_targetCurrencyInfo allValues][0] valueForKey:_convertCurrency] doubleValue];
    
    // 入力値
    double inputValue = _inputTextField.text.doubleValue;

    double result = convertCurrencyValue * inputValue;
    
    _resultLabel.text = [NSString stringWithFormat:@"%3f", result];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)numberKeyboardShouldReturn:(MMNumberKeyboard *)numberKeyboard {
    [_inputTextField addTarget:self action:@selector(didChangeTextField) forControlEvents:UIControlEventEditingChanged];
    return YES;
}

- (BOOL)numberKeyboard:(MMNumberKeyboard *)numberKeyboard shouldInsertText:(NSString *)text {
    [_inputTextField addTarget:self action:@selector(didChangeTextField) forControlEvents:UIControlEventEditingChanged];
    return YES;
}

- (BOOL)numberKeyboardShouldDeleteBackward:(MMNumberKeyboard *)numberKeyboard {
    [_inputTextField addTarget:self action:@selector(didChangeTextField) forControlEvents:UIControlEventEditingDidEnd];
    return YES;
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didChangeTextField {
    if (![_inputTextField.text length]) {
        _resultLabel.text = nil;
    }
    
    [self rateConvertingCalculation];
}

@end




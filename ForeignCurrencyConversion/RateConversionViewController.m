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

@interface RateConversionViewController() <MMNumberKeyboardDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
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
    
    [self becomeFirstResponder];
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
    
    if (collectionView == _currencySelectCollectionView) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"selectCollectionCell" forIndexPath:indexPath];
    } else if (collectionView == _convertCurrencyCollectionView) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"convertCollectionCell" forIndexPath:indexPath];
    }
    
    NSDictionary *targetDictionary = _currencyInfoList[indexPath.row];
    
    // 通貨名
    UILabel *nameLbl = (UILabel *)[cell.contentView viewWithTag:1];
    [nameLbl setText:[[targetDictionary allKeys] firstObject]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 選択されたセルを取得
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    //    cell.backgroundColor = [cell isSelected] ? [cell setBackgroundColor:[UIColor blueColor]] : [cell setBackgroundColor:[UIColor whiteColor]];
    
    if (collectionView == _currencySelectCollectionView) { // 換算元
        
        
        
        
    } else { // 換算先
        
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)numberKeyboardShouldReturn:(MMNumberKeyboard *)numberKeyboard {
    return YES;
}

- (BOOL)numberKeyboard:(MMNumberKeyboard *)numberKeyboard shouldInsertText:(NSString *)text {
    return YES;
}

- (BOOL)numberKeyboardShouldDeleteBackward:(MMNumberKeyboard *)numberKeyboard {
    return YES;
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end




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

@interface RateConversionViewController() <MMNumberKeyboardDelegate>

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UIView *keyBoardView;

@end


@implementation RateConversionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    MMNumberKeyboard *keyboard = [[MMNumberKeyboard alloc] initWithFrame: _keyBoardView.frame];
    keyboard.allowsDecimalPoint = YES;
    keyboard.delegate = self;
    
    // Configure an example UITextField.
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.inputView = keyboard;
    
    [self.view addSubview:keyboard];
    
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end




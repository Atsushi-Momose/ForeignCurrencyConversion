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
@property (weak, nonatomic) IBOutlet UIView *keyBoardView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;


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




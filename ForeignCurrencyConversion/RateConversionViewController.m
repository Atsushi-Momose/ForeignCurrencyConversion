//
//  RateConversionViewController.m
//  ForeignCurrencyConversion
//
//  Created by mmsc on 2018/09/12.
//  Copyright © 2018年 mmsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RateConversionViewController.h"
#import <SimpleNumpad/SimpleNumpad.h>

@interface RateConversionViewController() <IDPNumpadViewControllerDelegate>

@property (nonatomic) IDPNumpadViewController *numpadViewController;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end


@implementation RateConversionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.numpadViewController = [IDPNumpadViewController numpadViewControllerWithStyle:IDPNumpadViewControllerStyleCalcApp inputStyle:IDPNumpadViewControllerInputStyleNumber showNumberDisplay:false];
    self.numpadViewController.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // キーパッドを表示
    [self presentViewController:self.numpadViewController animated:true completion:^{}];
}

@end




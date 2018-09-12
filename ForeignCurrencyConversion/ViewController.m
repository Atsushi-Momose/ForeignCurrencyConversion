//
//  ViewController.m
//  ForeignCurrencyConversion
//
//  Created by mmsc on 2018/09/12.
//  Copyright © 2018年 mmsc. All rights reserved.
//

#import "ViewController.h"
#import "APIConnectionService.h"
#import <SVProgressHUD.h>

@interface ViewController ()

@property (nonatomic) NSDictionary *currencyInfo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [SVProgressHUD show];
    
    // 通信開始
    [self fetchForeignCurrencyInfo];
}

- (void)fetchForeignCurrencyInfo {
    
    APIConnectionService *connectionService = [APIConnectionService new];
    
    ViewController __weak *weakSelf = self;
    [connectionService asyncRequest:^void (NSDictionary *contentsList, NSURLResponse *response) {
        
        if ([contentsList count]) {
            weakSelf.currencyInfo = contentsList;
        } else if (response) {
            
        }
        
        [SVProgressHUD dismiss];
    }
     
    failure:^(NSError *error) {
        
         [SVProgressHUD dismiss];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

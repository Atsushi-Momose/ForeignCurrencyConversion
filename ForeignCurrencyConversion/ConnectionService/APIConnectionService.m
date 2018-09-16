//
//  APIConnectionService.m
//  ForeignCurrencyConversion
//
//  Created by mmsc on 2018/09/11.
//  Copyright © 2018年 mmsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIConnectionService.h"

#define TIME_OUT_REQUEST    5
#define TIME_OUT_RESOURCE   20

@interface APIConnectionService()<NSURLSessionDelegate>

@property (nonatomic) NSURLSession *sessionConnect;
@property (nonatomic) NSMutableData *recevedData;

@end

@implementation APIConnectionService

// 外部サーバから情報を取得
- (void)asyncRequest:(void(^)(NSMutableArray *result, NSURLResponse *response))completionhandler failure:(void(^)(NSError *))failure
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    // セッション作成
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // タイムアウトの設定
    sessionConfig.timeoutIntervalForRequest  =  TIME_OUT_REQUEST;
    sessionConfig.timeoutIntervalForResource =  TIME_OUT_RESOURCE;
    
    // 通信設定
    self.sessionConnect = [NSURLSession sessionWithConfiguration: sessionConfig
                                                        delegate: self
                                                   delegateQueue: [NSOperationQueue mainQueue]];
    // Header 作成
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL            :[NSURL URLWithString:@"https://hiring.coiney.com/exchange_rates"]];
    [request setCachePolicy    :NSURLRequestReloadIgnoringLocalCacheData];
    [request setValue          :@"identity"   forHTTPHeaderField:@"Accept-encording"];
    [request setValue          :@"no-cache"   forHTTPHeaderField:@"Cache-Control"];
    [request setHTTPMethod     :@"GET"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                  {
                                      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                      if (httpResponse.statusCode != 200) {
                                          completionhandler(nil, response);
                                      }
                                      
                                      NSString *statusCode = [NSString stringWithFormat:@"@%@", httpResponse];
                                      NSLog(@"%@", statusCode);
                                      
                                      // 通信が異常終了した場合
                                      if (error) {
                                          if (failure) {
                                              failure(error);
                                          }
                                          return;
                                      }
                                      
                                      // 通信が正常終了した場合
                                      NSError *jsonError = nil;
                                      
                                      NSMutableArray *result = [NSMutableArray new];
                                      
                                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                      
                                      for (NSString *str in dic) {
                                          [result addObject:[NSDictionary dictionaryWithObject:dic[str] forKey:str]];
                                      }
                                      
                                      // JSONエラーチェック
                                      if (jsonError != nil) {
                                          if (error) {
                                              failure(jsonError);
                                          }
                                      }
                                      
                                      // completionブロックで結果を返す
                                      if (completionhandler) {
                                          completionhandler(result, response);
                                      }
                                  }];
    // 通信開始
    [task resume];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    if (httpResponse.statusCode == 200) {
        
        completionHandler(NSURLSessionResponseAllow);   // 続ける
        
    } else {
        
        if (httpResponse.statusCode == 404 || httpResponse.statusCode == 500) {
            
        }
        
        // error.code = -999で終了メソッドが呼ばれる
        completionHandler(NSURLSessionResponseCancel);  // 止める
    }
}

@end


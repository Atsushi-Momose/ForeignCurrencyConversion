//
//  APIConnectionService.h
//  ForeignCurrencyConversion
//
//  Created by mmsc on 2018/09/12.
//  Copyright © 2018年 mmsc. All rights reserved.
//

@interface APIConnectionService : NSObject

- (void)asyncRequest:(void(^)(NSMutableArray *result, NSURLResponse *response))completionhandler failure:(void(^)(NSError *))failure;

@end

//
//  TFNetworkEngine.h
//  TFNetworkDemo
//
//  Created by Kevin on 2016/12/9.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFNetworkRequest.h"

@interface TFNetworkEngine : NSObject


-(void)PostRequestWithURL:(NSString *)urlString
                   params:(NSDictionary *)params
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;


-(void)GetRequestWithURL:(NSString *)urlString
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;



@end

//
//  TFNetworkEngine.m
//  TFNetworkDemo
//
//  Created by Kevin on 2016/12/9.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import "TFNetworkEngine.h"

static NSString *HTTP_POST = @"POST";
static NSString *HTTP_GET  = @"GET";

@implementation TFNetworkEngine


#pragma mark - public method

- (void)PostRequestWithURL:(NSString *)urlString
                    params:(NSDictionary *)params
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    
    TFNetworkRequest *request = [[TFNetworkRequest alloc] initWithRequestURL:urlString
                                                                  httpMethod:HTTP_POST
                                                                     success:success
                                                                     failure:failure];
    NSLog(@"url = %@,params = %@",urlString,params);
    if (params) {
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:params
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        [request setPostBody:postData];
    }
    
    [request start];
}


- (void)GetRequestWithURL:(NSString *)urlString
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    
    TFNetworkRequest *request = [[TFNetworkRequest alloc] initWithRequestURL:urlString
                                                                  httpMethod:HTTP_GET
                                                                     success:success
                                                                     failure:failure];
    NSLog(@"url = %@",urlString);
    [request start];
}



@end

//
//  TFNetworkRequest.h
//  TFNetworkDemo
//
//  Created by Kevin on 2016/12/9.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//回调结果
typedef void (^requestDidSucess)(id responseObject);

typedef void (^requestDidFail)(NSError *error);


@interface TFNetworkRequest : NSObject<NSURLSessionDataDelegate>


@property (nonatomic, strong) NSMutableURLRequest *request;

@property (nonatomic, strong) NSURLSession  *session;

@property (nonatomic, strong) NSURLSessionTask *requestSessionTask;

@property (nonatomic, strong) NSMutableData *requestData;

@property (nonatomic, strong) requestDidSucess sucessBlock;

@property (nonatomic, strong) requestDidFail failBlock;


- (id)initWithRequestURL:(NSString *)urlString
              httpMethod:(NSString *)method
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;


- (void)setPostBody:(NSData *)postData;


- (void)setFormPostBody:(NSData *)postData;

/*
 图片上传
 imageData  图片二进制
 imageName  图片名
 key        参数名
 */
- (void)uploadImageData:(NSData *)imageData
              imageName:(NSString *)imageName
                    key:(NSString *)key;

- (void)start;



@end

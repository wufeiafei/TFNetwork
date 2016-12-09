//
//  TFNetworkRequest.m
//  TFNetworkDemo
//
//  Created by Kevin on 2016/12/9.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import "TFNetworkRequest.h"

@implementation TFNetworkRequest


-(id)initWithRequestURL:(NSString *)urlString
             httpMethod:(NSString *)method
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    
    if (self = [super init]) {
        
        NSURL *url = [NSURL URLWithString:urlString];
        _request = [[NSMutableURLRequest alloc] initWithURL:url
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:20.0];
        _sucessBlock = success;
        _failBlock = failure;
        
        if (method) {
            [_request setHTTPMethod:method];
        }
    }
    return self;
}



- (void)setPostBody:(NSData *)postData {
    
    [_request setHTTPMethod:@"POST"];
    NSString *postLength = [NSString stringWithFormat:@"%ld",[postData length]];
    [_request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [_request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:postData];
    
}


- (void)setFormPostBody:(NSData *)postData {
    
    [_request setHTTPMethod:@"POST"];
    [_request setHTTPBody:postData];
    
}

- (void)uploadImageData:(NSData *)imageData
              imageName:(NSString *)imageName
                    key:(NSString *)key {
    
    [_request setHTTPMethod:@"POST"];
    
    NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuid));
    CFRelease(uuid);
    NSString *stringBoundary = [NSString stringWithFormat:@"0xKhTmLbOuNdArY-%@",uuidString];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=%@; boundary=%@",charset,stringBoundary];
    [_request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    //文件起始标识
    NSString *startBoundary = [NSString stringWithFormat:@"--%@\r\n",stringBoundary];
    //文件名和参数
    NSString *name = imageName;
    if (!name) {
        name = @"image.png";
    }
    NSString *fileName = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, name];
    //上传格式
    NSString *postContentType = [NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", @"application/octet-stream"];
    //结尾标识
    NSString *endBoundary = [NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary];
    
    NSMutableData *data = [NSMutableData data];
    [data appendData:[self postDataForString:startBoundary]];
    [data appendData:[self postDataForString:fileName]];
    [data appendData:[self postDataForString:postContentType]];
    [data appendData:imageData];
    [data appendData:[self postDataForString:endBoundary]];
    [_request setHTTPBody:data];
}



- (NSData *)postDataForString:(NSString *)postString {
    
    return [postString dataUsingEncoding:NSUTF8StringEncoding];
    
}

- (void)start {
    
    _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                             delegate:self
                                        delegateQueue:[[NSOperationQueue alloc] init]];
    
    //创建任务
    _requestSessionTask = [_session dataTaskWithRequest:_request];
    
    //启动任务
    [_requestSessionTask resume];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}



#pragma mark -- NSURLSessionTaskDelegate
//请求成功或者失败（如果失败，error有值）
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (!error) {
        if (_sucessBlock) {
            _sucessBlock(_requestData);
        }
    }
    else
    {
        if (_failBlock) {
            _failBlock(error);
        }
    }
}


#pragma mark - NSURLSessionDataDelegate
// 接收到服务器的响应
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    
    completionHandler(NSURLSessionResponseAllow);
    _requestData = [NSMutableData data];
    
}


// 接收到服务器的数据
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    
    [_requestData appendData:data];
    
}


@end

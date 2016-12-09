//
//  ViewController.m
//  TFNetworkDemo
//
//  Created by Kevin on 2016/12/9.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import "ViewController.h"
#import "TFNetworkEngine.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *btn = [[UIButton alloc] init];
    btn.frame  = CGRectMake(30, 100, self.view.frame.size.width - 60, 40);
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -- action
-(void)btnPressed:(id)sender
{
    
    [self requestTest];
    
}


-(void)requestTest
{
    
    TFNetworkEngine *networkEngine = [[TFNetworkEngine alloc] init];
    
    NSString *urlString = @"demo";
    [networkEngine GetRequestWithURL:urlString
                             success:^(id responseObject) {
                                 id  obj = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                           options:NSJSONReadingMutableLeaves
                                                                             error:nil];
                                 NSLog(@"obj:%@",obj);
                             }
                             failure:^(NSError *error) {
                                 
                                 NSLog(@"error:%@",error);
                             }];
    
    
    
    
}


@end

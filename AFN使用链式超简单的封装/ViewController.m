//
//  ViewController.m
//  AFN使用链式超简单的封装
//
//  Created by 周尊贤 on 2018/1/12.
//  Copyright © 2018年 周尊贤. All rights reserved.
//

#import "ViewController.h"
#import "LLNetWorkTools.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //post
    [LLNetWork.param(@{@"":@""}).urlStr(@"") POSTWithSucces:^(id responseObject) {
        
    } error:^(NSError * error) {
        
    }];
    
    //get
    [LLNetWork.param(nil).urlStr(@"") GETWithSucces:^(id responseObject) {
        
    } error:^(NSError * error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

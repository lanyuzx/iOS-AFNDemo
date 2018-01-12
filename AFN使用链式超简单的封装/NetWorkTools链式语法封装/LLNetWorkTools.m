//
//  LLNetWorkTools.m
//  ReactiveCocoaStudy
//
//  Created by 周尊贤 on 2017/11/13.
//  Copyright © 2017年 周尊贤. All rights reserved.
//

#import "LLNetWorkTools.h"
#import <AFNetworking/AFNetworking.h>
#import "MBProgressHUD+HUD.h"
@interface LLNetWorkTools()
@property (nonatomic,copy) NSDictionary * tempParam;

@property (nonatomic,copy) NSString * tempUrlString;
@end
@implementation LLNetWorkTools


+(instancetype)shareTools {
    static dispatch_once_t onceToken;
    static LLNetWorkTools *tools;
    dispatch_once(&onceToken, ^{
        tools = [[self alloc]init];
    });
    return tools;
}

-(void )POSTWithSucces:(success)successResult error:(error)errorResult {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf8" forHTTPHeaderField:@"Content-Type"];
    //请求序列化器
    manager.responseSerializer= [AFHTTPResponseSerializer serializer];
    //解析序列化器
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //配置超时时长
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", nil];
 
        [manager POST:self.tempUrlString parameters:self.tempParam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successResult(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            errorResult(error);
        }];
}

-(void )GETWithSucces:(success)successResult error:(error)errorResult {
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf8" forHTTPHeaderField:@"Content-Type"];
    //请求序列化器
    manager.responseSerializer= [AFHTTPResponseSerializer serializer];
    //解析序列化器
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //配置超时时长
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", nil];
    
        [manager GET:self.tempUrlString parameters:self.tempParam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successResult(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            errorResult(error);
        }];
    
}

-(void)setDownloadWithTaskUrl:(NSString *)downURL saveName:(NSString *)filePathName downLoadBlock:(DownLoadBlock) block {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downURL]];
    [MBProgressHUD showCircularHUDProgress];
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLSessionDownloadTask * downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        ;
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD getHUDProgress].progress = downloadProgress.fractionCompleted;
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cachesPath = [NSString stringWithFormat:@"%@/JLCCaches", pathDocuments];
        // 判断文件夹是否存在，如果不存在，则创建
        if (![fileManager fileExistsAtPath:cachesPath]) {
            [fileManager createDirectoryAtPath:cachesPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        cachesPath = [cachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",filePathName]];
        return [NSURL fileURLWithPath:cachesPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        block([filePath path]);
    }];
    //启动下载
    [downloadTask resume];


}


-(LLNetWorkTools *(^)(NSDictionary *))param {
    
    return ^id (NSDictionary * param) {
        self.tempParam  = param;
        return self;
    };
}
-(LLNetWorkTools *(^)(NSString *))urlStr {
    
    return ^id (NSString * urlString) {
        self.tempUrlString = urlString;
        return self;
    };
}
@end

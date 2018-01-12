//
//  LLNetWorkTools.h
//  ReactiveCocoaStudy
//
//  Created by 周尊贤 on 2017/11/13.
//  Copyright © 2017年 周尊贤. All rights reserved.
//
#import <Foundation/Foundation.h>
typedef void(^success)(id);
typedef void(^error)(NSError*);
typedef void(^DownLoadBlock)(NSString * filePath);
#define LLNetWork [LLNetWorkTools shareTools]
@interface LLNetWorkTools : NSObject


+(instancetype)shareTools;

/// 参数
- (LLNetWorkTools *(^)(NSDictionary * param)) param;
/// 链接
- (LLNetWorkTools *(^)(NSString * urlStr)) urlStr;

-(void )POSTWithSucces:(success)successResult error:(error)errorResult;

-(void)GETWithSucces:(success)successResult error:(error)errorResult;

/**
 网络下载工具类
 
 @param downURL 下载的文件的URL
 @param filePathName 保存文件夹的名称
 @param block 回调保存本地的文件夹路径
 */
-(void)setDownloadWithTaskUrl:(NSString *)downURL saveName:(NSString *)filePathName downLoadBlock:(DownLoadBlock) block;


@end

//
//  UncaughtExceptionHandler.h
//  全局异常捕获
//
//  Created by 刘晓飞 on 13-8-5.
//  Copyright (c) 2013年 LiuXiaofei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Loger.h"
#import "define_constant.h"

@interface UncaughtExceptionHandler : NSObject{
    BOOL dismissed;
    NSString *errorReason;
    NSString *errorMessage;
    ASIFormDataRequest *request;//ASIHttpRequest对象，用于对此框架进行内存管理
}
@property(retain,nonatomic)ASIFormDataRequest *request;
@end
void HandleException(NSException *exception);
void SignalHandler(int signal);


void InstallUncaughtExceptionHandler(void);


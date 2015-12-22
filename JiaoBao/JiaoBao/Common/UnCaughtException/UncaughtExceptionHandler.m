//
//  UncaughtExceptionHandler.m
//  全局异常捕获
//
//  Created by 刘晓飞 on 13-8-5.
//  Copyright (c) 2013年 LiuXiaofei. All rights reserved.
//

#import "UncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "dm.h"

//NSString * const ASIHTTPREQUESTURL = (CALL_LIANXIN==1?@"http://log.umnet.cn:8080/struts/submit.intwork":@"http://log.umcall.cn:8080/struts/submit.intwork");
NSString * const ASIHTTPREQUESTURL = @"http://58.56.123.189:8016/andro.aspx";

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";

NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";

NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

@implementation UncaughtExceptionHandler

@synthesize request;

- (void)dealloc
{
    [self.request clearDelegatesAndCancel];
    [self.request release];
    [super dealloc];
}

+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (
         i = UncaughtExceptionHandlerSkipAddressCount;
         i < UncaughtExceptionHandlerSkipAddressCount +
         UncaughtExceptionHandlerReportAddressCount;
         i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex
{
    if (anIndex == 0)
    {
        [self exitApplication];
    }else if (anIndex==1) {
        D("错误原因：%@\n错误信息：%@",errorReason,errorMessage);
        [self sendRequestWithProb:errorReason errorMessage:errorMessage];
    }
}

- (void)validateAndSaveCriticalApplicationData
{
    
}

- (void)handleException:(NSException *)exception
{
    [self validateAndSaveCriticalApplicationData];
    
    UIAlertView *alert =
    [[[UIAlertView alloc]
      initWithTitle:NSLocalizedString(@"抱歉，程序出现了异常", nil)
      message:[NSString stringWithFormat:NSLocalizedString(
                                                           @"如果点击继续，程序有可能会出现其他的问题，建议您还是点击退出按钮并重新打开\n\n"
                                                           @"异常原因如下:\n%@\n%@", nil),
               [exception reason],
               [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]]
      delegate:self
      cancelButtonTitle:NSLocalizedString(@"让它崩了吧", nil)
      otherButtonTitles:NSLocalizedString(@"提交BUG", nil), nil]
     autorelease];
    [alert show];
    
    //
//    errorReason = [NSString stringWithFormat:@"%@ from %@",[exception reason],[[NSUserDefaults standardUserDefaults] valueForKey:BUGFROM]];
    errorReason = [NSString stringWithFormat:@"%@ from ",[exception reason]];
    errorMessage = [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey];
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    
    while (!dismissed)
    {
        for (NSString *mode in (NSArray *)allModes)
        {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    
    CFRelease(allModes);
    
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
    {
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
    }
}

//发送Http请求到google服务器
-(void)sendRequestWithProb:(NSString *)prob errorMessage:(NSString *)message
{
    NSString *url = [NSString stringWithFormat:ASIHTTPREQUESTURL];
    NSURL *myUrl = [NSURL URLWithString:url];
    self.request = [ASIFormDataRequest requestWithURL:myUrl];
    [self.request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [self.request addRequestHeader:@"charset" value:@"UTF8"];
    [self.request setRequestMethod:@"POST"];
    [self.request setDelegate:self];
    [self.request addPostValue:prob forKey:@"mobilestr"];
    [self.request addPostValue:message forKey:@"errorstr"];
    [self.request addPostValue:@"ios" forKey:@"frmsys"];
//    NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
//    [dateFormatter setAMSymbol:@"AM"];
//    [dateFormatter setPMSymbol:@"PM"];
//    [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mmaaa"];
//    NSDate *date = [NSDate date];
//    NSString * s = [dateFormatter stringFromDate:date];
//    NSDictionary *param = [[NSDictionary alloc]initWithObjectsAndKeys:s,@"time",appVersion,@"version",@"iPhone",@"mobileInfo",[NSString stringWithFormat:@"%@\n%@",prob,message],@"message",@"ios",@"platform",[[NSUserDefaults standardUserDefaults]valueForKey:BUGFROM],@"view",nil];
//    NSMutableDictionary *tempDic=[[NSMutableDictionary alloc] initWithDictionary:param];
//    //遍历字典的方法，temp即为key值
//    for (NSString *temp in tempDic.allKeys) {
//        [self.request addPostValue:[tempDic objectForKey:temp] forKey:temp];  //POST传递数据
//    }
//    [param release];
//    [tempDic release];
    [self.request startSynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)_request
{
    NSData *responseData = [_request responseData];
    NSString *dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    D("请求成功，返回的字符串是：%@",dataString);
    [self exitApplication];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    D("ASIHTTPRequest 请求失败！");
    [self exitApplication];
}

//-------------------------------- 退出程序 -----------------------------------------//

- (void)exitApplication {
    
    exit(0);
    
}

@end

void HandleException(NSException *exception)
{
    D("exception:%@", exception);
    NSString *errortemp = [NSString stringWithFormat:@"%@",exception];
    NSArray *callStack = [UncaughtExceptionHandler backtrace];
    for (int i=0; i<[callStack count]; i++) {
        D("callStack:%@",[callStack objectAtIndex:i]);
    }
//    D("error reason:%@ from %@",[exception reason],[[NSUserDefaults standardUserDefaults] valueForKey:BUGFROM]);
//    D("NSUserDefault standerdUserdefaults:%@", [NSUserDefaults standardUserDefaults]);
//    NSString *errorReasonx = [Loger getLogString];
//    NSString *errorMessagex = [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey];
    
    //获取当前版本号
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleShortVersionString"];
    NSString *temp = [NSString stringWithFormat:@"test--教宝-求知--号:%@,    密码:%@,    版本号:%@,     系统版本号:%f     界面:%@,   bug:%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"],[[NSUserDefaults standardUserDefaults] valueForKey:@"PassWD"],versionNum,[[[UIDevice currentDevice] systemVersion] floatValue],[[NSUserDefaults standardUserDefaults] valueForKey:BUGFROM],errortemp];
    [[[[UncaughtExceptionHandler alloc] init] autorelease] sendRequestWithProb:temp errorMessage:errortemp];
}

void SignalHandler(int signal)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    
    NSMutableDictionary *userInfo =
    [NSMutableDictionary
     dictionaryWithObject:[NSNumber numberWithInt:signal]
     forKey:UncaughtExceptionHandlerSignalKey];
    
    NSArray *callStack = [UncaughtExceptionHandler backtrace];
    
    [userInfo
     setObject:callStack
     forKey:UncaughtExceptionHandlerAddressesKey];
    
    [[[[UncaughtExceptionHandler alloc] init] autorelease]
     performSelectorOnMainThread:@selector(handleException:)
     withObject:
     [NSException
      exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
      reason:
      [NSString stringWithFormat:
       NSLocalizedString(@"Signal %d was raised.", nil),
       signal]
      userInfo:
      [NSDictionary
       dictionaryWithObject:[NSNumber numberWithInt:signal]
       forKey:UncaughtExceptionHandlerSignalKey]]
     waitUntilDone:YES];
}

void InstallUncaughtExceptionHandler(void)
{
    NSSetUncaughtExceptionHandler(&HandleException);
    signal(SIGABRT, SignalHandler);
}


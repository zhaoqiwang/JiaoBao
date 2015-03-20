//
//  SignInHttp.m
//  JiaoBao
//
//  Created by songyanming on 15/3/6.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "SignInHttp.h"
#import "JSONKit.h"

@implementation SignInHttp
static  SignInHttp*__instance;

+(SignInHttp *)getInstance
{
    @synchronized ([SignInHttp class])
    {
        if (!__instance)
        {
            __instance = [[SignInHttp alloc] init];
            
        }
        
    }
    
    
    return __instance;
}

-(void)getDelayedTime:(NSString *)UnitID;
{
    NSString *urlString = @"http://58.56.66.218:8082/WorkPlanMobileInterface/WorkPlanGetReportedDelayDateByUnitID";
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:UnitID forKey:@"UnitID"];
    request.userInfo = [NSDictionary dictionaryWithObject:UnitID forKey:@"UID"];
    request.tag = 0;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void)uploadschedule:(NSDictionary*)dic
{
    
    if ([NSJSONSerialization isValidJSONObject:dic])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];

        NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        //NSLog(@"Register JSON:%@",[[NSString alloc] initWithData:tempJsonData encoding:NSUTF8StringEncoding]);
        
        NSURL *url = [NSURL URLWithString:@"http://58.56.66.218:8082/WorkPlanMobileInterface/WorkPlanAddContent"];
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
        [request addRequestHeader:@"Content-Type" value:@"text/xml"];
        [request addRequestHeader:@"charset" value:@"UTF8"];
        [request setRequestMethod:@"POST"];
        NSLog(@"jsonStr = %@",jsonStr);
        [request addPostValue:jsonStr forKey:@"Data"];
        [request setDelegate:self];
        [request startAsynchronous];
        request.tag = 1;
        NSError *error1 = [request error];
        if (!error1) {
            NSString *response = [request responseString];
            
            NSLog(@"Test：%@",response);
        }
    }
    
    
}
-(void)querySchedule:(NSDictionary*)dic
{
    NSString *urlString = @"http://58.56.66.218:8082/WorkPlanMobileInterface/GetWorkPlanInfoByUnitIDUserIDDate";
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    NSString *UIDStr = [NSString stringWithFormat:@"%d",[dm getInstance].UID];
    NSString *jiaobaohao = [dm getInstance].userInfo.UserID;


    [request addPostValue:UIDStr forKey:@"UnitID"];
    [request addPostValue:jiaobaohao forKey:@"UserID"];
    [request addPostValue:[dic objectForKey:@"WorkPlanDate"]  forKey:@"WorkPlanDate"];
    //request.userInfo = [NSDictionary dictionaryWithObject:UnitID forKey:@"UID"];
    request.tag = 2;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
    
}

-(void)getUnitGroups:(NSUInteger)UID
{
    NSLog(@"UID = %ld",UID);
    NSString *urlString = [NSString stringWithFormat:@"%@/Basic/getUnitGroups",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    NSString *unitID = [NSString stringWithFormat:@"%lu",(unsigned long)UID];
    [request addPostValue:unitID forKey:@"UID"];
    request.userInfo = [NSDictionary dictionaryWithObject:unitID forKey:@"UID"];
    request.tag = 3;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
    
}


- (void)requestFinished:(ASIHTTPRequest *)_request{
    if(_request.tag == 0)
    {
        NSData *responseData = [_request responseData];
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        NSString* dataString = [[NSString alloc] initWithData:responseData encoding:encoding];
        NSDictionary *dicList = [dataString objectFromJSONString];
        NSLog(@"dataString = %@",dataString);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GetDelayedTime" object:dicList];
        
    }
    if(_request.tag == 1)
    {
        NSData *responseData = [_request responseData];
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        NSString* dataString = [[NSString alloc] initWithData:responseData encoding:encoding];
        NSLog(@"UpLoadResult = %@",dataString);
        NSDictionary *dicList = [dataString objectFromJSONString];

        [[NSNotificationCenter defaultCenter]postNotificationName:@"getUpLoadResult" object:dicList];
        
    }
    if(_request.tag == 2)
    {
        NSData *responseData = [_request responseData];
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        NSString* dataString = [[NSString alloc] initWithData:responseData encoding:encoding];
        NSLog(@"dataString = %@",dataString);

        NSDictionary *dicList = [dataString objectFromJSONString];
        NSArray *dataList = [dicList  objectForKey:@"Data"];
        NSLog(@"dataList = %@",dataList);
        if(![dataList isEqual:[NSNull null]])
        {

                    [[NSNotificationCenter defaultCenter]postNotificationName:@"getQueryResult" object:dataList];
            
        
        }

    }
    if(_request.tag == 3)
    {
        NSData *responseData = [_request responseData];
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        NSString* dataString = [[NSString alloc] initWithData:responseData encoding:encoding];
        NSLog(@"tag3 = %@",dataString);
        NSDictionary *UnitGroupInfoDic = [dataString objectFromJSONString];
        NSString *dataStr = [UnitGroupInfoDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:dataStr Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        NSLog(@"str000= %@",str000);
        NSArray *groupArr = [str000 objectFromJSONString];

        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"getUnitGroups" object:groupArr];
        
    }


    }





@end

//
//  SignInHttp.m
//  JiaoBao
//
//  Created by songyanming on 15/3/6.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "SignInHttp.h"
#import "JSONKit.h"
#import "SVProgressHUD.h"

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
-(void)getTime
{
    NSString *urlString = [NSString stringWithFormat:@"%@Account/getcurTime",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    request.tag = 6;
    [request startAsynchronous];
}
-(void)getSignInAddress
{
    NSString *urlString = @"http://58.56.66.218:8084/InterAppSignInAddress/GetSignInAddJsonData";
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    NSString *uintId = [NSString stringWithFormat:@"%d",[dm getInstance].UID];
    [request addPostValue:uintId forKey:@"ID"];
    request.userInfo = [NSDictionary dictionaryWithObject:uintId forKey:@"UID"];
    request.tag = 4;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
    
}
-(void)GetSignInGroupByUnitID
{
    NSString *urlString = @"http://58.56.66.218:8084/InterAppMobileInterface/GetSignInGroupByUnitID";
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    NSString *uintId = [NSString stringWithFormat:@"%d",[dm getInstance].UID];
    [request addPostValue:uintId forKey:@"unitid"];
    request.userInfo = [NSDictionary dictionaryWithObject:uintId forKey:@"UID"];
    request.tag = 5;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
    
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
-(void)CreateSignIn:(NSDictionary*)SignInJsonData
{
    if ([NSJSONSerialization isValidJSONObject:SignInJsonData])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:SignInJsonData options:NSJSONWritingPrettyPrinted error: &error];
        
        NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        //NSLog(@"Register JSON:%@",[[NSString alloc] initWithData:tempJsonData encoding:NSUTF8StringEncoding]);
        
        NSURL *url = [NSURL URLWithString:@"http://58.56.66.218:8082/InterAppMobileInterface/MobileCreateSignIn"];
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
        [request addRequestHeader:@"Content-Type" value:@"text/xml"];
        [request addRequestHeader:@"charset" value:@"UTF8"];
        [request setRequestMethod:@"POST"];
        NSLog(@"jsonStr = %@",jsonStr);
        [request addPostValue:jsonStr forKey:@"SignInJsonData"];
        [request setDelegate:self];
        [request startAsynchronous];
        request.tag = 10;
        NSError *error1 = [request error];
        if (!error1) {
            NSString *response = [request responseString];
            
            NSLog(@"Test：%@",response);
        }

    }

    
}
-(void)GetSignInListForMobile:(NSString*)year Month:(NSString*)month
{
    NSString *urlString = @"http://58.56.66.218:8084/InterAppMobileInterface/GetSignInListForMobile";
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];

    NSString *userID = [dm getInstance].userInfo.UserID;
    
    
    [request addPostValue:userID forKey:@"UserID"];
    [request addPostValue:year forKey:@"Year"];
    [request addPostValue:month forKey:@"Month"];

    request.tag = 7;//设置请求tag
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
    if(_request.tag == 4)
    {
        NSData *responseData = [_request responseData];
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        NSString* dataString = [[NSString alloc] initWithData:responseData encoding:encoding];
        NSLog(@"dataString = %@",dataString);
        
        NSDictionary *dicList = [dataString objectFromJSONString];
        NSDictionary *dicData = [dicList  objectForKey:@"Data"];
        NSLog(@"dicData = %@",dicData);
        if(![dicData isEqual:[NSNull null]])
        {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"getSignInAddress" object:dicData];
        
    }
    }
    if(_request.tag == 5)
    {
        NSData *responseData = [_request responseData];
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        NSString* dataString = [[NSString alloc] initWithData:responseData encoding:encoding];
        NSLog(@"dataString = %@",dataString);
        
        NSDictionary *dicList = [dataString objectFromJSONString];
        NSDictionary *dicData = [dicList  objectForKey:@"Data"];
        NSLog(@"dicData = %@",dicData);
        if(![dicData isEqual:[NSNull null]])
        {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"GetSignInGroupByUnitID" object:dicData];
            
        }
        
    }
    if(_request.tag == 6)
    {
        NSData *responseData = [_request responseData];
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        NSString* dataString = [[NSString alloc] initWithData:responseData encoding:encoding];
        NSDictionary *dicList = [dataString objectFromJSONString];
        NSLog(@"dataString = %@",dataString);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GetTime" object:dicList];
        
    }
    if(_request.tag == 7)
    {
        NSData *responseData = [_request responseData];
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        NSString* dataString = [[NSString alloc] initWithData:responseData encoding:encoding];
        NSDictionary *dicList = [dataString objectFromJSONString];
        NSLog(@"dataString = %@",dataString);
        NSArray *arr = [dicList objectForKey:@"Data"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GetSignInList" object:arr];
        
    }
    if(_request.tag == 10)
    {
        NSData *responseData = [_request responseData];
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        NSString* dataString = [[NSString alloc] initWithData:responseData encoding:encoding];
        NSDictionary *dicList = [dataString objectFromJSONString];
        NSLog(@"dataString = %@",dataString);
        NSString *result = [dicList objectForKey:@"ResultDesc"];
        if([result isEqualToString:@"成功"])
        {
            [SVProgressHUD showSuccessWithStatus:@"签报成功"];

            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"签报失败"];
        }
        
//        NSArray *arr = [dicList objectForKey:@"Data"];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"GetSignInList" object:arr];
        
    }


    }





@end

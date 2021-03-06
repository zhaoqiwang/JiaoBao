//
//  SignInHttp.h
//  JiaoBao
//
//  Created by songyanming on 15/3/6.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dm.h"
#import "ASIFormDataRequest.h"
#import "RSATool.h"
#import "NSString+Base64.h"
#import "NSData+Base64.h"
#import "NSData+CommonCrypto.h"
#import "DESTool.h"
#import "JSONKit.h"
#import "define_constant.h"
#import "ParserJson_share.h"
#import "ArthDetailModel.h"
#import "LoginSendHttp.h"
#import "ShowHttp.h"
#import "ParserJson_theme.h"

@interface SignInHttp : NSObject<ASIHTTPRequestDelegate>
@property(nonatomic,strong)ASIFormDataRequest *ASIFormDataRequest;
+(SignInHttp *)getInstance;
-(void)getDelayedTime:(NSString *)UnitID;
-(void)uploadschedule:(NSDictionary*)dic;
-(void)querySchedule:(NSDictionary*)dic;
-(void)getUnitGroups:(NSUInteger)UID;
-(void)getSignInAddress;
-(void)GetSignInGroupByUnitID;
-(void)CreateSignIn:(NSDictionary*)SignInJsonData;
-(void)getTime;
-(void)GetSignInListForMobile:(NSString*)year Month:(NSString*)month;
-(void)WorkPlanSelectContentByMonth:(NSString*)UnitID UserID:(NSString*)UserID strSelectDate:(NSString*)strSelectDate;
//签到--2017-11-06
-(void)setSign:(NSString*)UnitID;
//查询我的签到记录
-(void)searchMySignInfoWithSDate:(NSString *)sDate eDate:(NSString *)eDate num:(int)num pageNum:(int)page rowCount:(NSString *)rowCount;


@end

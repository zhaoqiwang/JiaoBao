//
//  UnReadMsg_model.h
//  JiaoBao
//
//  Created by Zqw on 14-10-25.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnReadMsg_model : NSObject{
    NSString *TabIDStr;//当前行数据的ID
    NSString *UserName;//名称
    NSString *MsgContent;//内容
    NSString *RecDate;//时间
    NSString *JiaoBaoHao;//教宝号
    NSMutableArray *arrayAttList;
    NSMutableArray *arrayReaderList;
    NSMutableArray *arrayTrunToList;
    NSString *MsgTabIDStr;//点击回复我的信息时用
    NSString *FeeBackMsg;//回复我的
    NSString *UnitShortName;//单位名简称
}
@property (strong,nonatomic) NSString *TabIDStr;//当前行数据的ID
@property (strong,nonatomic) NSString *UserName;//名称
@property (strong,nonatomic) NSString *MsgContent;//内容
@property (strong,nonatomic) NSString *RecDate;//时间
@property (strong,nonatomic) NSString *JiaoBaoHao;//教宝号
@property (strong,nonatomic) NSMutableArray *arrayAttList;
@property (strong,nonatomic) NSMutableArray *arrayReaderList;
@property (strong,nonatomic) NSMutableArray *arrayTrunToList;
@property (strong,nonatomic) NSString *MsgTabIDStr;//点击回复我的信息时用
@property (strong,nonatomic) NSString *FeeBackMsg;//回复我的
@property (strong,nonatomic) NSString *UnitShortName;//单位名简称

@end
//{"TabIDStr":"Rjc4NEFFQ0YyQjZEMTQyOQ","TabID":1856060,"MsgSign":0,"UnitID":0,"UnitShortName":"金视野","UserID":0,"UserName":"梁绪伟","MsgContent":"转发马文彬：澄迈县教育局信息化平台应用及建设简介","RecDate":"2015-03-23T21:17:15","ClassID":0,"UserType":0,"JiaoBaoHao":5150025,"SMSFlag":0,"destID":null,"JiaobaoID":"5150028,5150699","ReaderList":"[{\"UserID\":67,\"UserIDType\":\"67_1\",\"JiaoBaoHao\":5150028,\"TrueName\":\"马文彬\",\"SrvState\":2,\"MCState\":0,\"SMSState\":2,\"PCState\":1,\"ClassID\":0,\"UnitID\":997},{\"UserID\":229,\"UserIDType\":\"229_1\",\"JiaoBaoHao\":5150699,\"TrueName\":\"何进耀\",\"SrvState\":2,\"MCState\":0,\"SMSState\":2,\"PCState\":1,\"ClassID\":0,\"UnitID\":1000}]","ReadFlagList":"1","TrunToList":"[]","State":1,"Checker":null,"CheckDate":null,"RecGUID":null,"AttList":"135554","IsAdmin":1,"CityCode":null,"FeebackList":"0","PointActionCode":0,"TrunToFlag":0,"GenReadCount":0,"GenSMSCount":0,"AppID":0,"MsgType":0}]
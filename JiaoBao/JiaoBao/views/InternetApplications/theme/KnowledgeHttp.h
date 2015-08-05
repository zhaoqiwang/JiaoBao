//
//  KnowledgeHttp.h
//  JiaoBao
//
//  Created by Zqw on 15/8/3.
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
#import "VlorNetWorkAPI.h"
#import "ParserJson_knowledge.h"


@interface KnowledgeHttp : NSObject<ASIHTTPRequestDelegate>{
    
}

//单
+(KnowledgeHttp *)getInstance;

//取系统中的省份信息
-(void)knowledgeHttpGetProvice;

//取指定省份的地市数据或取指定地市的区县数据
//cityCode,当level=1，这个参数是省份代码，level=2，这个参数是地市代码
//level,1取地市数据，2取区县数据
-(void)knowledgeHttpGetCity:(NSString *)cityCode level:(NSString *)level;

-(void)GetAccIdbyNickname:(NSArray*)nickNames;//通过昵称取用户教宝号

-(void)GetUserInfo;//取用户信息

//设置用户称号和姓名(暂不用)  参数描述：教宝号——称号——姓名
-(void)SetIdflagWithAccId:(NSString *)accId idFlag:(NSString*)idFlag userName:(NSString*)userName;

//取系统话题列表
-(void)GetCategoryWithParentId:(NSString*)parentId subject:(NSString*)subject;

//获取单一话题
-(void)GetCategoryById:(NSString*)uId;

//取所有话题
-(void)GetAllCategory;

//话题的问题列表 参数描述：（取回的记录数量）-（第几页）-(记录数量)-(回答标志)-(话题Id)
-(void)CategoryIndexQuestionWith:(NSString*)numPerPage pageNum:(NSString*)pageNum RowCount:(NSString*)RowCount flag:(NSString*)flag uid:(NSString*)uid;


@end

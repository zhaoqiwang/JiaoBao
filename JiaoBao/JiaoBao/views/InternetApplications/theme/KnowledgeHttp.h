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

//通过昵称取用户教宝号
-(void)GetAccIdbyNickname:(NSArray*)nickNames;

//取用户信息
-(void)GetUserInfo;

//设置用户称号和姓名(暂不用)  参数描述：教宝号——称号——姓名
-(void)SetIdflagWithAccId:(NSString *)accId idFlag:(NSString*)idFlag userName:(NSString*)userName;

//取系统话题列表
-(void)GetCategoryWithParentId:(NSString*)parentId subject:(NSString*)subject;

//获取单一话题
-(void)GetCategoryById:(NSString*)uId;

//取所有话题
-(void)GetAllCategory;

//发布问题 参数描述：所属话题Id-标题-问题内容-（关键字，多个以,隔开）-（QFlag）-(区域代码)-(atAccIds)
-(void)NewQuestionWithCategoryId:(NSString*)CategoryId Title:(NSString*)Title KnContent:(NSString*)KnContent TagsList:(NSString*)TagsList QFlag:(NSString*)QFlag AreaCode:(NSString*)AreaCode atAccIds:(NSString*)atAccIds;

//问题内容修改 参数描述：加密id - 问题内容 - （关键字，多个以,隔开）
//-(void)UpdateQuestionWithTabIDStr:(NSString*)TabIDStr KnContent:(NSString*)KnContent TagsList:(NSString*)TagsList;


//问题列表 参数描述：取回的记录数量 - （第几页，默认为1）- 话题Id
-(void)QuestionIndexWithNumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum CategoryId:(NSString*)CategoryId;

//问题明细 参数描述：问题ID
-(void)QuestionDetailWithQId:(NSString*)QId;

//回答问题 参数描述：问题id - 标题 - 回答的问题 - （用户昵称，若是匿名回答，为空字串符）
-(void)AddAnswerWithQId:(NSString*)QId Title:(NSString*)Title AContent:(NSString*)AContent UserName:(NSString*)UserName;

//修改答案 参数描述：答案id - 标题 - 回答的内容- （用户昵称，若是匿名回答，为空字串符）
-(void)UpdateAnswerWithTabID:(NSString*)TabID Title:(NSString*)Title AContent:(NSString*)AContent UserName:(NSString*)UserName;

//获取问题的答案列表 参数描述：（取回的记录数量，默认20）- （第几页，默认为1）- 问题Id - 回答标志
-(void)GetAnswerByIdWithNumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum QId:(NSString*)QId flag:(NSString*)flag;

//举报答案 参数描述:答案id
-(void)reportanswerWithAId:(NSString*)AId;

//评价答案 参数描述:答案id - (1=反对，0=支持)
-(void)SetYesNoWithAId:(NSString*)AId yesNoFlag:(NSString*)yesNoFlag;

//答案明细 参数描述:答案id
-(void)AnswerDetailWithAId:(NSString*)AId;

//添加评论 参数描述：答案Id - 评论内容 - 引用评论ID
-(void)AddCommentWithAId:(NSString*)AId comment:(NSString*)comment RefID:(NSString*)RefID;

//评论列表 参数描述：(取回的记录数量，默认20) - (第几页，默认为1) - 答案Id
-(void)CommentsListWithNumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum RowCount:(NSString*)RowCount AId:(NSString*)AId;

//首页问题列表 参数描述：（取回的记录数量）-（第几页）-(记录数量)-(回答标志)
-(void)UserIndexQuestionWithNumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum RowCount:(NSString*)RowCount flag:(NSString*)flag;

//话题的问题列表 参数描述：（取回的记录数量）-（第几页）-(记录数量)-(回答标志)-(话题Id)
-(void)CategoryIndexQuestionWithNumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum RowCount:(NSString*)RowCount flag:(NSString*)flag uid:(NSString*)uid;

//推荐列表 参数描述：（取回的记录数量）-（第几页）-(记录数量)
-(void)RecommentIndexWithNumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum RowCount:(NSString*)RowCount;

//单个推荐明细  参数描述：（推荐ID）
-(void)ShowRecommentWithTable:(NSString*)tabid;

//获取话题的置顶问题  参数描述：（话题Id）
-(void)GetCategoryTopQWithId:(NSString *)categoryid;

//获取一个精选内容集 参数描述：精选集ID,为0时取最新一期精选   标识区分，0主页，1单个精选
-(void)GetPickedByIdWithTabID:(NSString *)tabId flag:(NSString *)flag;

//获取一个精选内容明细 参数描述：精选内容ID
-(void)ShowPickedWithTabID:(NSString *)tabId;

//获取各期精选列表  参数描述：（取回的记录数量，默认20）- （第几页，默认为1）- (记录数量)
-(void)PickedIndexWithNumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum RowCount:(NSString*)RowCount;

//关注某一个问题 参数描述：问题ID
-(void)AddMyAttQWithqId:(NSString*)qId;

//取消关注问题 参数描述：问题ID
-(void)RemoveMyAttQWithqId:(NSString *)qId;

//邀请指定的用户回答问题 参数描述：被邀请的用户教宝号 - 问题ID
-(void)AtMeForAnswerWithAccId:(NSString*)accId qId:(NSString*)qId;

//获取我关注的问题列表 参数描述：（取回的记录数量）-（第几页）-(记录数量)
-(void)MyAttQIndexWithnumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum RowCount:(NSString*)RowCount;

//邀请我回答的问题 参数描述：（取回的记录数量）-（第几页）-(记录数量)
-(void)AtMeQIndexWithnumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum RowCount:(NSString*)RowCount;

//获取我提出的问题列表 参数描述：（取回的记录数量）-（第几页）-(记录数量)
-(void)MyQuestionIndexWithnumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum RowCount:(NSString*)RowCount;

//获取我参与回答的问题列表 参数描述：（取回的记录数量）-（第几页）-(记录数量)
-(void)MyAnswerIndexWithnumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum RowCount:(NSString*)RowCount;

//获取我关注的话题ID数组
-(void)GetMyattCate;

//更新我关注的话题
-(void)AddMyattCateWithuid:(NSString*)uid;

//邀请人回答时，获取回答该话题问题最多的用户列表（4个）参数描述：(用户账户) - （邀请人回答的问题的话题ID）
//-(void)GetAtMeUsersWithuid:(NSString*)uid catid:(NSString*)catid;
@end

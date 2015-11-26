//
//  ParserJson_knowledge.h
//  JiaoBao
//
//  Created by Zqw on 15/8/3.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "ProviceModel.h"
#import "UserInformationModel.h"
#import "CategoryModel.h"
#import "QuestionDetailModel.h"
#import "AnswerDetailModel.h"
#import "AllCommentListModel.h"
#import "RecommentAddAnswerModel.h"
#import "GetPickedByIdModel.h"
#import "PickContentModel.h"
#import "ShowPickedModel.h"
#import "PickedIndexModel.h"
#import "PointsModel.h"
#import "CommsModel.h"

@interface ParserJson_knowledge : NSObject

//取系统中的省份信息
+(NSMutableArray *)parserJsonGetProvice:(NSString *)json;

//通过昵称取用户教宝号
+(NSMutableArray *)parserJsonGetJiaoBaoHao:(NSString *)json;

//取用户信息
+(UserInformationModel*)parserJsonGetUserInfo:(NSString *)json;

//取系统话题列表
+(NSMutableArray*)parserJsonGetCategory:(NSString *)json;

//获取单一话题
+(CategoryModel*)parserJsonGetCategoryById:(NSString*)json;

//取所有话题
+(NSMutableArray*)parserJsonGetAllCategory:(NSString*)json;

//话题的问题列表
+(NSMutableArray*)parserJsonCategoryIndexQuestion:(NSString*)json;

//问题列表
+(NSMutableArray*)parserJsonQuestionIndex:(NSString*)json;

//问题明细
+(QuestionDetailModel*)parserJsonQuestionDetail:(NSString*)json;

//获取问题的答案列表
+(NSMutableArray*)parserJsonGetAnswerById:(NSString*)json;

//答案明细
+(AnswerDetailModel*)parserJsonAnswerDetail:(NSString*)json;

//评论列表
+(AllCommentListModel *)parserJsonCommentsList:(NSString*)json;

//推荐列表
+(NSMutableArray *)parserJsonRecommentIndex:(NSString *)json;

//推荐明细
+(RecommentAddAnswerModel *)parserJsonShowRecomment:(NSString *)json;

//获取一个精选内容集
+(GetPickedByIdModel *)parserJsonGetPickedById:(NSString *)json;

//获取一个精选内容明细
+(ShowPickedModel *)parserJsonShowPicked:(NSString *)json;

//获取各期精选列表
+(NSMutableArray *)parserJsonPickedIndex:(NSString *)json;
//邀请人回答时，获取回答该话题问题最多的用户列表（4个）
+(NSMutableArray*)parserJsonInvitationUserInfo:(NSString*)json;
//解析日积分或者月积分
+(PointsModel *)parserJsonGetMyPoints:(NSString *)json;
//解析我的评论列表
+(NSMutableArray*)parserJsonMyComms:(NSString*)json;


@end

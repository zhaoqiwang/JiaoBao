//
//  ParserJson_share.h
//  JiaoBao
//
//  Created by Zqw on 14-11-17.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "TopArthListModel.h"
#import "UnitSectionMessageModel.h"
#import "UserClassModel.h"
#import "UserSumClassModel.h"
#import "ArthDetailModel.h"
#import "UnitInfoModel.h"
#import "UploadImgModel.h"
#import "UnitNoticeModel.h"
#import "NoticeInfoModel.h"
#import "FriendSpaceModel.h"
#import "CommentsListObjModel.h"
#import "GetArthInfoModel.h"

@interface ParserJson_share : NSObject

//解析最新更新、推荐
+(NSMutableArray *)parserJsonTopArthListWith:(NSString *)json;

//解析获取到得单位，本级和上级，new
+(NSMutableArray *)parserJsonSectionMessage:(NSString *)json;

//解析关联班级信息
+(NSMutableArray *)parserJsonUnitClassWith:(NSString *)json;

//解析所有班级信息
+(NSMutableArray *)parserJsonSumClassWith:(NSString *)json;

//解析文章详情
+(ArthDetailModel *)parserJsonArthDetailWith:(NSString *)json;

//解析所有下级单位基础信息
+(NSMutableArray *)parserJsonMySubUnitInfoWith:(NSString *)json;

//解析上传图片成功后的数据
+(UploadImgModel *)parserJsonUploadImgWith:(NSString *)json;

//解析内务通知列表
+(UnitNoticeModel *)parserJsonUnitNoticesWith:(NSString *)json;

//解析通知详情
+(NoticeInfoModel *)parserJsonNoticeDetailWith:(NSString *)json;

//解析该用户的所有好友
+(NSMutableArray *)parserJsonMyFriendsWith:(NSString *)json;

//解析文章的评论
+(CommentsListObjModel *)parserJsonCommentsListWith:(NSString *)json;

//解析文件附加信息
+(GetArthInfoModel *)parserJsonGetArthInfo:(NSString *)json;

@end

//
//  ShareHttp.h
//  JiaoBao
//
//  Created by Zqw on 14-11-15.
//  Copyright (c) 2014年 JSY. All rights reserved.
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
#import "GetArthInfoModel.h"

@interface ShareHttp : NSObject<ASIHTTPRequestDelegate>{
    
}

//单
+(ShareHttp *)getInstance;

//获取最新和推荐文章                             1共享2展示                  1最新2推荐              第几页
-(void)shareHttpGetTopArthListIndexWith:(NSString *)sectionFlag TopFlag:(NSString *)topFlag Page:(NSString *)page;

//获取本单位栏目文章                               1共享2展示99个人空间                单位ID                第几页
-(void)shareHttpGetUnitArthLIstIndexWith:(NSString *)sectionFlag UnitID:(NSString *)unitID Page:(NSString *)page;

//获取我所在的单位                                      1共享2展示          账户ID
-(void)shareHttpGetUnitSectionMessagesWith:(NSString *)sectionID AcdID:(NSString *)accID;

//获取关联的班级                       用户账号                用户单位ID              1共享2展示
-(void)shareHttpGetMyUserClassWith:(NSString *)accID UID:(NSString *)UID Section:(NSString *)flag;

//获取所有班级                        用户单位ID          1共享2展示
-(void)shareHttpGetUnitClassWith:(NSString *)UID Section:(NSString *)flag;

//显示文章详细内容
-(void)shareHttpGetShowArthDetailWith:(NSString *)tableID SectionID:(NSString *)sid;

//获取本单位的所有下级单位基础信息
-(void)shareHttpGetMySubUnitInfoWith:(NSString *)UID;

//上传图片
-(void)shareHttpUploadSectionImgWith:(NSString *)imgPath Name:(NSString *)name;

//发表文章                                  标题                      内容                  单位类型                单位ID                    来自分享1、展示2
-(void)shareHttpSavePublishArticleWith:(NSString *)title Content:(NSString *)content uType:(NSString *)utype UnitID:(NSString *)unitID SectionFlag:(NSString *)flag;

//获取栏目最新和推荐文章的未读数量             _1展示_2共享           1最新2推荐                      账户ID
-(void)shareHttpGetSectionMessageWith:(NSString *)sectionID TopFlags:(NSString *)topFlag AccID:(NSString *)accid;

//获得单位通知，内务                     1教育局2学校3班级          单位ID                    第几页
-(void)NoticeHttpGetUnitNoticesWith:(NSString *)uType UnitID:(NSString *)unitID pageNum:(NSString *)pageNum;

//获取通知详细内容
-(void)NoticeHttpGetShowNoticeDetailWith:(NSString *)talbeID;

//获取头像                                  1普通2内务通知
-(void)getFaceImg:(NSMutableArray *)array flag:(int)flag;

//文章点赞                      文章加密id
-(void)shareHttpAirthLikeIt:(NSString *)aid Flag:(NSString *)flag;

//获取文章评论列表              文章加密id                                                      来自哪个页面的请求
-(void)shareHttpAirthCommentsList:(NSString *)aid Page:(NSString *)page Num:(NSString *)num Flag:(NSString *)flag;

//发表评论                  文章加密id                                              加密的引用评语ID
-(void)shareHttpAirthAddComment:(NSString *)aid content:(NSString *)comment refid:(NSString *)refid;

//评论顶和踩                     加密评论ID             顶=1，踩=0
-(void)shareHttpAirthAddScore:(NSString *)uid tp:(NSString *)tp;

//取文章附加信息                   文章加密id          文章栏目id             0列表界面，1详情界面
-(void)shareHttpAirthGetArthInfo:(NSString *)aid sid:(NSString *)sid from:(NSString *)view;


@end

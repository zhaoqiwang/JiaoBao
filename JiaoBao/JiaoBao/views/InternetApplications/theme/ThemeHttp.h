//
//  ThemeHttp.h
//  JiaoBao
//
//  Created by Zqw on 14-12-16.
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
#import "ParserJson_theme.h"

@interface ThemeHttp : NSObject<ASIHTTPRequestDelegate>{
    
}

//单
+(ThemeHttp *)getInstance;

//取最新更新的主题                              1最新2推荐
-(void)themeHttpUpdatedInterestList:(NSString *)topFlag Page:(NSString *)pageNum;

//取我关注的和我所参与的主题
-(void)themeHttpEnjoyInterestList:(NSString *)accid;

//获取单位相册,功能：获取某单位中的相册
-(void)themeHttpGetUnitPGroup:(NSString *)unitID;

//获取在单位中我创建的相册
-(void)themeHttpGetUnitMyGroup:(NSString *)unitID AccID:(NSString *)accid;

//获取单位相册的照片
-(void)themeHttpGetUnitPhotoByGroupIDs:(NSString *)unitID GroupID:(NSString *)groupID;

//创建单位相册                                             相册名称                    相册创建人：jiaobaohao    相册描述，目前没有用描述,这里写“来自手机”  0无限制，1单位内可见
-(void)themeHttpCreateUnitPhotoGroup:(NSString *)unitID PhotoName:(NSString *)name CreatBy:(NSString *)creatID DesInfo:(NSString *)desInfo ViewType:(NSString *)viewType;

//单位相册上传照片
-(void)themeHttpUpLoadPhotoUnit:(NSString *)unitID GroupID:(NSString *)groupID Creatby:(NSString *)creatID Fiel:(NSString *)file;

//获取单位相册的第一张照片
-(void)themeHttpGetUnitFristPhotoByGroup:(NSString *)unitID GroupID:(NSString *)groupID;

//个人空间相册上传照片                上传 人jiaobaohao      文件名称 带后缀                        照片描述                    相册ID ，加密后的ID
-(void)themeHttpUpLoadPhotoFromAPP:(NSString *)accid FileName:(NSString *)fileName Describe:(NSString *)describe GroupID:(NSString *)group FIle:(NSString *)file;

//获取单位中最新的N张照片
-(void)themeHttpGetUnitNewPhoto:(NSString *)unitID count:(NSString *)count;

//个人空间添加相册                                          type:相册访问权限:0:私有；1：好友可访问；2：关注可访问；3：游客可访问
-(void)themeHttpAddPhotoGroup:(NSString *)accid PhotoName:(NSString *)name viewType:(NSString *)type;

//要获取属于jiaobaohao下的相册
-(void)themeHttpGetPhotoList:(NSString *)accid;

//个人某个相册中的照片
-(void)themeHttpGetPhotoByGroup:(NSString *)accid GroupInfo:(NSString *)groupID;

//个人最新前N张照片
-(void)themeHttpGetNewPhoto:(NSString *)accid Count:(NSString *)count;

//相册中第一张照片
-(void)themeHttpGetFristPhotoByGroup:(NSString *)accid GroupInfo:(NSString *)groupID;

//所有照片
-(void)themeHttpGetPhotoAll:(NSString *)accid;

//是否关注主题                主题加密id
-(void)themeHttpExistAtt:(NSString *)uid;

//加主题关注
-(void)themeHttpAddAtt:(NSString *)uid;

//取消主题关注
-(void)themeHttpRemoveAtt:(NSString *)uid;


@end

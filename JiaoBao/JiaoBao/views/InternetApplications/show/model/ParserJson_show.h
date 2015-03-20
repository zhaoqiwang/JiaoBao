//
//  ParserJson_show.h
//  JiaoBao
//
//  Created by Zqw on 14-12-13.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "UnitAlbumsModel.h"
#import "UnitAlbumsListModel.h"
#import "PersonPhotoModel.h"
#import "MyAttUnitModel.h"
#import "utils.h"

@interface ParserJson_show : NSObject

//取最新更新文章单位信息
+(NSMutableArray *)parserJsonUpdateUnitList:(NSString *)json;

//获取单位相册
+(NSMutableArray *)parserJsonGetUnitPGroup:(NSString *)json;

//获取单位相册的照片，
+(NSMutableArray *)parserJsonGetUnitPhotoByGroupID:(NSString *)json;

//获取个人相册
+(NSMutableArray *)parserJsonGetPhotoList:(NSString *)json;

//解析我关注的单位
+(NSMutableArray *)parserJsonGetMyAttUnit:(NSString *)json;

@end

//
//  groupselit_selitModel.h
//  JiaoBao
//
//  Created by Zqw on 14-11-4.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface groupselit_selitModel : NSObject{
    NSString *selit;//接收对象json串已加密，需要把这个做为参数提交给发表交流信息api。
    NSString *AccID;//>0有教宝号，=0没有教宝号，有无AcccID需要特殊显示
    NSString *isAdmin;//1管理员0不是管理员，管理员特殊显示，
    NSString *Name;//显示值
    NSString *SendFlag;//=0表示不收短信，只在电脑或手机上查看该消息
    int mInt_select;//是否被选中，默认0，选中为1
    NSString *flag;//判断当前身份，老师--selit ，家长--genselit，学生--stuselit
}

@property (nonatomic,strong) NSString *selit;
@property (nonatomic,strong) NSString *AccID;
@property (nonatomic,strong) NSString *isAdmin;
@property (nonatomic,strong) NSString *Name;
@property (nonatomic,strong) NSString *SendFlag;
@property (nonatomic,assign) int mInt_select;//是否被选中，默认0，选中为1
@property (nonatomic,strong) NSString *flag;//判断当前身份，老师--selit ，家长--genselit，学生--stuselit

@end
//"groupselit_selit":[{"selit":"OUU2NDUwMkY5MTY4QzhFN0JCQTU5QTdBQzcwRTFGRUI0N0RFRDhDQzg4MjJCQ0MxOTBCMjYzMjJBRTkzMjE5RkQ1OUQ3OTM5RTExMkE4MjlGMzQ2REU4RUNCNjI3NUNBQzJFMUU5RDgzQUFBNDdBMTUwMDAzMzAwOENDRjREMDRDQjUxNzVENUFDODY1NDhGQkJGMTI3MjU2QzM2Qjk4MjNDMUE2NkFCODBERTM4NjY1RkFGNjM0QTE3QUY5ODU5OEU2OTc2RTkzMTIwQkMwNQ","AccID":"5150001","isAdmin":0,"Name":"LM(123*,有)","SendFlag":1
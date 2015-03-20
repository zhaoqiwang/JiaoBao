//
//  MyAttUnitModel.h
//  JiaoBao
//
//  Created by Zqw on 14-12-31.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAttUnitModel : NSObject{
    NSString *TabID;
    NSString *CreateByjiaobaohao;
    NSString *InterestUnitID;
    NSString *CreateDatetime;
    NSString *GroupID;
    NSString *TypeInfo;
    NSString *unitName;
    NSString *unitType;
    NSString *isInUnit;
    NSString *isAdmin;
}

@property (nonatomic,strong) NSString *TabID;
@property (nonatomic,strong) NSString *CreateByjiaobaohao;
@property (nonatomic,strong) NSString *InterestUnitID;
@property (nonatomic,strong) NSString *CreateDatetime;
@property (nonatomic,strong) NSString *GroupID;
@property (nonatomic,strong) NSString *TypeInfo;
@property (nonatomic,strong) NSString *unitName;
@property (nonatomic,strong) NSString *unitType;
@property (nonatomic,strong) NSString *isInUnit;
@property (nonatomic,strong) NSString *isAdmin;

@end
//[{"CreateByjiaobaohao":"5182507","InterestUnitID":"3277","CreateDatetime":"2014/12/18 11:57:10","GroupID":"0","unitName":"海口市琼山第五小学","unitType":"2","isInUnit":"False","isAdmin":"False"},
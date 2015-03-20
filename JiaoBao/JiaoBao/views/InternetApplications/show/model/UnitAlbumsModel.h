//
//  UnitAlbumsModel.h
//  JiaoBao
//
//  Created by Zqw on 14-12-19.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitAlbumsModel : NSObject{
    NSString *TabID;//单位相册对应的ID
    NSString *CreateByjiaobaohao;//单位相册创建人jiaobaohao ；谁创建谁维护
    NSString *nameStr;//相册名称
    NSString *DesInfo;//相册描述,目前没有内容
    NSString *ViewType;//相册显示类型：0为无限制，1为单位内成员可见，3为相册删除状态，暂时3状态没有用到
    NSString *UnitID;//单位ID
    NSString *fristPhoto;//相册中第一张照片的url
}

@property (nonatomic,strong) NSString *TabID;
@property (nonatomic,strong) NSString *CreateByjiaobaohao;
@property (nonatomic,strong) NSString *nameStr;
@property (nonatomic,strong) NSString *DesInfo;
@property (nonatomic,strong) NSString *ViewType;
@property (nonatomic,strong) NSString *UnitID;
@property (nonatomic,strong) NSString *fristPhoto;//相册中第一张照片的url

@end
//[{"TabID":87,"CreateByjiaobaohao":5150001,"nameStr":"单位相册","DesInfo":null,"ViewType":0,"UnitID":1070}]
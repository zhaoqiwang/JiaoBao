//
//  UserListModel.h
//  JiaoBao
//
//  Created by Zqw on 14-11-4.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserListModel : NSObject{
    NSString *GroupName;//分组名称
    NSString *MCount;//本组人数
    NSMutableArray *groupselit_selit; //需要把GroupSelit[]中的selit以seleit为name提交给api
}
@property (nonatomic,strong) NSString *GroupName;//分组名称
@property (nonatomic,strong) NSString *MCount;//本组人数
@property (nonatomic,strong) NSMutableArray *groupselit_selit;
@property(nonatomic,assign)int sectionSelSymbol;//0为全空；1为全选；2为非全选；
//需要把GroupSelit[]中的selit以seleit为name提交给api

@end
//"UserList":[{"GroupName":"基本人员",
    //            "MCount":1,
    //            "groupselit_selit":[{"selit":"OUU2NDUwMkY5MTY4QzhFN0JCQTU5QTdBQzcwRTFGRUI0N0RFRDhDQzg4MjJCQ0MxOTBCMjYzMjJBRTkzMjE5RkQ1OUQ3OTM5RTExMkE4MjlGMzQ2REU4RUNCNjI3NUNBQzJFMUU5RDgzQUFBNDdBMTUwMDAzMzAwOENDRjREMDRDQjUxNzVENUFDODY1NDhGQkJGMTI3MjU2QzM2Qjk4MjNDMUE2NkFCODBERTM4NjY1RkFGNjM0QTE3QUY5ODU5OEU2OTc2RTkzMTIwQkMwNQ","AccID":"5150001","isAdmin":0,"Name":"LM(123*,有)","SendFlag":1
    //            }]
    //        }]
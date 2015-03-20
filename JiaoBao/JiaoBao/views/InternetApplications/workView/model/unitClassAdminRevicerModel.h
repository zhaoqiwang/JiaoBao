//
//  unitClassAdminRevicerModel.h
//  JiaoBao
//
//  Created by Zqw on 14-11-4.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface unitClassAdminRevicerModel : NSObject{
    NSMutableArray *selitunitclassidtogen;
    NSMutableArray *selitunitclassidtostu;
    NSMutableArray *selitunitclassadmintogen;
    NSMutableArray *selitunitclassadmintostu;
}

@property (nonatomic,strong) NSMutableArray *selitunitclassidtogen;
@property (nonatomic,strong) NSMutableArray *selitunitclassidtostu;
@property (nonatomic,strong) NSMutableArray *selitunitclassadmintogen;
@property (nonatomic,strong) NSMutableArray *selitunitclassadmintostu;

@end
//public GroupSelit[] selitunitclassidtogen { set; get; } //本班家长，表示学校老师直接发给家长，不需要转发。需要把GroupSelit[]中的selit以selitadmintomem为name提交给api
//public GroupSelit[] selitunitclassidtostu { set; get; }//本班学生，表示学校老师直接发给学生,不需要转发。需要把GroupSelit[]中的selit以selitadmintogen为name提交给api
//public GroupSelit[] selitunitclassadmintogen { set; get; } //发给班主任，表示该信息需要由班主任转给家长。需要把GroupSelit[]中的selit以selitunitclassadmintogen为name提交给api
//public GroupSelit[] selitunitclassadmintostu { set; get; }//发给班主任，表示该信息需要由班主任转给学生。需要把GroupSelit[]中的selit以selitunitclassadmintostu为name提交给api

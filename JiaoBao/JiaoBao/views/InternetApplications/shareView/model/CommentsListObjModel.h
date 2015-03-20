//
//  CommentsListObjModel.h
//  JiaoBao
//
//  Created by Zqw on 15-1-16.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentsListObjModel : NSObject

@property (nonatomic,strong) NSMutableArray *commentsList;
@property (nonatomic,strong) NSMutableArray *refcomments;

@end

@interface commentsListModel : NSObject

@property (nonatomic,strong) NSString *TabIDStr;//加密ID
@property (nonatomic,strong) NSString *TabID;//不加密的ID
@property (nonatomic,strong) NSString *Number;//第几楼
@property (nonatomic,strong) NSString *JiaoBaoHao;//教宝号
@property (nonatomic,strong) NSString *CaiCount;//踩的数量
@property (nonatomic,strong) NSString *LikeCount;//赞的数量
@property (nonatomic,strong) NSString *Commnets;//内容
@property (nonatomic,strong) NSString *UnitShortname;//评论者单位名称
@property (nonatomic,strong) NSString *RecDate;//日期
//@property (nonatomic,strong) NSString *RefID;//引用的评论
@property (nonatomic,strong) NSMutableArray *RefID;//引用的评论
@property (nonatomic,strong) NSString *UserName;//姓名


//"TabIDStr": "MzFBRkIzNjI3QURDRjE1RQ",
//"TabID": 1454640,
//"Number": "8楼",
//"JiaoBaoHao": 5150001,
//"CaiCount": 0,
//"LikeCount": 0,
//"Commnets": "444",
//"UnitShortname": "支撑学校",
//"RecDate": "2015-01-16T14:53:00",
//"RefID": "1434519,1454460,",
//"UserName": "测试5150001"

@end

@interface refcommentsModel : NSObject

@property (nonatomic,strong) NSString *TabIDStr;
@property (nonatomic,strong) NSString *TabID;
@property (nonatomic,strong) NSString *JiaoBaoHao;
@property (nonatomic,strong) NSString *CaiCount;
@property (nonatomic,strong) NSString *LikeCount;
@property (nonatomic,strong) NSString *Commnets;
@property (nonatomic,strong) NSString *UnitShortname;
@property (nonatomic,strong) NSString *RecDate;
@property (nonatomic,strong) NSString *UserName;


//"TabIDStr": "Q0IxMzA0RjZGODRDODBCNw",
//"TabID": 1454515,
//"JiaoBaoHao": 5150001,
//"CaiCount": 0,
//"LikeCount": 0,
//"Commnets": "222",
//"UnitShortname": "支撑学校",
//"RecDate": "2015-01-16T14:52:00",
//"UserName": "测试5150001"

@end
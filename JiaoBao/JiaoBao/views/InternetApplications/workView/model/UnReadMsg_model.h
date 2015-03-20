//
//  UnReadMsg_model.h
//  JiaoBao
//
//  Created by Zqw on 14-10-25.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnReadMsg_model : NSObject{
    NSString *TabIDStr;//当前行数据的ID
    NSString *UserName;//名称
    NSString *MsgContent;//内容
    NSString *RecDate;//时间
    NSString *JiaoBaoHao;//教宝号
    NSMutableArray *arrayAttList;
    NSMutableArray *arrayReaderList;
    NSMutableArray *arrayTrunToList;
    NSString *MsgTabIDStr;//点击回复我的信息时用
    NSString *FeeBackMsg;//回复我的
}
@property (strong,nonatomic) NSString *TabIDStr;//当前行数据的ID
@property (strong,nonatomic) NSString *UserName;//名称
@property (strong,nonatomic) NSString *MsgContent;//内容
@property (strong,nonatomic) NSString *RecDate;//时间
@property (strong,nonatomic) NSString *JiaoBaoHao;//教宝号
@property (strong,nonatomic) NSMutableArray *arrayAttList;
@property (strong,nonatomic) NSMutableArray *arrayReaderList;
@property (strong,nonatomic) NSMutableArray *arrayTrunToList;
@property (strong,nonatomic) NSString *MsgTabIDStr;//点击回复我的信息时用
@property (strong,nonatomic) NSString *FeeBackMsg;//回复我的

@end

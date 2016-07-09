//
//  ChapterModel.h
//  JiaoBao
//
//  Created by songyanming on 15/10/16.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChapterModel : NSObject
@property(nonatomic,strong)NSString *TabIDStr;//
@property(nonatomic,strong)NSString *TabID;//
@property(nonatomic,strong)NSString *subjectID;//
@property(nonatomic,strong)NSString *TVersionID;//
@property(nonatomic,strong)NSString *Unid;//
@property(nonatomic,strong)NSString *Pid;//父级id
@property(nonatomic,strong)NSString *chapterCode;//章节代码
@property(nonatomic,strong)NSString *chapterName;//章节名称
@property(nonatomic,strong)NSString *Remark;//
@property(nonatomic,strong)NSString *isEnable;//
@property(nonatomic,strong)NSString *orderby;//
@property(nonatomic,strong)NSString *chapterCodePid;//
@property (nonatomic,assign) int mInt_select;//是否选择1，否0
@property (nonatomic,assign) int mInt_flag;//区分是第几级列表
@property(nonatomic,strong) NSMutableArray *array;//章节里面的父子级关系
@property (nonatomic) BOOL isExpanded;//节点是否展开

@end

// "args3": "[{\"TabIDStr\":\"\",\"TabID\":1,\"subjectID\":1,\"TVersionID\":3,\"GradeID\":1,\"Unid\":418,\"Pid\":0,\"chapterCode\":1,\"chapterName\":\"英语第一节（测试）\",\"Remark\":null,\"isEnable\":1,\"orderby\":1,\"chapterCodePid\":0},{\"TabIDStr\":\"\",\"TabID\":2261,\"subjectID\":0,\"TVersionID\":0,\"GradeID\":0,\"Unid\":418,\"Pid\":0,\"chapterCode\":0,\"chapterName\":\"第一章  测试xxxx\",\"Remark\":\"\",\"isEnable\":1,\"orderby\":0,\"chapterCodePid\":0},{\"TabIDStr\":\"\",\"TabID\":2262,\"subjectID\":0,\"TVersionID\":0,\"GradeID\":0,\"Unid\":418,\"Pid\":2261,\"chapterCode\":0,\"chapterName\":\"第一单元 测试XXX\",\"Remark\":\"\",\"isEnable\":1,\"orderby\":2261,\"chapterCodePid\":0},{\"TabIDStr\":\"\",\"TabID\":2263,\"subjectID\":0,\"TVersionID\":0,\"GradeID\":0,\"Unid\":418,\"Pid\":2262,\"chapterCode\":0,\"chapterName\":\"第一单元 第一节测试xxx\",\"Remark\":\"\",\"isEnable\":1,\"orderby\":2262,\"chapterCodePid\":0}]",
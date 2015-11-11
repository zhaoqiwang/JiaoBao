//
//  PublishJobModel.h
//  JiaoBao
//
//  Created by songyanming on 15/10/19.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublishJobModel : NSObject
@property(nonatomic,strong)NSString *GradeName;//年级名称
@property(nonatomic,strong)NSString *GradeCode;//年级代码
@property(nonatomic,strong)NSString *subjectName;//科目名称
@property(nonatomic,strong)NSString *subjectCode;//科目代码
@property(nonatomic,strong)NSString *VersionName;//教版名称
@property(nonatomic,strong)NSString *VersionCode;//教版代码
@property(nonatomic,strong)NSString *chapterName;//章节名称

@property(nonatomic,strong)NSString *teacherJiaobaohao;// 老师教宝号
@property(nonatomic,strong)NSString *classID;// 班级ID
@property(nonatomic,strong)NSString *className;//班级名称
@property(nonatomic,strong)NSString *classSel;
@property(nonatomic,strong)NSMutableArray *classIDArr;// 班级ID数组
@property(nonatomic,strong)NSString *chapterID;//章节ID
@property(nonatomic,strong)NSString *DoLv;//难度等级

@property(nonatomic,strong)NSString *AllNum;//总题量
@property(nonatomic,strong)NSString *SelNum;//选择题量
@property(nonatomic,strong)NSString *InpNum;//填空题
@property(nonatomic,strong)NSString *Distribution;//1:10,2:20 试题分布
@property(nonatomic,strong)NSString *LongTime;//作业时长
@property(nonatomic,strong)NSString *ExpTime;//过期时间
@property(nonatomic,strong)NSString *homeworkName;//作业名称---  日期+科目+单元名称
@property(nonatomic,strong)NSString *Additional;//“”
@property(nonatomic,strong)NSString *AdditionalDes;//“”
@property(nonatomic,strong)NSString *schoolName;//学校名称
@property(nonatomic,strong)NSString *HwType;//作业类型  1为个性作业，2为AB卷，3为自定义作业，4统一作业（所有班级统一）
@property(nonatomic,assign)BOOL IsAnSms;//是否发送 答案 短信// T F
@property(nonatomic,assign)BOOL IsQsSms;// 是否发送 试题 通知//
@property(nonatomic,assign)BOOL IsRep;//是否发送 老师反馈 短信
@property(nonatomic,strong)NSString *TecName;//老师的名称
@property(nonatomic,strong)NSString *DesId;//自定义作业ID，如果是自定义作业则加上自定义的ID
- (NSMutableDictionary *)propertiesDic;
@end

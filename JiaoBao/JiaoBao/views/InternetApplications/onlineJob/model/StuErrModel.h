//
//  StuErrModel.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/17.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StuErrModel : NSObject
//http请求model
@property (nonatomic,strong) NSString *StuId;//学生ID
@property (nonatomic,strong) NSString *IsSelf;//0作业,1练习
@property (nonatomic,strong) NSString *PageIndex;//页码
@property (nonatomic,strong) NSString *PageSize;//页记录数
@property (nonatomic,strong) NSString *chapterid;//章节ID
@property (nonatomic,strong) NSString *CreateDate_Min;//开始时间
@property (nonatomic,strong) NSString *CreateDate_Max;//结束时间
@property (nonatomic,strong) NSString *QsLv;//
@property (nonatomic,strong) NSString *gradeCode;//年级
@property (nonatomic,strong) NSString *subjectCode;//科目
@property (nonatomic,strong) NSString *unid;//教版
//json数据解析model
@property (nonatomic,strong) NSString *Tabid;//
@property (nonatomic,strong) NSString *StuID;//学生ID
@property (nonatomic,strong) NSString *HwID;//作业ID
@property (nonatomic,strong) NSString *chapterID;//
@property (nonatomic,strong) NSString *QsID;//题库试题ID
@property (nonatomic,strong) NSString *QsType;//题型
//@property (nonatomic,strong) NSString *QsLv;//
@property (nonatomic,strong) NSString *Answer;//作答
@property (nonatomic,strong) NSString *DoDate;//作答时间
@property (nonatomic,strong) NSString *DoC;//是否重复错

- (NSMutableDictionary *)propertiesDic;
@end
//    self.errModel.StuId = self.mModel_stuInf.StudentID;
//self.errModel.IsSelf = @"0";
//self.errModel.PageIndex = @"1";
//self.errModel.PageSize = @"10";
//self.errModel.chapterID = model.chapterID;
//self.errModel.gradeCode = @"-1";
//self.errModel.subjectCode = model.subjectCode;
//self.errModel.unid = model.VersionCode;
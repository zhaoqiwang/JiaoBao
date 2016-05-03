//
//  StuHWModel.h
//  JiaoBao
//
//  Created by songyanming on 15/10/23.
//  Copyright © 2015年 JSY. All rights reserved.
//学生当前作业列表model

#import <Foundation/Foundation.h>

@interface StuHWModel : NSObject
@property(nonatomic,strong)NSString *TabID;//分表ID
@property(nonatomic,strong)NSString *homeworkName;//作业名称
@property(nonatomic,strong)NSString *distribution;//作业分布情况，"distribution":"1:10,2:10",1选2填
@property(nonatomic,strong)NSString *itemNumber;//试题数量

@property(nonatomic,strong)NSString *TabIDStr;//页数
@property(nonatomic,strong)NSString *HWStartTime;//判断是否开始作业"HWStartTime":"1970-01-01T00:00:00"，等于此值，就是没开始做题
@property(nonatomic,strong)NSString *HWID;//主表ID
@property(nonatomic,strong)NSString *studentLevel;
@property(nonatomic,strong)NSString *jiaobaohao;
@property(nonatomic,strong)NSString *AccountID;//学生ID
@property(nonatomic,strong)NSString *isHWFinish;//作业是否完成
@property(nonatomic,strong)NSString *isAdFinish;//主观题是否完成
@property(nonatomic,strong)NSString *HWEndTime;//作业完成时间
@property(nonatomic,strong)NSString *useLongtime;
@property(nonatomic,strong)NSString *HWScore;//作业得分
@property(nonatomic,strong)NSString *EduLevel;//学力
@property(nonatomic,strong)NSString *AddStartTime;
@property(nonatomic,strong)NSString *AddEndTime;
@property(nonatomic,strong)NSString *CheckNum;
@property(nonatomic,strong)NSString *CheckTeacher;
@property(nonatomic,strong)NSString *CheckResultJBH;
@property(nonatomic,strong)NSString *SubjectID;
@property(nonatomic,strong)NSString *GradeID;
@property(nonatomic,strong)NSString *classID;

@property(nonatomic,strong)NSString *className;
@property(nonatomic,strong)NSString *chapterID;
@property(nonatomic,strong)NSString *VersionID;
@property(nonatomic,strong)NSString *modulusGrade;
@property(nonatomic,strong)NSString *CreateDate;
@property(nonatomic,strong)NSString *LongTime;
@property(nonatomic,strong)NSString *EXPIRYDATE;//过期时间
@property(nonatomic,strong)NSString *EXPIRYINT;
@property(nonatomic,strong)NSString *jiaobaohao1;
@property(nonatomic,strong)NSString *AccountID1;
@property(nonatomic,strong)NSString *isEnable;
@property(nonatomic,strong)NSString *schoolName;
@property(nonatomic,strong)NSString *isSelf;
@property(nonatomic,strong)NSString *isHaveAdd;//是否主观题
@property(nonatomic,strong)NSString *subjectName;
@property(nonatomic,strong)NSString *questionList;
@property(nonatomic,strong)NSString *chapterName;
@property(nonatomic,strong)NSString *Additional;
@property(nonatomic,strong)NSString *AdditionalDes;

@property(nonatomic,strong)NSString *AdditionalAnswer;
@property(nonatomic,strong)NSString *CheckResult;
@property(nonatomic,strong)NSString *isType;
@property(nonatomic,strong)NSString *chapterIDEncrypt;
@property(nonatomic,strong)NSString *SubjectIDEncrypt;
@property(nonatomic,strong)NSString *VersionIDEncrypt;
@property(nonatomic,strong)NSString *GradeIDEncrypt;
@property(nonatomic,strong)NSString *classIDEncrypt;




//[{"TabIDStr":null,"TabID":344910,"HWID":0,"studentLevel":0,"jiaobaohao":0,"AccountID":0,"isHWFinish":0,"isAdFinish":0,"HWStartTime":null,"HWEndTime":null,"useLongtime":0,"HWScore":0,"EduLevel":-1,"AddStartTime":null,"AddEndTime":null,"CheckNum":0,"CheckTeacher":null,"AddScore":0,"CheckResultJBH":null,"SubjectID":-1,"GradeID":-1,"classID":-1,"className":null,"chapterID":-1,"VersionID":0,"modulusGrade":0,"itemNumber":20,"distribution":"1:10,2:10","LongTime":0,"EXPIRYDATE":null,"EXPIRYINT":0,"CreateDate":null,"homeworkName":"2015-10-23英语英语第一节（测试）作业","jiaobaohao1":0,"AccountID1":0,"isEnable":0,"schoolName":null,"isHaveAdd":-1,"isSelf":-1,"subjectName":null,"questionList":null,"chapterName":null,"Additional":null,"AdditionalDes":null,"AdditionalAnswer":null,"CheckResult":null,"isType":0,"chapterIDEncrypt":null,"SubjectIDEncrypt":null,"VersionIDEncrypt":null,"GradeIDEncrypt":null,"classIDEncrypt":null},



//{"TabIDStr":null,"TabID":344988,"HWID":0,"studentLevel":0,"jiaobaohao":0,"AccountID":0,"isHWFinish":0,"isAdFinish":0,"HWStartTime":null,"HWEndTime":null,"useLongtime":0,"HWScore":0,"EduLevel":-1,"AddStartTime":null,"AddEndTime":null,"CheckNum":0,"CheckTeacher":null,"AddScore":0,"CheckResultJBH":null,"SubjectID":-1,"GradeID":-1,"classID":-1,"className":null,"chapterID":-1,"VersionID":0,"modulusGrade":0,"itemNumber":10,"distribution":"1:5,2:5","LongTime":0,"EXPIRYDATE":null,"EXPIRYINT":0,"CreateDate":null,"homeworkName":"2015-10-23语文第一单元作业","jiaobaohao1":0,"AccountID1":0,"isEnable":0,"schoolName":null,"isHaveAdd":-1,"isSelf":-1,"subjectName":null,"questionList":null,"chapterName":null,"Additional":null,"AdditionalDes":null,"AdditionalAnswer":null,"CheckResult":null,"isType":0,"chapterIDEncrypt":null,"SubjectIDEncrypt":null,"VersionIDEncrypt":null,"GradeIDEncrypt":null,"classIDEncrypt":null},{"TabIDStr":null,"TabID":344981,"HWID":0,"studentLevel":0,"jiaobaohao":0,"AccountID":0,"isHWFinish":0,"isAdFinish":0,"HWStartTime":null,"HWEndTime":null,"useLongtime":0,"HWScore":0,"EduLevel":-1,"AddStartTime":null,"AddEndTime":null,"CheckNum":0,"CheckTeacher":null,"AddScore":0,"CheckResultJBH":null,"SubjectID":-1,"GradeID":-1,"classID":-1,"className":null,"chapterID":-1,"VersionID":0,"modulusGrade":0,"itemNumber":20,"distribution":"1:10,2:10","LongTime":0,"EXPIRYDATE":null,"EXPIRYINT":0,"CreateDate":null,"homeworkName":"2015-10-23英语英语第一节（测试）作业","jiaobaohao1":0,"AccountID1":0,"isEnable":0,"schoolName":null,"isHaveAdd":-1,"isSelf":-1,"subjectName":null,"questionList":null,"chapterName":null,"Additional":null,"AdditionalDes":null,"AdditionalAnswer":null,"CheckResult":null,"isType":0,"chapterIDEncrypt":null,"SubjectIDEncrypt":null,"VersionIDEncrypt":null,"GradeIDEncrypt":null,"classIDEncrypt":null},{"TabIDStr":null,"TabID":344703,"HWID":0,"studentLevel":0,"jiaobaohao":0,"AccountID":0,"isHWFinish":0,"isAdFinish":0,"HWStartTime":null,"HWEndTime":null,"useLongtime":0,"HWScore":0,"EduLevel":-1,"AddStartTime":null,"AddEndTime":null,"CheckNum":0,"CheckTeacher":null,"AddScore":0,"CheckResultJBH":null,"SubjectID":-1,"GradeID":-1,"classID":-1,"className":null,"chapterID":-1,"VersionID":0,"modulusGrade":0,"itemNumber":9,"distribution":"1:0,2:9","LongTime":0,"EXPIRYDATE":null,"EXPIRYINT":0,"CreateDate":null,"homeworkName":"2015-10-21数学第四章 一元一次不等式和一元一次不等式组作业","jiaobaohao1":0,"AccountID1":0,"isEnable":0,"schoolName":null,"isHaveAdd":-1,"isSelf":-1,"subjectName":null,"questionList":null,"chapterName":null,"Additional":null,"AdditionalDes":null,"AdditionalAnswer":null,"CheckResult":null,"isType":0,"chapterIDEncrypt":null,"SubjectIDEncrypt":null,"VersionIDEncrypt":null,"GradeIDEncrypt":null,"classIDEncrypt":null},{"TabIDStr":null,"TabID":344505,"HWID":0,"studentLevel":0,"jiaobaohao":0,"AccountID":0,"isHWFinish":0,"isAdFinish":0,"HWStartTime":null,"HWEndTime":null,"useLongtime":0,"HWScore":0,"EduLevel":-1,"AddStartTime":null,"AddEndTime":null,"CheckNum":0,"CheckTeacher":null,"AddScore":0,"CheckResultJBH":null,"SubjectID":-1,"GradeID":-1,"classID":-1,"className":null,"chapterID":-1,"VersionID":0,"modulusGrade":0,"itemNumber":20,"distribution":"1:10,2:10","LongTime":0,"EXPIRYDATE":null,"EXPIRYINT":0,"CreateDate":null,"homeworkName":"\"英语第一节（测试)\"","jiaobaohao1":0,"AccountID1":0,"isEnable":0,"schoolName":null,"isHaveAdd":-1,"isSelf":-1,"subjectName":null,"questionList":null,"chapterName":null,"Additional":null,"AdditionalDes":null,"AdditionalAnswer":null,"CheckResult":null,"isType":0,"chapterIDEncrypt":null,"SubjectIDEncrypt":null,"VersionIDEncrypt":null,"GradeIDEncrypt":null,"classIDEncrypt":null},{"TabIDStr":null,"TabID":344514,"HWID":0,"studentLevel":0,"jiaobaohao":0,"AccountID":0,"isHWFinish":0,"isAdFinish":0,"HWStartTime":null,"HWEndTime":null,"useLongtime":0,"HWScore":0,"EduLevel":-1,"AddStartTime":null,"AddEndTime":null,"CheckNum":0,"CheckTeacher":null,"AddScore":0,"CheckResultJBH":null,"SubjectID":-1,"GradeID":-1,"classID":-1,"className":null,"chapterID":-1,"VersionID":0,"modulusGrade":0,"itemNumber":20,"distribution":"1:10,2:10","LongTime":0,"EXPIRYDATE":null,"EXPIRYINT":0,"CreateDate":null,"homeworkName":"\"英语第一节（测试)\"","jiaobaohao1":0,"AccountID1":0,"isEnable":0,"schoolName":null,"isHaveAdd":-1,"isSelf":-1,"subjectName":null,"questionList":null,"chapterName":null,"Additional":null,"AdditionalDes":null,"AdditionalAnswer":null,"CheckResult":null,"isType":0,"chapterIDEncrypt":null,"SubjectIDEncrypt":null,"VersionIDEncrypt":null,"GradeIDEncrypt":null,"classIDEncrypt":null},{"TabIDStr":null,"TabID":43461,"HWID":0,"studentLevel":0,"jiaobaohao":0,"AccountID":0,"isHWFinish":0,"isAdFinish":0,"HWStartTime":null,"HWEndTime":null,"useLongtime":0,"HWScore":0,"EduLevel":-1,"AddStartTime":null,"AddEndTime":null,"CheckNum":0,"CheckTeacher":null,"AddScore":0,"CheckResultJBH":null,"SubjectID":-1,"GradeID":-1,"classID":-1,"className":null,"chapterID":-1,"VersionID":0,"modulusGrade":0,"itemNumber":99,"distribution":"1:34,2:65","LongTime":0,"EXPIRYDATE":null,"EXPIRYINT":0,"CreateDate":null,"homeworkName":"2015-9-22英语英语第一节（测试）作业","jiaobaohao1":0,"AccountID1":0,"isEnable":0,"schoolName":null,"isHaveAdd":-1,"isSelf":-1,"subjectName":null,"questionList":null,"chapterName":null,"Additional":null,"AdditionalDes":null,"AdditionalAnswer":null,"CheckResult":null,"isType":0,"chapterIDEncrypt":null,"SubjectIDEncrypt":null,"VersionIDEncrypt":null,"GradeIDEncrypt":null,"classIDEncrypt":null},{"TabIDStr":null,"TabID":43435,"HWID":0,"studentLevel":0,"jiaobaohao":0,"AccountID":0,"isHWFinish":0,"isAdFinish":0,"HWStartTime":null,"HWEndTime":null,"useLongtime":0,"HWScore":0,"EduLevel":-1,"AddStartTime":null,"AddEndTime":null,"CheckNum":0,"CheckTeacher":null,"AddScore":0,"CheckResultJBH":null,"SubjectID":-1,"GradeID":-1,"classID":-1,"className":null,"chapterID":-1,"VersionID":0,"modulusGrade":0,"itemNumber":30,"distribution":"1:20,2:10","LongTime":0,"EXPIRYDATE":null,"EXPIRYINT":0,"CreateDate":null,"homeworkName":"2015-9-22英语英语第一节（测试）作业--个性001","jiaobaohao1":0,"AccountID1":0,"isEnable":0,"schoolName":null,"isHaveAdd":-1,"isSelf":-1,"subjectName":null,"questionList":null,"chapterName":null,"Additional":null,"AdditionalDes":null,"AdditionalAnswer":null,"CheckResult":null,"isType":0,"chapterIDEncrypt":null,"SubjectIDEncrypt":null,"VersionIDEncrypt":null,"GradeIDEncrypt":null,"classIDEncrypt":null},{"TabIDStr":null,"TabID":43452,"HWID":0,"studentLevel":0,"jiaobaohao":0,"AccountID":0,"isHWFinish":0,"isAdFinish":0,"HWStartTime":null,"HWEndTime":null,"useLongtime":0,"HWScore":0,"EduLevel":-1,"AddStartTime":null,"AddEndTime":null,"CheckNum":0,"CheckTeacher":null,"AddScore":0,"CheckResultJBH":null,"SubjectID":-1,"GradeID":-1,"classID":-1,"className":null,"chapterID":-1,"VersionID":0,"modulusGrade":0,"itemNumber":20,"distribution":"1:10,2:10","LongTime":0,"EXPIRYDATE":null,"EXPIRYINT":0,"CreateDate":null,"homeworkName":"2015-9-22数学第四章 一元一次不等式和一元一次不等式组作业","jiaobaohao1":0,"AccountID1":0,"isEnable":0,"schoolName":null,"isHaveAdd":-1,"isSelf":-1,"subjectName":null,"questionList":null,"chapterName":null,"Additional":null,"AdditionalDes":null,"AdditionalAnswer":null,"CheckResult":null,"isType":0,"chapterIDEncrypt":null,"SubjectIDEncrypt":null,"VersionIDEncrypt":null,"GradeIDEncrypt":null,"classIDEncrypt":null},{"TabIDStr":null,"TabID":43483,"HWID":0,"studentLevel":0,"jiaobaohao":0,"AccountID":0,"isHWFinish":0,"isAdFinish":0,"HWStartTime":null,"HWEndTime":null,"useLongtime":0,"HWScore":0,"EduLevel":-1,"AddStartTime":null,"AddEndTime":null,"CheckNum":0,"CheckTeacher":null,"AddScore":0,"CheckResultJBH":null,"SubjectID":-1,"GradeID":-1,"classID":-1,"className":null,"chapterID":-1,"VersionID":0,"modulusGrade":0,"itemNumber":7,"distribution":"1:2,2:5","LongTime":0,"EXPIRYDATE":null,"EXPIRYINT":0,"CreateDate":null,"homeworkName":"2015-9-23英语英语第一节（测试）作业","jiaobaohao1":0,"AccountID1":0,"isEnable":0,"schoolName":null,"isHaveAdd":-1,"isSelf":-1,"subjectName":null,"questionList":null,"chapterName":null,"Additional":null,"AdditionalDes":null,"AdditionalAnswer":null,"CheckResult":null,"isType":0,"chapterIDEncrypt":null,"SubjectIDEncrypt":null,"VersionIDEncrypt":null,"GradeIDEncrypt":null,"classIDEncrypt":null},{"TabIDStr":null,"TabID":43463,"HWID":0,"studentLevel":0,"jiaobaohao":0,"AccountID":0,"isHWFinish":0,"isAdFinish":0,"HWStartTime":null,"HWEndTime":null,"useLongtime":0,"HWScore":0,"EduLevel":-1,"AddStartTime":null,"AddEndTime":null,"CheckNum":0,"CheckTeacher":null,"AddScore":0,"CheckResultJBH":null,"SubjectID":-1,"GradeID":-1,"classID":-1,"className":null,"chapterID":-1,"VersionID":0,"modulusGrade":0,"itemNumber":5,"distribution":"1:0,2:5","LongTime":0,"EXPIRYDATE":null,"EXPIRYINT":0,"CreateDate":null,"homeworkName":"2015-9-23英语英语第一节（测试）作业","jiaobaohao1":0,"AccountID1":0,"isEnable":0,"schoolName":null,"isHaveAdd":-1,"isSelf":-1,"subjectName":null,"questionList":null,"chapterName":null,"Additional":null,"AdditionalDes":null,"AdditionalAnswer":null,"CheckResult":null,"isType":0,"chapterIDEncrypt":null,"SubjectIDEncrypt":null,"VersionIDEncrypt":null,"GradeIDEncrypt":null,"classIDEncrypt":null}],

@end

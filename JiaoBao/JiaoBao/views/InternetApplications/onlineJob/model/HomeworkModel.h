//
//  HomeworkModel.h
//  JiaoBao
//
//  Created by songyanming on 15/10/20.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeworkModel : NSObject
@property(nonatomic,strong)NSString *TabIDStr;//
@property(nonatomic,strong)NSString *TabID;//
@property(nonatomic,strong)NSString *AccountID;//
@property(nonatomic,strong)NSString *jiaobaohao;//
@property(nonatomic,strong)NSString *SubjectID;//
@property(nonatomic,strong)NSString *GradeID;//
@property(nonatomic,strong)NSString *chapterID;//
@property(nonatomic,strong)NSString *VersionID;//
@property(nonatomic,strong)NSString *itemNumber;//
@property(nonatomic,strong)NSString *homeworkName;//
@property(nonatomic,strong)NSString *questionList;//
@property(nonatomic,strong)NSString *CreateTime;//
@property(nonatomic,strong)NSString *itemSelect;//
@property(nonatomic,strong)NSString *itemInput;//
@property (nonatomic,assign) int mInt_select;//是否选择1，否0

@end

//[{"TabIDStr":null,"TabID":91,"AccountID":0,"jiaobaohao":0,"SubjectID":0,"GradeID":0,"chapterID":0,"VersionID":0,"itemNumber":0,"homeworkName":"2015-10-15英语英语第一节（测试）作业2","questionList":null,"CreateTime":null,"itemSelect":0,"itemInput":0},
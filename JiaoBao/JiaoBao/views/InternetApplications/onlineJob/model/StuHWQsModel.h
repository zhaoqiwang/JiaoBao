//
//  StuHWQsModel.h
//  JiaoBao
//
//  Created by songyanming on 15/10/23.
//  Copyright © 2015年 JSY. All rights reserved.
//某作业下某题的作业题及答案model

#import <Foundation/Foundation.h>

@interface StuHWQsModel : NSObject
@property(nonatomic,strong)NSString *hwid;//作业ID
@property(nonatomic,strong)NSString *hwinfoid;//作业分发ID
@property(nonatomic,strong)NSString *QsId;//题目ID
@property(nonatomic,strong)NSString *QId;//题目题库ID
@property(nonatomic,strong)NSString *QsT;//题型
@property(nonatomic,strong)NSString *QsCon;// 题目
@property(nonatomic,strong)NSString *QsAns;//当前答案  多个答案时用 “，”分隔，作答内容不允许出现“，”
@property(nonatomic,strong)NSString *QsCorectAnswer;// 正确答案
@property(nonatomic,strong)NSString *QsExplain;// 解析
@property(nonatomic,strong)NSAttributedString *attributedString;
@property(nonatomic,assign)NSInteger cellHeight;
@property(nonatomic,assign)BOOL webFlag;

//{"hwid":68,"hwinfoid":717,"QsId":1,"QId":64,"QsT":1,"QsCon":"\u003cdiv id=\"Exercise_c8k1133tfOJ15211x71 \" class=\"AnalysisExerciseBox\"\u003e\r\n\u003cdiv class=\"AnalysisExerciseTitle\"\u003e\r\n\u003cinput id=\"Hidden_c8k1133tfOJ15211x71  \" type=\"hidden\" value=\"c8k1133tfOJ15211x71  \" /\u003e\r\n\u003c/div\u003e\r\n\u003cdiv style=\"clear:both;\"\u003e\u003c/div\u003e\r\n\u003cdiv class=\"AnalysisExerciseContent\"\u003e\u003cspan style=\"font-family:微软雅黑;\"\u003e Everyone of us ______ a bike to school.\u003c/span\u003e\r\n\u003cbr /\u003e\u003clabel\u003e\u003cinput  id=\"894585B82CD346BBA0649CFD6448E2E6\" type=\"radio\"  name=\"TopicRadio\" value=\"A\"  /\u003e\u003cspan style=\"font-family:微软雅黑;\"\u003eA. ride　\u003c/span\u003e\r\n\u0026emsp;\u0026emsp;\u0026emsp;\u0026emsp;\r\n\u0026emsp;\u0026emsp;\u0026emsp;\u0026emsp;\r\n\u003cbr /\u003e\u003c/label\u003e\u003clabel\u003e\u003cinput  id=\"B6A6408A11104351B71C09EEEDA120A7\" type=\"radio\"  name=\"TopicRadio\" value=\"B\"  /\u003e\u003cspan style=\"font-family:微软雅黑;\"\u003eB. to ride　\u003c/span\u003e\r\n\u0026emsp;\u0026emsp;\u0026emsp;\u0026emsp;\r\n\u0026emsp;\u0026emsp;\u0026emsp;\u0026emsp;\r\n\u003cbr /\u003e\u003c/label\u003e\u003clabel\u003e\u003cinput  id=\"668C6EE16EA0475986FC7D561D8A4F12\" type=\"radio\"  name=\"TopicRadio\" value=\"C\"  /\u003e\u003cspan style=\"font-family:微软雅黑;\"\u003eC. rides　\u003c/span\u003e\r\n\u0026emsp;\u0026emsp;\u0026emsp;\u0026emsp;\r\n\u003cbr /\u003e\u003c/label\u003e\u003clabel\u003e\u003cinput  id=\"368959AC5DC64A12BC5EEB9624613F5E\" type=\"radio\"  name=\"TopicRadio\" value=\"D\"  /\u003e\u003cspan style=\"font-family:微软雅黑;\"\u003eD. riding\u003c/span\u003e\r\n\u003cbr /\u003e\u003c/label\u003e\u003c/div\u003e\u003c/div\u003e\r\n","QsAns":null}

@end

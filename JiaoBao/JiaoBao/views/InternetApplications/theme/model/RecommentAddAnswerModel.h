//
//  RecommentAddAnswerModel.h
//  JiaoBao
//
//  Created by Zqw on 15/8/14.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RecommentQuestionModel;

@interface RecommentAddAnswerModel : NSObject

@property (nonatomic,strong) NSString *tabid;//推荐ID
@property (nonatomic,strong) RecommentQuestionModel *questionModel;
@property (nonatomic,strong) NSMutableArray *answerArray;////答案对象数组，如果为null，表示答案已被屏蔽或删除

@end

@interface RecommentQuestionModel : NSObject

@property (nonatomic,strong) NSString *TabID;//
@property (nonatomic,strong) NSString *Title;//标题
@property (nonatomic,strong) NSString *AnswersCount;//回答数量
@property (nonatomic,strong) NSString *AttCount;//关注数量
@property (nonatomic,strong) NSString *ViewCount;//浏览数量（打开看过明细的数量）
@property (nonatomic,strong) NSString *CategorySuject;//话题名称
@property (nonatomic,strong) NSString *KnContent;//内容
@property (nonatomic,strong) NSString *CategoryId;// 话题ID
@property (nonatomic,strong) NSString *LastUpdate;//动态更新日期
@property (nonatomic,strong) NSString *AreaCode;//区域代码
@property (nonatomic,strong) NSString *JiaoBaoHao;//

@end

//"tabid": 5,
//"question": {
//    "TabID": 98,
//    "Title": "为什么人有时会出现「更容易向陌生人展示真实想法」的情况",
//    "AnswersCount": 0,
//    "AttCount": 0,
//    "ViewCount": 0,
//    "CategorySuject": "艺术",
//    "KnContent": "谁不孤独</a></strong></p>",
//    "CategoryId": 0,
//    "LastUpdate": "2015-08-14T15:18:18.9722432+08:00",
//    "AreaCode": null,
//    "JiaoBaoHao": 5150022
//},
//"answers": [
//            {
//                "ATitle": "因为熟人间的关系越来越工具化了。",
//                "AFlag": 0,
//                "TabID": 89,
//                "RecDate": "2015-08-10T10:35:35",
//                "LikeCount": 0,
//                "CaiCount": 0,
//                "JiaoBaoHao": 5150001,
//                "AContent": "<p>因为熟人间的关系越来越工具化了。</p><",
//                "CCount": 0,
//                "IdFlag": "momo"
//            },
//            {
//                "ATitle": "我们时代的快节奏生活，让大多数人，慢不下来、静不下来，慢慢丧失了倾听的能力、耐心关注别人的能力。在听到别人的想法时，更急于表达建议和见解、试图解决问题，而不是陪着对方，等待情绪、情感的宣泄，让心情沉淀",
//                "AFlag": 0,
//                "TabID": 87,
//                "RecDate": "2015-08-10T10:03:55",
//                "LikeCount": 0,
//                "CaiCount": 0,
//                "JiaoBaoHao": 5150022,
//                "AContent": "<p st，他是我们的先驱。</p><p><br/></p>",
//                "CCount": 0,
//                "IdFlag": "mo5150022"
//            }
//            ]
//}
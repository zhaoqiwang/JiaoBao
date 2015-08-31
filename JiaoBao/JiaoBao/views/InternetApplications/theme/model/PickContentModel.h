//
//  PickContentModel.h
//  JiaoBao
//
//  Created by Zqw on 15/8/28.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PickContentModel : NSObject

@property (nonatomic,strong) NSString *TabID;//内容ID （下面的GetPickedById用这个字段获取精选内容明细）
@property (nonatomic,strong) NSString *Title;//内容标题
@property (nonatomic,strong) NSString *Abstracts;//内容摘要
@property (nonatomic,strong) NSMutableArray *Thumbnail;//字符串数组 答案内容前三张图片地址

@end
//{"TabID":13,"PTitle":"精选问题集1","PickDescipt":"精选问题集1精选问题集1精选问题集1\r\n精选问题集1精选问题集1精选问题集1精选问题集1\r\n","RecDate":"2015-08-23T00:03:00","ImgContent":"[\"20150823/e88c70775e75474aa03f2d0636dd7ae3.jpg\",\"20150823/74e184c48f724d7bb0d2fabf1ba1b845.jpg\"]","VedioConntent":null,"baseImgUrl":"/JBClient/userdoc/knupload/","PickContent":[{"TabID":13,"Title":"2 孩子还小，到初中、高中再学英语不迟","Abstracts":"人大脑中有一个专管语言的区域，叫“语言区”，这个语言区，从 1岁左右开始发育， 10-12 岁左右发育成熟，完全定型；这就是为什么小孩子越小，学语言越快的根本原因。因此学习语言有个“关键时期”，过","Thumbnail":"[\"http://www.jiaobao.net/JBApp3/AppFiles/getSectionFile?fn=7lui-ApUpS42Vuc-AC9TpYT2rzvfAoDg9KoPhCf-AoF-SP5hudDUiaasgVVSRFBQ1YO-SPnJwGnSpIC0\"]"},{"TabID":14,"Title":"在20-30之间寻找完全数","Abstracts":"内容最小的完全数是6，因为6的因数除了6以外，只有1、2、3，6=1+2+3；28是第二个完全数，到目前为止，一共找到了 ２３ 个完全数。另外，目前寻找到的完全数都是偶数，还没有发现奇数的完全数。","Thumbnail":null},{"TabID":15,"Title":"《师说》的论点是什么？","Abstracts":"内容所谓阐述型立论文，是全文从几个角度上去阐述论题，即多侧面地揭示论题所包含的内容或意义，它只有阐述点（或曰分论点），没有中心论点。如《鲁迅的精神》就是从四个方面阐述鲁迅先生在杂感中所表现出来的战斗精","Thumbnail":null}]}
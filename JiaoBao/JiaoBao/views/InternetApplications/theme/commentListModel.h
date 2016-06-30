//
//  commentListModel.h
//  JiaoBao
//  评论列表model
//  Created by songyanming on 15/8/6.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface commentListModel : NSObject
@property(nonatomic,strong)NSString *TabID;//评论ID
@property(nonatomic,strong)NSString *JiaoBaoHao;//教宝号
@property(nonatomic,strong)NSString *Number;//楼号
@property(nonatomic,strong)NSString *RefIds;//引用ID
@property(nonatomic,strong)NSString *RecDate;//回答时间
@property(nonatomic,strong)NSString *CaiCount;//踩的数量
@property(nonatomic,strong)NSString *LikeCount;//点赞数量
@property(nonatomic,strong)NSString *WContent;//内容
@property(nonatomic,strong)NSString *UserName;//评论者
@property(nonatomic,strong)NSString *TabIDStr;
@property(nonatomic,assign)BOOL Likeselected;//0:没赞 1：已赞
@property(nonatomic,assign)BOOL Caiselected;//0:没踩 1：已踩

@end

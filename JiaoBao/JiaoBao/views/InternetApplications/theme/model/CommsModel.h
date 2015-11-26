//
//  CommsModel.h
//  JiaoBao
//
//  Created by songyanming on 15/11/25.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommsModel : NSObject
@property(nonatomic,strong)NSString *TabID;//评论ID
@property(nonatomic,strong)NSString *WContent;//内容
@property(nonatomic,strong)NSString *QId;//所属问题ID
@property(nonatomic,strong)NSString *AId;//所属答案ID
@property(nonatomic,strong)NSString *LikeCount;//支持数
@property(nonatomic,strong)NSString *CaiCount;//反对数
@property(nonatomic,strong)NSString *RecDate;//最后更新时间
@property(nonatomic,strong)NSString *rowCount;//记录数量


@end

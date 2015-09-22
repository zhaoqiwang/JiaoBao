//
//  AllCommentListModel.h
//  JiaoBao
//
//  Created by songyanming on 15/8/6.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "commentListModel.h"

@interface AllCommentListModel : NSObject
@property(nonatomic,strong)NSMutableArray *mArr_CommentList;
@property(nonatomic,strong)NSMutableArray *mArr_refcomments;
@property(nonatomic,strong)NSString *RowCount;

@end

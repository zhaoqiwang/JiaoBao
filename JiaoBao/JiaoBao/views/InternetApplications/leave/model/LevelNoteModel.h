//
//  LevelNoteModel.h
//  JiaoBao
//  请假设置子model
//  Created by SongYanming on 16/3/10.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelNoteModel : NSObject
@property(nonatomic,strong)NSString *A;//一审
@property(nonatomic,strong)NSString *B;//二审
@property(nonatomic,strong)NSString *C;//三审
@property(nonatomic,strong)NSString *D;//四审
@property(nonatomic,strong)NSString *E;//五审
-(void)dicToModel:(NSString*)dicStr;//解析审核级别



@end

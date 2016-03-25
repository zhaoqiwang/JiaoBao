//
//  LevelNoteModel.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/10.
//  Copyright © 2016年 JSY. All rights reserved.
//请假设置子model

#import <Foundation/Foundation.h>

@interface LevelNoteModel : NSObject
@property(nonatomic,strong)NSString *A;
@property(nonatomic,strong)NSString *B;
@property(nonatomic,strong)NSString *C;
@property(nonatomic,strong)NSString *D;
@property(nonatomic,strong)NSString *E;
-(void)dicToModel:(NSString*)dicStr;



@end

//
//  ClassModel.m
//  JiaoBao
//
//  Created by Zqw on 15-3-27.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ClassModel.h"

@implementation ClassModel
@synthesize TabIDStr,ClickCount,Context,JiaoBaoHao,LikeCount,RecDate,Source,StarJson,State,Title,Abstracts,Thumbnail,ViewCount,SectionID,FeeBackCount,UserName,UnitName;

-(id)init{
    self.Thumbnail = [NSMutableArray array];
    return self;
}

@end

//
//  ClassModel.m
//  JiaoBao
//
//  Created by Zqw on 15-3-27.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ClassModel.h"

@implementation ClassModel
@synthesize TabIDStr,ClickCount,Context,JiaoBaoHao,LikeCount,RecDate,Source,StarJson,State,Title,Abstracts,Thumbnail,ViewCount,SectionID,FeeBackCount,UserName,UnitName,flag,className,classID,unitId,UnitType;

-(id)init{
    self.Thumbnail = [NSMutableArray array];
    self.TabIDStr = @"";
    self.ClickCount = @"";
    self.Context = @"";
    self.JiaoBaoHao = @"";
    self.LikeCount = @"";
    self.RecDate = @"";
    self.Source = @"";
    self.StarJson = @"";
    self.State = @"";
    self.Title = @"";
    self.Abstracts = @"";
    self.ViewCount = @"";
    self.SectionID = @"";
    self.FeeBackCount = @"";
    self.UserName = @"";
    self.UnitName = @"";
    self.flag = @"";
    self.className = @"";
    self.classID = @"";
    self.UnitType = @"";
    self.unitId = @"";
    return self;
}

@end

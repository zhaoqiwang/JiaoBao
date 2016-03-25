//
//  LeaveSettingModel.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/10.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "LeaveSettingModel.h"

@implementation LeaveSettingModel
-(instancetype)init
{
    self = [super init];
    self.LevelNoteStd = [[LevelNoteModel alloc]init];
    self.LevelNoteTea = [[LevelNoteModel alloc]init];
    self.ApproveListStd = [[LevelNoteModel alloc]init];
    self.ApproveListTea = [[LevelNoteModel alloc]init];


    return self;
}

@end

//
//  NewWorkTree_model.m
//  JiaoBao
//
//  Created by Zqw on 15/4/29.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "NewWorkTree_model.h"

@implementation NewWorkTree_model
@synthesize mStr_classID,mStr_img_open_close,mStr_name,mModel_group,mModel_unit,mModel_people;

-(id)init{
    self = [super init];
    self.mModel_unit = [[myUnit alloc] init];
    self.mModel_group = [[UserListModel alloc] init];
    self.mModel_people = [[groupselit_selitModel alloc] init];
    return self;
}

@end

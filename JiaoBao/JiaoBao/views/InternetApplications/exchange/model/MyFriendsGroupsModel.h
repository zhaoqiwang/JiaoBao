//
//  MyFriendsGroupsModel.h
//  JiaoBao
//
//  Created by Zqw on 14-12-31.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyFriendsGroupsModel : NSObject{
    NSString *ID;
    NSString *GroupName;
}

@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *GroupName;

@end
//[{"ID":"0","GroupName":"我的好友"},{"ID":"1","GroupName":"同事"}]
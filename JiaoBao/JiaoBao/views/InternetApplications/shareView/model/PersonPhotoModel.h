//
//  PersonPhotoModel.h
//  JiaoBao
//  个人相册列表
//  Created by Zqw on 14-12-23.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonPhotoModel : NSObject{
    NSString *ID;
    NSString *GroupName;
    NSString *SMPhotoPath;
    NSString *accid;
}

@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *GroupName;
@property (nonatomic,strong) NSString *SMPhotoPath;
@property (nonatomic,strong) NSString *accid;

@end
//[{"ID":"NDJENERBMDkwMDA3QzI5QQ","GroupName":"我的相册"},{"ID":"M0NFODU0RjFDRThDM0Q1Mw","GroupName":"手机相册"}]
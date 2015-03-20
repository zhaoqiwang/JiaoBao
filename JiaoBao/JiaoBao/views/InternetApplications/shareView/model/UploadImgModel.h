//
//  UploadImgModel.h
//  JiaoBao
//
//  Created by Zqw on 14-11-24.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadImgModel : NSObject{
    NSString *originalName;
    NSString *url;
    NSString *size;
    NSString *type;
}

@property (nonatomic,strong) NSString *originalName;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *size;
@property (nonatomic,strong) NSString *type;

@end
//{"originalName":"111.png","url":"http://www.jsyoa.edu8800.com/JBClient/AppFiles/getSectionFiletmp?fn=Igk9iyhkIXk-SO1PKKtwm2okVzWqFDHHlYj2p7jmiXDi4iQvGJSvyt6-SQITdEQCQXPnJwGnSpIC0","size":221682,"type":".png"}
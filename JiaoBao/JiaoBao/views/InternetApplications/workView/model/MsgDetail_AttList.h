//
//  MsgDetail_AttList.h
//  JiaoBao
//
//  Created by Zqw on 14-10-28.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgDetail_AttList : NSObject{
    NSString *dlurl;
    NSString *OrgFilename;
    NSString *FileSize;
}
@property (nonatomic,strong) NSString *dlurl;
@property (nonatomic,strong) NSString *OrgFilename;
@property (nonatomic,strong) NSString *FileSize;

@end
//"AttList":"[{\"dlurl\":\"http://www.jiaobao.net/jbapp/AppFiles/dlfile/MjNGNTkyODgwOURGQTAyQg\",\"OrgFilename\":\"Android教宝开发文档.doc\",\"FileSize\":\"83.5 KB\"}]"
//
//  selitadminModel.h
//  JiaoBao
//
//  Created by Zqw on 14-11-11.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface selitadminModel : NSObject{
    NSString *groupName;
    NSString *UnitType;
    NSMutableArray *UserList;
    NSString *SendFlag;
}
@property (nonatomic,strong) NSString *groupName;
@property (nonatomic,strong) NSString *UnitType;
@property (nonatomic,strong) NSMutableArray *UserList;
@property (nonatomic,strong) NSString *SendFlag;

@end
//"selitadmintomem":[{"groupName":"小学","UnitType":2,"UserList":[{"selit":"OUU2NDUwMkY5MTY4QzhFN0VGMjcwQkE4NzVBMDBGQkY2QzdFQTA1RTI3Rjc3NkExMDU5NDA4MTY3RDNCRjc5MkM1NThCRjIyQ0REQzMwM0FDNkYyQTc2MDYyQTcwRDVDMjUzNEQ2MTRERTUyQkUxNUREOEFCN0Q3MTA3NjY2NTMyQkJBQTc2OUYwQkE4RjZEREY3OTRCOERBMUE2Nzg4OTJFMzRGN0I1Rjk5MEM2ODVCQTI3NDAxNDEzNDA0NTJDOUQ4NDVBQUI2MDRGQzFFMw","AccID":"5150028","isAdmin":3,"Name":"演示学校一[马文彬(139*,有)]","SendFlag":1}]}],
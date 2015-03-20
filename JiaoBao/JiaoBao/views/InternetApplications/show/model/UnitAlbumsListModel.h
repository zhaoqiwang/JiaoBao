//
//  UnitAlbumsListModel.h
//  JiaoBao
//
//  Created by Zqw on 14-12-19.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitAlbumsListModel : NSObject{
    NSString *TabID;//照片ID
    NSString *CreateByjiaobaohao;//照片创建人
    NSString *SMPhotoPath;//照片对应的小图片url
    NSString *BIGPhotoPath;//照片对应的原始照片的URL
    NSString *PhotoDescribe;//照片描述
}

@property (nonatomic,strong) NSString *TabID;
@property (nonatomic,strong) NSString *CreateByjiaobaohao;
@property (nonatomic,strong) NSString *SMPhotoPath;
@property (nonatomic,strong) NSString *BIGPhotoPath;
@property (nonatomic,strong) NSString *PhotoDescribe;

@end
//[{"TabID":"4078","CreateByjiaobaohao":"5150001","SMPhotoPath":"http://localhost:5057//UploadPhotoOfUnit/20141125/5150001/20141125213805d417_IMG_1792.jpg","BIGPhotoPath":"http://localhost:5057//UploadPhotoOfUnitBig/20141125/5150001/20141125213805d417_IMG_1792.jpg","PhotoDescribe":""}
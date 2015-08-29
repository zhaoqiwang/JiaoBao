//
//  PickedIndexModel.h
//  JiaoBao
//
//  Created by Zqw on 15/8/29.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PickedIndexModel : NSObject

@property (nonatomic,strong) NSString *TabID;
@property (nonatomic,strong) NSString *PTitle;
@property (nonatomic,strong) NSString *PickDescipt;
@property (nonatomic,strong) NSString *RecDate;
@property (nonatomic,strong) NSMutableArray *ImgContent;
@property (nonatomic,strong) NSString *baseImgUrl;
@property (nonatomic,strong) NSString *RowCount;

@end

//[{"TabID":23,"PTitle":"鹅鹅鹅饿鹅鹅鹅鹅鹅鹅鹅鹅鹅饿鹅鹅鹅额额鹅鹅鹅鹅鹅鹅饿鹅鹅鹅饿鹅鹅鹅饿鹅鹅鹅饿鹅鹅鹅饿鹅鹅鹅","PickDescipt":"\r\n鹅鹅鹅鹅鹅鹅饿鹅鹅鹅饿鹅鹅鹅鹅鹅鹅鹅鹅鹅饿鹅鹅鹅额额鹅鹅鹅鹅鹅鹅饿鹅鹅鹅饿鹅鹅鹅饿鹅鹅鹅饿鹅鹅鹅饿鹅鹅鹅额呃呃呃呃呃鹅鹅鹅鹅鹅鹅鹅鹅鹅谔谔","RecDate":"2015-08-28T15:57:00","ImgContent":"[\"20150828/6ff52accf2d5413c9d0720c1e2e4b883.jpg\",\"20150828/b2151492d94548929671bcf603c3ffbc.jpg\",\"20150828/3169123f228a4fe1a6e091b8d9a269b5.jpg\",\"20150828/29abfa73c3844c7ebe87c4a5b70b1b2d.jpg\",\"20150828/657313d4f04a49bbad8c78963fc85b8f.jpg\",\"20150828/9f9508a520bb4a3180c5581d4cfbdb66.jpg\"]","baseImgUrl":"/JBClient/userdoc/knupload/","RowCount":6}]
//
//  GetArthInfoModel.h
//  JiaoBao
//
//  Created by Zqw on 15-2-2.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetArthInfoModel : NSObject{
    int TabID;
    int ClickCount;
    int LikeCount;
    int StarJson;
    int State;
    int ViewCount;
    int FeeBackCount;
    int Likeflag;
}

@property (nonatomic,assign) int TabID;
@property (nonatomic,assign) int ClickCount;
@property (nonatomic,assign) int LikeCount;
@property (nonatomic,assign) int StarJson;
@property (nonatomic,assign) int State;
@property (nonatomic,assign) int ViewCount;
@property (nonatomic,assign) int FeeBackCount;
@property (nonatomic,assign) int Likeflag;

@end
//{"TabID":368263,"ClickCount":27,"LikeCount":7,"StarJson":null,"State":1,"ViewCount":16,"FeeBackCount":4,"Likeflag":0}
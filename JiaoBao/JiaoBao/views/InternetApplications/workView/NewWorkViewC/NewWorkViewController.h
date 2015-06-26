//
//  NewWorkViewController.h
//  JiaoBao
//
//  Created by Zqw on 15-4-23.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "NewWorkTopScrollView.h"
#import "NewWorkRootScrollView.h"
#import "utils.h"
#import "LoginSendHttp.h"


@interface NewWorkViewController : UIViewController<MyNavigationDelegate,MBProgressHUDDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    NewWorkRootScrollView *rootView;
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property(nonatomic,strong)NewWorkTopScrollView *top;
@property (nonatomic,strong) NewWorkRootScrollView *rootView;
@property(nonatomic,strong)NSDictionary *rightDic;


@end

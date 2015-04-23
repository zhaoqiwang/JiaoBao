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

@interface NewWorkViewController : UIViewController<MyNavigationDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条

@end

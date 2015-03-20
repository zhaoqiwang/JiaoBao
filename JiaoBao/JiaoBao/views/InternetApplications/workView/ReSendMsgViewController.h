//
//  ReSendMsgViewController.h
//  JiaoBao
//
//  Created by Zqw on 15-2-13.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "utils.h"
#import "dm.h"
#import "define_constant.h"
#import "MBProgressHUD.h"
;
@interface ReSendMsgViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MyNavigationDelegate,MBProgressHUDDelegate,UITextFieldDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UICollectionView *mCollentV_member;//放人员显示列表
    UITextField *mTextF_text;//输入框
    UIButton *mBtn_send;//发送按钮
    UIView *mView_text;//放输入框
    NSMutableArray *mArr_member;//人员数组
    MBProgressHUD *mProgressV;//
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UICollectionView *mCollentV_member;//放人员显示列表
@property (nonatomic,strong) IBOutlet UITextField *mTextF_text;//输入框
@property (nonatomic,strong) IBOutlet UIButton *mBtn_send;//发送按钮
@property (nonatomic,strong) IBOutlet UIView *mView_text;//放输入框
@property (nonatomic,strong) NSMutableArray *mArr_member;//人员数组
@property (nonatomic,strong) MBProgressHUD *mProgressV;//

@end

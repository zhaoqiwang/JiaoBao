//
//  MsgDetailViewController.h
//  JiaoBao
//
//  Created by Zqw on 14-10-28.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "TreeView_Level2_Model.h"
#import "LoginSendHttp.h"
#import "UnReadMsg_model.h"
#import "MsgDetail_FeebackList.h"
#import "MsgDetail_Cell.h"
#import "MBProgressHUD.h"
#import "ForwardViewController.h"
#import "Loger.h"

@interface MsgDetailViewController : UIViewController<MyNavigationDelegate,UIGestureRecognizerDelegate,MBProgressHUDDelegate,MWPhotoBrowserDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UIScrollView *mScrollV_view;//放所有控件
    UIImageView *mImgV_head;//头像
    UILabel *mLab_name;//姓名
    UITextView *mTextV_content;//内容详情
    UILabel *mLab_time;//时间
    UIButton *mBtn_detail;//接收人详情切换按钮
    UITableView *mTableV_detail;//详情列表
    UITextField *mTextF_text;//输入框
    UIButton *mBtn_send;//发送按钮
    TreeView_Level2_Model *mModel_tree2;//model
    UnReadMsg_model *mModel_unReadMsg;//model
    NSMutableArray *mArr_feeback;//回复者数组
    int mInt_detail;//判断列表显示哪个，0是回复，1是查阅
    UIButton *mBtn_more;//查看更多按钮
    UIView *mView_text;//放输入框
    UIButton *mBtn_trun;//转发按钮
    MBProgressHUD *mProgressV;//
    int mInt_page;//记录当前请求的详情数据，是第几页
    int mInt_file;//记录当前点击的文件索引
    int mInt_more;//是否显示加载更多按钮，0显示，1不显示
    NSMutableArray *mArr_photos;
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UIScrollView *mScrollV_view;//放所有控件
@property (nonatomic,strong) IBOutlet UIImageView *mImgV_head;//头像
@property (nonatomic,strong) IBOutlet UILabel *mLab_name;//姓名
@property (nonatomic,strong) IBOutlet UITextView *mTextV_content;//内容详情
@property (nonatomic,strong) IBOutlet UILabel *mLab_time;//时间
@property (nonatomic,strong) IBOutlet UIButton *mBtn_detail;//接收人详情切换按钮
@property (nonatomic,strong) IBOutlet UITableView *mTableV_detail;//详情列表
@property (nonatomic,strong) IBOutlet UITextField *mTextF_text;//输入框
@property (nonatomic,strong) IBOutlet UIButton *mBtn_send;//发送按钮
@property (nonatomic,strong) TreeView_Level2_Model *mModel_tree2;//model
@property (nonatomic,strong) UnReadMsg_model *mModel_unReadMsg;//model
@property (nonatomic,strong) NSMutableArray *mArr_feeback;//回复者数组
@property (nonatomic,assign) int mInt_detail;//判断列表显示哪个，0是回复，1是查阅
@property (nonatomic,strong) IBOutlet UIButton *mBtn_more;//查看更多按钮
@property (nonatomic,strong) IBOutlet UIView *mView_text;//放输入框
@property (nonatomic,strong) IBOutlet UIButton *mBtn_trun;//转发按钮
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property (nonatomic,assign) int mInt_page;//记录当前请求的详情数据，是第几页
@property (nonatomic,assign) int mInt_file;//记录当前点击的文件索引
@property (nonatomic,assign) int mInt_more;//是否显示加载更多按钮，0显示，1不显示
@property (nonatomic,strong) NSMutableArray *mArr_photos;

@end

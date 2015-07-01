//
//  WorkMsgListViewController.h
//  JiaoBao
//
//  Created by Zqw on 15-2-10.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "define_constant.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "WorkMsgListCell.h"
#import "SendToMeUserListModel.h"
#import "LoginSendHttp.h"
#import "MsgDetailViewController.h"
#import "TreeView_Level2_Model.h"


@interface WorkMsgListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MyNavigationDelegate,MBProgressHUDDelegate,MWPhotoBrowserDelegate,NSURLConnectionDownloadDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UITableView *mTableV_detail;//详情列表
    UITextField *mTextF_text;//输入框
    UIButton *mBtn_send;//发送按钮
    UIView *mView_text;//放输入框
    MBProgressHUD *mProgressV;//
    NSMutableArray *mArr_list;//总数组
    NSMutableArray *mArr_msg;//信息数组
    NSMutableArray *mArr_feeback;//回复数组
    int mInt_up;//下拉时加载的索引
    int mInt_down;//上拉时加载的索引
    NSString *mStr_lastID;//判断是否还能继续加载
    NSString *mStr_name;//nav名称
    NSString *mStr_tableID;//加载详情
    int mInt_page;//记录当前请求的详情数据，是第几页
    NSMutableArray *mArr_attList;//附件数组
    int mInt_file;//记录当前点击的文件索引
    int mInt_flag;//判断是详情页2，还是列表页1
    int mInt_our;//判断是自己的发送列表1，还是别人的2
    int mInt_msg;//消息列表第几页
    NSMutableArray *mArr_readList;//当前显示详情的阅读人员
    NSString *mStr_flag;//我自己发送的信息中，未读数量
    NSMutableArray *mArr_photos;
}
@property (weak, nonatomic) IBOutlet UIButton *dropDownBtn;
@property (weak, nonatomic) IBOutlet UILabel *dropDownLabel;

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UITableView *mTableV_detail;//详情列表
@property (nonatomic,strong) IBOutlet UITextField *mTextF_text;//输入框
@property (nonatomic,strong) IBOutlet UIButton *mBtn_send;//发送按钮
@property (nonatomic,strong) IBOutlet UIView *mView_text;//放输入框
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property (nonatomic,strong) NSMutableArray *mArr_list;//总数组
@property (nonatomic,strong) NSMutableArray *mArr_msg;//信息数组
@property (nonatomic,strong) NSMutableArray *mArr_feeback;//回复数组
@property (nonatomic,assign) int mInt_up;//下拉时加载的索引
@property (nonatomic,assign) int mInt_down;//上拉时加载的索引
@property (nonatomic,strong) NSString *mStr_lastID;//判断是否还能继续加载
@property (nonatomic,strong) NSString *mStr_name;//nav名称
@property (nonatomic,strong) NSString *mStr_tableID;//加载详情
@property (nonatomic,assign) int mInt_page;//记录当前请求的详情数据，是第几页
@property (nonatomic,strong) NSMutableArray *mArr_attList;//附件数组
@property (nonatomic,assign) int mInt_file;//记录当前点击的文件索引
@property (nonatomic,assign) int mInt_flag;//判断是详情页2，还是列表页1
@property (nonatomic,assign) int mInt_our;//判断是自己的发送列表1，还是别人的2
@property (nonatomic,assign) int mInt_msg;//消息列表
@property (nonatomic,strong) NSMutableArray *mArr_readList;//当前显示详情的阅读人员
@property (nonatomic,strong) NSString *mStr_flag;//我自己发送的信息中，未读数量
@property (nonatomic,strong) NSMutableArray *mArr_photos;

@end

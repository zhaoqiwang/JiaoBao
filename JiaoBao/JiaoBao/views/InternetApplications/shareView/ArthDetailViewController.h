//
//  ArthDetailViewController.h
//  JiaoBao
//
//  Created by Zqw on 14-11-21.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "TopArthListModel.h"
#import "ShareHttp.h"
#import "MBProgressHUD.h"
#import "NoticeInfoModel.h"
#import "CommentsListObjModel.h"
#import "AirthCommentsListCell.h"
#import "PersonalSpaceViewController.h"

@interface ArthDetailViewController : UIViewController<MyNavigationDelegate,UIWebViewDelegate,MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate,AirthCommentsListCellDelegate,AirthCommentsListCellHeadDelegate,UITextFieldDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UIScrollView *mScrollV_view;
    UILabel *mLab_title;//标题
    UILabel *mLab_name;//作者
    UILabel *mLab_time;//时间
    UIWebView *mWebV_js;//显示文章
    UIImageView *mImgV_click;//点击次数
    UILabel *mLab_click;//点击次数
    UIImageView *mImgV_View;//观看次数
    UILabel *mLab_View;//观看次数
    UIImageView *mImgV_like;//赞次数
    UILabel *mLab_like;//赞次数
    TopArthListModel *Arthmodel;//传过来的文章的model
    ArthDetailModel *mModel;
    MBProgressHUD *mProgressV;//
    int mInt_from;//来自分享和展示1还是内务2
    NSString *mStr_tableID;//内务的加密ID
    NSString *mStr_title;//内务标题
    NoticeInfoModel *mModel_notice;//通知model
    UITextField *mTextF_text;//输入框
    UIButton *mBtn_send;//发送按钮
    UIView *mView_text;//放输入框
    UITableView *mTableV_detail;//详情列表
    NSMutableArray *mArr_feeback;//回复者数组
    UIButton *mBtn_more;//查看更多按钮
    int mInt_page;//记录当前请求的详情数据，是第几页
    CommentsListObjModel *mModel_commentList;
    GetArthInfoModel *mModel_arthInfo;//文件附加信息
}

@property (nonatomic,strong) GetArthInfoModel *mModel_arthInfo;//文件附加信息
@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UIWebView *mWebV_js;
@property (nonatomic,strong) TopArthListModel *Arthmodel;//传过来的文章的model
@property (nonatomic,strong) IBOutlet UIScrollView *mScrollV_view;
@property (nonatomic,strong) IBOutlet UILabel *mLab_title;//标题
@property (nonatomic,strong) IBOutlet UILabel *mLab_name;//作者
@property (nonatomic,strong) IBOutlet UILabel *mLab_time;//时间
@property (nonatomic,strong) IBOutlet UIImageView *mImgV_click;//点击次数
@property (nonatomic,strong) IBOutlet UILabel *mLab_click;//点击次数
@property (nonatomic,strong) IBOutlet UIImageView *mImgV_View;//观看次数
@property (nonatomic,strong) IBOutlet UILabel *mLab_View;//观看次数
@property (nonatomic,strong) IBOutlet UIImageView *mImgV_like;//赞次数
@property (nonatomic,strong) IBOutlet UILabel *mLab_like;//赞次数
@property (nonatomic,strong) ArthDetailModel *mModel;
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property (nonatomic,assign) int mInt_from;//来自分享和展示1还是内务2
@property (nonatomic,strong) NSString *mStr_tableID;//内务的加密ID
@property (nonatomic,strong) NSString *mStr_title;//内务标题
@property (nonatomic,strong) NoticeInfoModel *mModel_notice;//通知model

@property (nonatomic,strong) IBOutlet UITextField *mTextF_text;//输入框
@property (nonatomic,strong) IBOutlet UIButton *mBtn_send;//发送按钮
@property (nonatomic,strong) IBOutlet UIView *mView_text;//放输入框

@property (nonatomic,strong) IBOutlet UITableView *mTableV_detail;//详情列表
@property (nonatomic,strong) NSMutableArray *mArr_feeback;//回复者数组
@property (nonatomic,strong) IBOutlet UIButton *mBtn_more;//查看更多按钮
@property (nonatomic,assign) int mInt_page;//记录当前请求的详情数据，是第几页
@property (nonatomic,strong) CommentsListObjModel *mModel_commentList;

//点击更多按钮
-(IBAction)mBtn_more:(UIButton *)btn;

@end

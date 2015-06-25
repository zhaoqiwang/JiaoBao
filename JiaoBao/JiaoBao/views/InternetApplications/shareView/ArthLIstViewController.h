//
//  ArthLIstViewController.h
//  JiaoBao
//
//  Created by Zqw on 14-11-22.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "ShareHttp.h"
#import "TopArthListCell.h"
#import "ArthDetailViewController.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"//上拉下拉刷新
#import "SharePostingViewController.h"
#import "PersonalSpaceViewController.h"

@interface ArthLIstViewController : UIViewController<MyNavigationDelegate,MBProgressHUDDelegate,TopArthListCellDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UITableView *mTableV_list;//文章列表
    NSString *mStr_title;//班级名称
    NSString *mStr_classID;//班级ID
    NSMutableArray *mArr_list;//获取到的文章数组
//    MBProgressHUD *mProgressV;//
    int mInt_index;//当前应该加载的第几页
    int mInt_flag;//判断是学校0还是单位1，showview中3
    NSString *mStr_flag;//showview中3，是1最新2推荐
    int mInt_section;//判断是来自分享0还是展示1
    UIButton *mBtn_posting;//发表文章
    int mInt_class;//是否自己所在班级，1在，2不在
    NSString *mStr_local;//showview中，是否本地
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UITableView *mTableV_list;//文章列表
@property (nonatomic,strong) NSString *mStr_title;//班级名称
@property (nonatomic,strong) NSString *mStr_classID;//班级ID
@property (nonatomic,strong) NSMutableArray *mArr_list;//获取到的文章数组
//@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property (nonatomic,assign) int mInt_index;//当前应该加载的第几页
@property (nonatomic,assign) int mInt_flag;//判断是学校0还是单位1
@property (nonatomic,assign) int mInt_section;//判断是来自分享0还是展示1
@property (nonatomic,strong) UIButton *mBtn_posting;//发表文章
@property (nonatomic,assign) int mInt_class;//是否自己所在班级，1在，2不在
@property (nonatomic,strong) NSString *mStr_local;//showview中，是否本地
@property (nonatomic,strong) NSString *mStr_flag;//showview中3，是1最新2推荐

@end

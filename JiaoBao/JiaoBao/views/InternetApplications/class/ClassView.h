//
//  ClassView.h
//  JiaoBao
//
//  Created by Zqw on 15-3-19.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"
#import "ClassTableViewCell.h"
#import "ClassHttp.h"
#import "MBProgressHUD+AD.h"
#import "MJRefresh.h"//上拉下拉刷新
#import "ArthDetailViewController.h"
#import "ClassTopViewController.h"
#import "SharePostingViewController.h"
#import "UnitSpaceViewController.h"
#import "MWPhotoBrowser.h"
#import "PopupWindow.h"
#import "UIImageView+WebCache.h"

@interface ClassView : UIView<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,ClassTableViewCellDelegate,ClassTableViewCellHeadImgDelegate,MWPhotoBrowserDelegate,PopupWindowDelegate,UITextFieldDelegate>{
    UIView *mView_button;//放四个按钮
    UITableView *mTableV_list;//表格
    NSMutableArray *mArr_unit;//本单位
    NSMutableArray *mArr_class;//本班级
    NSMutableArray *mArr_local;//本地
    NSMutableArray *mArr_attention;//关注
    NSMutableArray *mArr_sum;//全部
    UIButton *mBtn_photo;//拍照发布
    int mInt_index;//当前点击的是第几个
//    UIScrollView *mScrollV_sum;//放可滑动组件
    NSMutableArray *mArr_unitTop;//本单位
    NSMutableArray *mArr_classTop;//本班级
    NSMutableArray *mArr_localTop;//本地
    NSMutableArray *mArr_attentionTop;//关注
    NSMutableArray *mArr_sumTop;//全部
    int mInt_flag;//判断是否在下拉刷新,1是在刷新
    PopupWindow *mView_popup;//点赞评论弹出框
    UIView *mView_text;//放输入框
    UITextField *mTextF_text;//输入框
    UIButton *mBtn_send;//发送按钮
    int mInt_changeUnit;//判断是主动切换单位请求1，还是进入新建事务0，做是否发生获取文章请求用
}

@property (nonatomic,strong) UIView *mView_button;//放四个按钮
@property (nonatomic,strong) UITableView *mTableV_list;
@property (nonatomic,strong) NSMutableArray *mArr_unit;//本单位
@property (nonatomic,strong) NSMutableArray *mArr_class;//本班级
@property (nonatomic,strong) NSMutableArray *mArr_local;//本地
@property (nonatomic,strong) NSMutableArray *mArr_attention;//关注
@property (nonatomic,strong) NSMutableArray *mArr_sum;//全部
@property (strong,nonatomic) UIButton *mBtn_photo;//拍照发布
@property (assign,nonatomic) int mInt_index;//当前点击的是第几个
//@property (strong,nonatomic) UIScrollView *mScrollV_sum;//放可滑动组件
@property (nonatomic,strong) NSMutableArray *mArr_unitTop;//本单位
@property (nonatomic,strong) NSMutableArray *mArr_classTop;//本班级
@property (nonatomic,strong) NSMutableArray *mArr_localTop;//本地
@property (nonatomic,strong) NSMutableArray *mArr_attentionTop;//关注
@property (nonatomic,strong) NSMutableArray *mArr_sumTop;//全部
@property (assign,nonatomic) int mInt_flag;//判断是否在下拉刷新
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic,strong)NSArray *commentArr;
@property (nonatomic,strong)NSArray *nameArr;
@property (nonatomic,strong) PopupWindow *mView_popup;//点赞评论弹出框
@property (nonatomic,strong) UIView *mView_text;//放输入框
@property (nonatomic,strong) UITextField *mTextF_text;//输入框
@property (nonatomic,strong) UIButton *mBtn_send;//发送按钮
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,assign)NSUInteger finishSymbol,finishSybmol2;//两次连续请求全部完成的标志
@property(nonatomic,strong)NSThread *thread;
@property(nonatomic,assign)NSUInteger threadSymbol;
@property(nonatomic,assign)BOOL symbol;
@property (nonatomic,assign) int mInt_changeUnit;

- (id)initWithFrame1:(CGRect)frame;

//刚进入学校圈，或者下拉刷新时执行
-(void)tableViewDownReloadData;

//当切换账号时，将此界面的所有数组清空
-(void)clearArray;

@end

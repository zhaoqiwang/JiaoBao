//
//  ForwardViewController.h
//  JiaoBao
//  转发页面
//  Created by Zqw on 14-11-4.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "utils.h"
#import "dm.h"
#import "LoginSendHttp.h"
#import "Forward_cell.h"
#import "Forward_section.h"
#import "MBProgressHUD.h"
#import "SMSTreeArrayModel.h"
#import "ELCImagePickerHeader.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "AccessoryViewController.h"
#import "InsideWorkView.h"
#import "NewWorkTopView.h"

@interface ForwardViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,Forward_sectionDelegate,UIGestureRecognizerDelegate,MBProgressHUDDelegate,UITextViewDelegate,UIActionSheetDelegate,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate,AccessoryViewControllerProtocol,NewWorkTopViewProtocol>{
    MyNavigationBar *mNav_navgationBar;//导航条
    int mInt_flag;//判断是普通获取1，还是短信直通车获取2
    int mInt_all;//是否群发，1是，2不是
    UIScrollView *mScrollV_all;//放所有控件
    UIView *mView_unit;//当前单位总显示
    UILabel *mLab_1;//当前单位
    UILabel *mLab_2;//上级单位
    UILabel *mLab_3;//下级单位
    UILabel *mLab_5;//老师身份时，执教班级
    UITextView *mTextV_enter;//输入框
    UIButton *mBtn_sendMsg;//是否发送短信
    UILabel *mLab_4;//光显示用，当前接收人
    UIButton *mBtn_all;//接收人全选
    UIButton *mBtn_invertSelect;//接收人反选
    UIButton *mBtn_send;//发表
    UICollectionView *mCollectionV_list;//人员具体显示
    UIView *mView_switch;//切换单位
    UITableView *mTableV_default;//默认获取到的四个
    UITableView *mTalbeV_sub;//单位的子类
    CMRevicerModel *mModel_CMRevicer;
    int mInt_right;//点击导航条右键时，判断隐藏还是显示切换界面,1显示，2隐藏
    int mInt_defaultTV_index;//记录点击默认表格的索引
    NSString *mStr_unit;//当前单位的名称
    int mInt_select_send;//当全局全选1、反选2、发表时3，用于区分，
    MBProgressHUD *mProgressV;//
    int mInt_sendMsg;//是否发送短信，0发送，1不发送
    UIScrollView *mScroll_btn3;//下级单位可以滑动
    UIScrollView *mScroll_btn5;//执教班级可以滑动
//    myUnitRevicerModel *mModel_myUnit;//当前界面显示的人员model
    UnitClassRevicerModel *mModel_class;//当身份切换为老师时，用此model显示人员
    int mInt_classNext;//是否是老师身份的下级显示人员
    NSString *mStr_navName;//当前界面的nav名字
    int mInt_forwardFlag;//切换身份时，判断是普通，还是短信
    int mInt_forwardAll;//转发时，判断是否群发1,
    int mInt_where;//表示来自哪个功能的点击事件，0新建，1下发通知，2短信直通车，3转发
    NSMutableArray *mArr_notice;//下发通知时，数据显示,全部下发单位和班级
    NSMutableArray *mArr_nowNotice;//当前显示的通知数组
    UILabel *mLab_tishi;//提示输入
    NSMutableArray *mArr_SMS;//短信直通车时，数据显示
    NSString *mStr_forwardContent;//如果是转发，传值转发的内容
    NSString *mStr_forwardTableID;//如果是转发，传值转发的ID
    CommMsgRevicerUnitListModel *mModel_unitList;//
    myUnit *mModel_myUnit;//当前显示的model
    UILabel *mLab_currentUnit;//当前显示的单位
    UIButton *mBtn_accessory;//添加附件按钮
    UIButton *mBtn_photo;//添加相册或拍照
    UIView *mView_accessory;//盛放需要发送的附件显示
    NSMutableArray *mArr_accessory;//附件列表
    UIView *mView_photo;//盛放需要发送的附件显示,相册或拍照
    NSMutableArray *mArr_photo;//附件列表,相册或拍照
}


@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,assign) int mInt_flag;//判断是普通获取，还是短信直通车获取
@property (nonatomic,assign) int mInt_all;//是否群发，1是，2不是
@property (nonatomic,strong) IBOutlet UIScrollView *mScrollV_all;//放所有控件
@property (nonatomic,strong) IBOutlet UIView *mView_unit;//当前单位总显示
@property (nonatomic,strong) IBOutlet UILabel *mLab_1;//当前单位
@property (nonatomic,strong) IBOutlet UILabel *mLab_2;//上级单位
@property (nonatomic,strong) IBOutlet UILabel *mLab_3;//下级单位
@property (nonatomic,strong) IBOutlet UILabel *mLab_5;//老师身份时，执教班级
@property (nonatomic,strong) IBOutlet UITextView *mTextV_enter;//输入框
@property (nonatomic,strong) IBOutlet UIButton *mBtn_sendMsg;//是否发送短信
@property (nonatomic,strong) IBOutlet UILabel *mLab_4;//光显示用，当前接收人
@property (nonatomic,strong) IBOutlet UIButton *mBtn_all;//接收人全选
@property (nonatomic,strong) IBOutlet UIButton *mBtn_invertSelect;//接收人反选
@property (nonatomic,strong) IBOutlet UIButton *mBtn_send;//发表
@property (nonatomic,strong) IBOutlet UICollectionView *mCollectionV_list;//人员具体显示
@property (nonatomic,strong) IBOutlet UIView *mView_switch;//切换单位
@property (nonatomic,strong) IBOutlet UITableView *mTableV_default;//默认获取到的四个
@property (nonatomic,strong) IBOutlet UITableView *mTalbeV_sub;//单位的子类
@property (nonatomic,strong) CMRevicerModel *mModel_CMRevicer;
@property (nonatomic,assign) int mInt_right;//点击导航条右键时，判断隐藏还是显示切换界面
@property (nonatomic,assign) int mInt_defaultTV_index;//记录点击默认表格的索引
@property (nonatomic,strong) NSString *mStr_unit;//当前单位的名称
@property (nonatomic,assign) int mInt_select_send;//当全局全选1、反选2、发表时3，用于区分，
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property (nonatomic,assign) int mInt_sendMsg;//是否发送短信
@property (nonatomic,strong) IBOutlet UIScrollView *mScroll_btn3;//下级单位可以滑动
@property (nonatomic,strong) IBOutlet UIScrollView *mScroll_btn5;//执教班级可以滑动
@property (nonatomic,strong) myUnit *mModel_myUnit;//当前界面显示的人员model
@property (nonatomic,strong) UnitClassRevicerModel *mModel_class;//当身份切换为老师时，用此model显示人员
@property (nonatomic,assign) int mInt_classNext;//是否是老师身份的下级显示人员
@property (nonatomic,strong) NSString *mStr_navName;//当前界面的nav名字
@property (assign,nonatomic) int mInt_forwardFlag;//切换身份时，判断是普通，还是短信
@property (assign,nonatomic) int mInt_forwardAll;//转发时，判断是否群发
@property (nonatomic,assign) int mInt_where;//表示来自哪个功能的点击事件
@property (nonatomic,strong) NSMutableArray *mArr_notice;//下发通知时，数据显示
@property (nonatomic,strong) NSMutableArray *mArr_nowNotice;//当前显示的通知数组
@property (nonatomic,strong) IBOutlet UILabel *mLab_tishi;//提示输入
@property (nonatomic,strong) NSMutableArray *mArr_SMS;//短信直通车时，数据显示
@property (nonatomic,strong) NSString *mStr_forwardContent;//如果是转发，传值转发的内容
@property (nonatomic,strong) NSString *mStr_forwardTableID;//如果是转发，传值转发的ID
@property (nonatomic,strong) CommMsgRevicerUnitListModel *mModel_unitList;//
@property (nonatomic,strong) IBOutlet UILabel *mLab_currentUnit;//当前显示的单位
@property (nonatomic,strong) IBOutlet UIButton *mBtn_accessory;//添加附件按钮
@property (nonatomic,strong) IBOutlet UIView *mView_accessory;//盛放需要发送的附件显示
@property (nonatomic,strong) NSMutableArray *mArr_accessory;//附件列表
@property (nonatomic,strong) IBOutlet UIButton *mBtn_photo;//添加相册或拍照
@property (nonatomic,strong) IBOutlet UIView *mView_photo;//盛放需要发送的附件显示,相册或拍照
@property (nonatomic,strong) NSMutableArray *mArr_photo;//附件列表,相册或拍照
//@property(nonatomic,strong)InsideWorkView *insideWorkV;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)NewWorkTopView *topView;
@property(nonatomic,assign)BOOL showTopView;

//附件按钮点击事件
-(IBAction)mBtn_accessory:(UIButton *)btn;
-(IBAction)mBtn_photo:(UIButton *)btn;

@end

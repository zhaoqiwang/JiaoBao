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

@interface ForwardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,Forward_sectionDelegate,UIGestureRecognizerDelegate,MBProgressHUDDelegate,UITextViewDelegate,NewWorkTopViewProtocol>

@property (nonatomic,assign) int mInt_flag;//判断是普通获取，还是短信直通车获取
@property (nonatomic,assign) int mInt_all;//是否群发，1是，2不是
@property (nonatomic,strong) IBOutlet UIScrollView *mScrollV_all;//放所有控件
@property (nonatomic,strong) IBOutlet UILabel *mLab_4;//光显示用，当前接收人
@property (nonatomic,strong) IBOutlet UIButton *mBtn_all;//接收人全选
@property (nonatomic,strong) IBOutlet UIButton *mBtn_invertSelect;//接收人反选
@property (nonatomic,strong) IBOutlet UICollectionView *mCollectionV_list;//人员具体显示
@property (nonatomic,strong) NSString *mStr_unit;//当前单位的名称
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property (nonatomic,assign) int mInt_sendMsg;//是否发送短信
@property (nonatomic,strong) myUnit *mModel_myUnit;//当前界面显示的人员model
@property (nonatomic,strong) UnitClassRevicerModel *mModel_class;//当身份切换为老师时，用此model显示人员
@property (assign,nonatomic) int mInt_forwardFlag;//切换身份时，判断是普通，还是短信
@property (assign,nonatomic) int mInt_forwardAll;//转发时，判断是否群发
@property (nonatomic,strong) CommMsgRevicerUnitListModel *mModel_unitList;//
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)NewWorkTopView *topView;
@property(nonatomic,assign)BOOL showTopView;
@property(nonatomic,assign)NSUInteger allSelected;


@end

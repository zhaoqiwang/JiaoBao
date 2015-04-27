//
//  ForwardViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-11-4.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "ForwardViewController.h"
#import "Reachability.h"
#import "CollectionFootView.h"

#define Margin 0//边距
#define BtnColor [UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1]//按钮背景色

@interface ForwardViewController ()

@end

NSString *kDetailedViewControllerID = @"Forward_section";    // view controller storyboard id
NSString *kCellID = @"Forward_cell";                          // UICollectionViewCell storyboard id

@implementation ForwardViewController
@synthesize mNav_navgationBar,mInt_all,mInt_flag,mBtn_all,mBtn_invertSelect,mBtn_send,mBtn_sendMsg,mCollectionV_list,mLab_1,mLab_2,mLab_3,mLab_4,mScrollV_all,mTableV_default,mTalbeV_sub,mTextV_enter,mView_switch,mView_unit,mModel_CMRevicer,mInt_right,mInt_defaultTV_index,mStr_unit,mInt_select_send,mProgressV,mInt_sendMsg,mScroll_btn3,mModel_myUnit,mModel_class,mInt_classNext,mStr_navName,mInt_forwardAll,mInt_forwardFlag,mInt_where,mArr_notice,mLab_tishi,mArr_SMS,mStr_forwardContent,mStr_forwardTableID,mModel_unitList,mArr_nowNotice,mLab_5,mScroll_btn5,mLab_currentUnit,mBtn_accessory,mView_accessory,mArr_accessory,mArr_photo,mBtn_photo,mView_photo;


-(void)viewDidDisappear:(BOOL)animated{
    //界面消失时，移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.mProgressV hide:YES];
}
-(void)refreshWorkView:(id)sender
{
//    self.topView.frame = self.topView.mView_top.frame;
//    NSLog(@"y = %f",self.topView.frame.origin.y);
    [self setFrame];
}
-(void)viewWillAppear:(BOOL)animated{
//    self.topView.frame = self.insideWorkV.mView_top.frame;
//    NSLog(@"y = %f",self.topView.frame.origin.y);
    [self setFrame];

    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshWorkView" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshWorkView:) name:@"refreshWorkView" object:nil];
    //向转发界面传递得到的人员单位列表
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CMRevicer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CMRevicer:) name:@"CMRevicer" object:nil];
    //发表消息成功推送
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"creatCommMsg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatCommMsg:) name:@"creatCommMsg" object:nil];
    //通知界面更新，获取事务信息接收单位列表
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CommMsgRevicerUnitList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CommMsgRevicerUnitList:) name:@"CommMsgRevicerUnitList" object:nil];
    //获取到每个单位中的人员
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetUnitRevicer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetUnitRevicer:) name:@"GetUnitRevicer" object:nil];
    //获取到下发通知的权限
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetMsgAllReviceUnitList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetMsgAllReviceUnitList:) name:@"GetMsgAllReviceUnitList" object:nil];
    //获取到下发通知的群发下属单位
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetMsgAllRevicer_toSubUnit" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetMsgAllRevicer_toSubUnit:) name:@"GetMsgAllRevicer_toSubUnit" object:nil];
    //获取到下发通知的下属班级
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetMsgAllRevicer_toSchoolGe" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetMsgAllRevicer_toSchoolGe:) name:@"GetMsgAllRevicer_toSchoolGe" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

  
    // Do any additional setup after loading the view from its nib.
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
//    //添加导航条
//    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_navName];
//    self.mNav_navgationBar.delegate = self;
//    [self.mNav_navgationBar setGoBack];
//    [self.mNav_navgationBar setRightBtn:[UIImage imageNamed:@"forward_rightNav"]];
//    [self.view addSubview:self.mNav_navgationBar];
    
    
    if ([dm getInstance].identity.count>0) {
        Identity_model *idenModel = [[dm getInstance].identity objectAtIndex:0];
        self.mInt_defaultTV_index = [idenModel.RoleIdentity intValue]-1;
    }
    
    self.mModel_myUnit = [[myUnit alloc] init];
    
    self.mProgressV = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.mProgressV];
    self.mProgressV.delegate = self;
    
    
    self.mInt_right = 2;
    self.mArr_notice = [[NSMutableArray alloc] init];
    self.mArr_SMS = [[NSMutableArray alloc] init];
    self.mArr_nowNotice = [NSMutableArray array];
    self.mArr_accessory = [NSMutableArray array];
    self.mArr_photo = [NSMutableArray array];
    
    self.mModel_CMRevicer = [[CMRevicerModel alloc] init];
    //大scrollview的坐标
    self.mScrollV_all.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar+20, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+10);
    //放单位信息的
    if (self.mInt_where == 0) {//发送短信
        self.mView_unit.frame =CGRectMake(Margin, Margin, [dm getInstance].width-2*Margin, 150);
    }else if(self.mInt_where == 1){//下发通知
        self.mLab_3.hidden = YES;
        self.mScroll_btn3.hidden = YES;
        self.mView_unit.frame =CGRectMake(Margin, Margin, [dm getInstance].width-2*Margin, 85);
    }else if (self.mInt_where == 2){
        self.mView_unit.hidden = YES;
        self.mView_unit.frame =CGRectMake(Margin, 0, [dm getInstance].width-2*Margin, 0);
    }
    
    //添加边框
    self.mView_unit.layer.borderWidth = 1;
    self.mView_unit.layer.borderColor = [[UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1] CGColor];
    //将图层的边框设置为圆脚
    self.mView_unit.layer.cornerRadius = 8;
    self.mView_unit.layer.masksToBounds = YES;
    self.mLab_1.frame =CGRectMake(Margin, Margin, self.mLab_1.frame.size.width, 26);
    self.mLab_2.frame =CGRectMake(Margin, self.mLab_1.frame.origin.y+self.mLab_1.frame.size.height+Margin, self.mLab_2.frame.size.width, 26);
    self.mLab_3.frame =CGRectMake(Margin, self.mLab_2.frame.origin.y+self.mLab_2.frame.size.height+Margin, self.mLab_3.frame.size.width, 26);
    //放下级单位的scrollview
    self.mScroll_btn3.frame = CGRectMake(self.mLab_3.frame.origin.x+self.mLab_3.frame.size.width, self.mLab_3.frame.origin.y, self.mView_unit.frame.size.width-20-self.mLab_3.frame.size.width, self.mLab_3.frame.size.height);
    self.mScroll_btn3.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -2, 0);
    //放下级单位的scrollview
    self.mLab_5.frame =CGRectMake(Margin, self.mLab_3.frame.origin.y+self.mLab_3.frame.size.height+Margin, self.mLab_5.frame.size.width, 26);
    self.mScroll_btn5.frame = CGRectMake(self.mLab_5.frame.origin.x+self.mLab_5.frame.size.width, self.mLab_5.frame.origin.y, self.mView_unit.frame.size.width-20-self.mLab_5.frame.size.width, self.mLab_5.frame.size.height);
    //输入框
    self.mTextV_enter.frame = CGRectMake(Margin, self.mView_unit.frame.origin.y+self.mView_unit.frame.size.height+Margin, self.mView_unit.frame.size.width, 100);
    //添加边框
    self.mTextV_enter.layer.borderWidth = 1;
    self.mTextV_enter.layer.borderColor = [[UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1] CGColor];
    //将图层的边框设置为圆脚
    self.mTextV_enter.layer.cornerRadius = 8;
    self.mTextV_enter.layer.masksToBounds = YES;
    self.mTextV_enter.text = self.mStr_forwardContent;
    //如果内容中有值，隐藏提示
    if (self.mStr_forwardContent.length>0) {
        [self.mLab_tishi setHidden:YES];
    }
    //提示输入
    self.mLab_tishi.frame = CGRectMake(self.mTextV_enter.frame.origin.x+10, self.mTextV_enter.frame.origin.y+5, self.mLab_tishi.frame.size.width, self.mLab_tishi.frame.size.height);
    
    //附件按钮
    self.mBtn_accessory.frame = CGRectMake(Margin, self.mTextV_enter.frame.origin.y+self.mTextV_enter.frame.size.height+10, 40, 30);
    [self.mBtn_accessory setImage:[UIImage imageNamed:@"work_accessory"] forState:UIControlStateNormal];
    //附件框
    self.mView_accessory.frame  = CGRectMake(Margin+40, self.mBtn_accessory.frame.origin.y, [dm getInstance].width-self.mBtn_accessory.frame.size.width-20, self.mView_accessory.frame.size.height);
    //添加边框
    self.mView_accessory.layer.borderWidth = 1;
    self.mView_accessory.layer.borderColor = [[UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1] CGColor];
    //将图层的边框设置为圆脚
    self.mView_accessory.layer.cornerRadius = 8;
    self.mView_accessory.layer.masksToBounds = YES;
    
    //附件按钮，照片
    self.mBtn_photo.frame = CGRectMake(Margin, self.mView_accessory.frame.origin.y+self.mView_accessory.frame.size.height+10, 40, 30);
    [self.mBtn_photo setImage:[UIImage imageNamed:@"work_accessoryPhoto"] forState:UIControlStateNormal];
    //附件框，照片
    self.mView_photo.frame  = CGRectMake(Margin+40, self.mBtn_photo.frame.origin.y, [dm getInstance].width-self.mBtn_photo.frame.size.width-20, self.mView_photo.frame.size.height);
    //添加边框，照片
    self.mView_photo.layer.borderWidth = 1;
    self.mView_photo.layer.borderColor = [[UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1] CGColor];
    //将图层的边框设置为圆脚，照片
    self.mView_photo.layer.cornerRadius = 8;
    self.mView_photo.layer.masksToBounds = YES;
    //发送短信按钮
    self.mBtn_sendMsg.frame =CGRectMake([dm getInstance].width-Margin-80, self.mView_photo.frame.origin.y+self.mView_photo.frame.size.height, 80, 39);
    if (self.mInt_sendMsg == 0) {
        [self.mBtn_sendMsg setImage:[UIImage imageNamed:@"forward_sendMsg2"] forState:UIControlStateNormal];
    }else if (self.mInt_sendMsg == 1){
        [self.mBtn_sendMsg setImage:[UIImage imageNamed:@"forward_sendMsg1"] forState:UIControlStateNormal];
    }
    [self.mBtn_sendMsg addTarget:self action:@selector(sendMsgBtn:) forControlEvents:UIControlEventTouchUpInside];
    //当前显示的单位名称
    self.mLab_currentUnit.frame = CGRectMake(Margin, self.mBtn_sendMsg.frame.origin.y, [dm getInstance].width-self.mBtn_sendMsg.frame.size.width-Margin*3, self.mBtn_sendMsg.frame.size.height);
    self.mLab_currentUnit.text = [dm getInstance].mStr_unit;
    
    //接收人，全选，反选，发表
    self.topView = [[NewWorkTopView alloc]init];
    self.topView.delegate = self;
    [self.mScrollV_all addSubview:self.topView];
    NSLog(@"topView = %@",self.topView);
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, self.topView.frame.size.height+self.topView.frame.origin.y+10, [dm getInstance].width, 28)];
    self.headView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [self.mScrollV_all insertSubview:self.headView belowSubview:self.mLab_4];
    self.mLab_4.frame =CGRectMake(Margin, self.topView.frame.size.height+self.topView.frame.origin.y+10, self.mLab_4.frame.size.width, 29);
    self.mBtn_all.frame = CGRectMake([dm getInstance].width-100+15, self.mLab_4.frame.origin.y, 40, 29);
    //self.mBtn_all.backgroundColor = [UIColor lightGrayColor];
    self.mBtn_all.tag = 1;
    [self.mBtn_all addTarget:self action:@selector(clickSendBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.mBtn_invertSelect.frame = CGRectMake([dm getInstance].width-60+15, self.mLab_4.frame.origin.y, 40, 29);
    //self.mBtn_invertSelect.backgroundColor = [UIColor lightGrayColor];
    self.mBtn_invertSelect.tag = 2;
    [self.mBtn_invertSelect addTarget:self action:@selector(clickSendBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.mBtn_send.frame = CGRectMake([dm getInstance].width-Margin-81, self.mLab_4.frame.origin.y, 81, 29);
    self.mBtn_send.backgroundColor = [UIColor colorWithRed:17/255.0 green:107/255.0 blue:255/255.0 alpha:1];
    self.mBtn_send.tag = 3;
    [self.mBtn_send addTarget:self action:@selector(clickSendBtn:) forControlEvents:UIControlEventTouchUpInside];
    //切换单位界面
    self.mView_switch.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, 4*44);
    //添加边框
    self.mView_switch.layer.borderWidth = 1;
    self.mView_switch.layer.borderColor = [[UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1] CGColor];
    self.mTableV_default.frame =CGRectMake(0, 0, [dm getInstance].width/2, 4*44);
    //添加边框
    self.mTableV_default.layer.borderWidth = 1;
    self.mTableV_default.layer.borderColor = [[UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1] CGColor];
    self.mTableV_default.tag = 100;
    self.mTalbeV_sub.frame =CGRectMake([dm getInstance].width/2, 0, [dm getInstance].width/2, 4*44);
    //添加边框
    self.mTalbeV_sub.layer.borderWidth = 1;
    self.mTalbeV_sub.layer.borderColor = [[UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1] CGColor];
    self.mTalbeV_sub.tag = 101;
    
    //人员列表
    self.mCollectionV_list.frame = CGRectMake(Margin,self.mLab_4.frame.size.height+self.mLab_4.frame.origin.y, self.mView_unit.frame.size.width, 0);
    self.mCollectionV_list.backgroundColor = [UIColor whiteColor];
    self.mCollectionV_list.layer.borderWidth = 1;
    self.mCollectionV_list.layer.borderColor = [[UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1] CGColor];
    [self.mCollectionV_list registerClass:[Forward_cell class] forCellWithReuseIdentifier:kCellID];
    [self.mCollectionV_list registerClass:[Forward_section class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDetailedViewControllerID];
    
    [self.mCollectionV_list registerClass:[CollectionFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CollectionFootView"];
    
    //添加单击手势
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTap:)];
//    tap1.delegate = self;//设置代理，防止手势和按钮的点击事件冲突
//    [self.mScrollV_all addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTap:)];
    tap2.delegate = self;
    [self.topView addGestureRecognizer:tap2];
    
    [self sendRequest];
}

-(void)setFrame{
    //放单位信息的
    if (self.mInt_where == 0) {//发送短信
        if (self.mInt_defaultTV_index == 1) {
            self.mView_unit.frame =CGRectMake(Margin, Margin, [dm getInstance].width-2*Margin, 150);
        }else{
            self.mView_unit.frame =CGRectMake(Margin, Margin, [dm getInstance].width-2*Margin, 115);
        }
    }else if(self.mInt_where == 1){//下发通知
        self.mLab_3.hidden = YES;
        self.mScroll_btn3.hidden = YES;
        self.mView_unit.frame =CGRectMake(Margin, Margin, [dm getInstance].width-2*Margin, 85);
    }else if (self.mInt_where == 2){
        self.mView_unit.hidden = YES;
        self.mView_unit.frame =CGRectMake(Margin, 0, [dm getInstance].width-2*Margin, 0);
    }
    //输入框
    self.mTextV_enter.frame = CGRectMake(Margin, self.mView_unit.frame.origin.y+self.mView_unit.frame.size.height+Margin, self.mView_unit.frame.size.width, 100);
    //提示输入
    self.mLab_tishi.frame = CGRectMake(self.mTextV_enter.frame.origin.x+10, self.mTextV_enter.frame.origin.y+5, self.mLab_tishi.frame.size.width, self.mLab_tishi.frame.size.height);
    //提示输入
    self.mLab_tishi.frame = CGRectMake(self.mTextV_enter.frame.origin.x+10, self.mTextV_enter.frame.origin.y+5, self.mLab_tishi.frame.size.width, self.mLab_tishi.frame.size.height);
    //附件按钮
    self.mBtn_accessory.frame = CGRectMake(Margin, self.mTextV_enter.frame.origin.y+self.mTextV_enter.frame.size.height+10, 40, 30);
    //附件框
    self.mView_accessory.frame  = CGRectMake(Margin+40, self.mBtn_accessory.frame.origin.y, [dm getInstance].width-self.mBtn_accessory.frame.size.width-20, self.mView_accessory.frame.size.height);
    //附件按钮，照片
    self.mBtn_photo.frame = CGRectMake(Margin, self.mView_accessory.frame.origin.y+self.mView_accessory.frame.size.height+10, 40, 30);
    //附件框，照片
    self.mView_photo.frame  = CGRectMake(Margin+40, self.mBtn_photo.frame.origin.y, [dm getInstance].width-self.mBtn_photo.frame.size.width-20, self.mView_photo.frame.size.height);
    //发送短信按钮
    self.mBtn_sendMsg.frame =CGRectMake([dm getInstance].width-Margin-80, self.mView_photo.frame.origin.y+self.mView_photo.frame.size.height, 80, 39);
    //当前显示的单位名称
    self.mLab_currentUnit.frame = CGRectMake(Margin, self.mBtn_sendMsg.frame.origin.y, [dm getInstance].width-self.mBtn_sendMsg.frame.size.width-Margin*3, self.mBtn_sendMsg.frame.size.height);
    
    //接收人，全选，反选，发表
    self.headView.frame = CGRectMake(0, self.topView.frame.size.height+self.topView.frame.origin.y+20, [dm getInstance].width, 28);
    self.mLab_4.frame =CGRectMake(Margin, self.topView.frame.origin.y+self.topView.frame.size.height+20, self.mLab_4.frame.size.width, 29);
    self.imgV.frame = CGRectMake([dm getInstance].width-15-100+15, self.mLab_4.frame.origin.y+7, 14, 14);
    self.imgV.image = [UIImage imageNamed:@"10.png"];
    self.mBtn_all.frame = CGRectMake([dm getInstance].width-100+15, self.mLab_4.frame.origin.y, 40, 29);
    self.mBtn_invertSelect.frame = CGRectMake([dm getInstance].width-60+15, self.mLab_4.frame.origin.y, 40, 29);
    self.mBtn_send.frame = CGRectMake([dm getInstance].width-Margin-81, self.mLab_4.frame.origin.y, 81, 29);
    //切换单位界面
    self.mView_switch.frame = CGRectMake(0, 0, [dm getInstance].width, 4*44);
    //添加边框
    self.mTableV_default.frame =CGRectMake(0, 0, [dm getInstance].width/2, 4*44);
    //添加边框
    self.mTalbeV_sub.frame =CGRectMake([dm getInstance].width/2, 0, [dm getInstance].width/2, 4*44);
    //人员列表
    self.mCollectionV_list.frame = CGRectMake(Margin, mLab_4.frame.origin.y+mLab_4.frame.size.height, self.mCollectionV_list.frame.size.width, self.mCollectionV_list.collectionViewLayout.collectionViewContentSize.height);
}

//附件按钮点击事件
-(IBAction)mBtn_accessory:(UIButton *)btn{
    AccessoryViewController *access = [[AccessoryViewController alloc] init];
    access.delegate = self;
    [utils pushViewController:access animated:YES];
}

-(IBAction)mBtn_photo:(UIButton *)btn{
    UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:@"添加附件" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册添加",@"拍照添加",nil];
    action.tag = 1;
    [action showInView:self.view.superview];
}
//UIActionSheet回调方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1) {//单位
        if (buttonIndex == 0){//相册添加
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
            
            elcPicker.maximumImagesCount = 100; //设置的图像的最大数目来选择至100
            elcPicker.returnsOriginalImage = YES; //只返回fullScreenImage，而不是fullResolutionImage
            elcPicker.returnsImage = YES; //返回的UIImage如果YES。如果NO，只返回资产位置信息
            elcPicker.onOrder = YES; //对于多个图像选择，显示和选择图像的退货订单
//            elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //支持图片和电影类型
            elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //支持图片和电影类型
            elcPicker.imagePickerDelegate = self;
            [self presentViewController:elcPicker animated:YES completion:nil];
        }else if (buttonIndex == 1){//拍照添加
            [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
        }
    }
}
//附件选择界面的回调
-(void)selectFile:(NSMutableArray *)array{
    [self.mArr_accessory addObjectsFromArray:array];
    //添加显示附件
    [self addAccessory];
}

#pragma mark ELCImagePickerControllerDelegate Methods
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (info.count>0) {
        self.mProgressV.labelText = @"处理中...";
        self.mProgressV.mode = MBProgressHUDModeIndeterminate;
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
        D("info.count-===%lu",(unsigned long)info.count);
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //文件名
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file"]];
    //判断文件夹是否存在
    if(![fileManager fileExistsAtPath:tempPath]) {//如果不存在
        [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                NSData *imageData = UIImageJPEGRepresentation(image,1.0);
                
                NSString *imgPath=[tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",timeSp]];
                [self.mArr_photo addObject:[NSString stringWithFormat:@"%@.png",timeSp]];
                D("图片路径是：%@",imgPath);
                BOOL yesNo=[[NSFileManager defaultManager] fileExistsAtPath:imgPath];
                if (!yesNo) {//不存在，则直接写入后通知界面刷新
                    BOOL result = [imageData writeToFile:imgPath atomically:YES];
                    for (;;) {
                        if (result) {
                            
                            break;
                        }
                    }
                }else {//存在
                    BOOL blDele= [fileManager removeItemAtPath:imgPath error:nil];//先删除
                    if (blDele) {//删除成功后，写入，通知界面
                        BOOL result = [imageData writeToFile:imgPath atomically:YES];
                        for (;;) {
                            if (result) {
                                
                                break;
                            }
                        }
                    }
                }
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        }
        else {
            NSLog(@"Uknown asset type");
        }
        timeSp = [NSString stringWithFormat:@"%d",[timeSp intValue] +1];
    }
    //添加显示附件
    [self addAccessoryPhoto];
    [self.mProgressV hide:YES];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType{
    NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediatypes count]>0) {
        NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.mediaTypes=mediatypes;
        picker.delegate=self;
//        picker.allowsEditing=YES;
        picker.sourceType=sourceType;
        NSString *requiredmediatype=(NSString *)kUTTypeImage;
        NSArray *arrmediatypes=[NSArray arrayWithObject:requiredmediatype];
        [picker setMediaTypes:arrmediatypes];
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误信息!" message:@"当前设备不支持拍摄功能" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma 拍照模块
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *lastChosenMediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if([lastChosenMediaType isEqual:(NSString *) kUTTypeImage])
    {
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        UIImage *chosenImage=[info objectForKey:UIImagePickerControllerOriginalImage];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file"]];
        //判断文件夹是否存在
        if(![fileManager fileExistsAtPath:tempPath]) {//如果不存在
            [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSData *imageData = UIImageJPEGRepresentation(chosenImage,1.0);
        
        NSString *imgPath=[tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",timeSp]];
        D("图片路径是：%@",imgPath);
        BOOL yesNo=[[NSFileManager defaultManager] fileExistsAtPath:imgPath];
        if (!yesNo) {//不存在，则直接写入后通知界面刷新
            BOOL result = [imageData writeToFile:imgPath atomically:YES];
            for (;;) {
                if (result) {
                    
                    break;
                }
            }
        }else {//存在
            BOOL blDele= [fileManager removeItemAtPath:imgPath error:nil];//先删除
            if (blDele) {//删除成功后，写入，通知界面
                BOOL result = [imageData writeToFile:imgPath atomically:YES];
                for (;;) {
                    if (result) {
                        
                        break;
                    }
                }
            }
        }
        [self.mArr_photo addObject:[NSString stringWithFormat:@"%@.png",timeSp]];
    }
    
    if([lastChosenMediaType isEqual:(NSString *) kUTTypeMovie])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示信息!" message:@"系统只支持图片格式" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        
    }
    //添加显示附件
    [self addAccessoryPhoto];
}
//刷新显示附件
-(void)addAccessory{
    //清掉显示的附件
    for (UIButton *btn in self.mView_accessory.subviews) {
        [btn removeFromSuperview];
    }
    //将选中的文件，在界面中显示
    CGRect rect0 = CGRectMake(0, 0, 25, 25);
    for (int i =0; i<self.mArr_accessory.count; i++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeContactAdd];
        but.frame = CGRectMake(rect0.origin.x+2, rect0.origin.y+2, 25, 25);
        but.tag = i;
        [but setImage:[UIImage imageNamed:@"work_deleteAccessory"] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(deleteAccessory:) forControlEvents:UIControlEventTouchUpInside];
        [self.mView_accessory addSubview:but];
        UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tempBtn.frame = CGRectMake(30, but.frame.origin.y, self.mView_accessory.frame.size.width-35, 25);
        [tempBtn setTitle:[self.mArr_accessory objectAtIndex:i] forState:UIControlStateNormal];
        tempBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        tempBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft ;;
        [tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tempBtn.tag = i;
        [tempBtn addTarget:self action:@selector(clickAccessory:) forControlEvents:UIControlEventTouchUpInside];
        [self.mView_accessory addSubview:tempBtn];
        rect0 = CGRectMake(0, but.frame.origin.y+25, 0, 25);
    }
    if (self.mArr_accessory.count == 0) {
        rect0 = CGRectMake(0, 25, 25, 25);
    }
    self.mView_accessory.frame = CGRectMake(self.mView_accessory.frame.origin.x, self.mView_accessory.frame.origin.y, self.mView_accessory.frame.size.width, rect0.origin.y);
    [self setFrame];
}
//点击附件
-(void)clickAccessory:(UIButton *)btn{
    NSString *name = [self.mArr_accessory objectAtIndex:btn.tag];
    if([[name pathExtension] isEqualToString:@"png"]) {  //取得后缀名这.png的文件名
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file"]];
        NSString *imgPath=[tempPath stringByAppendingPathComponent:name];
        UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, self.view.frame.size.height)];
        D("tempviewshgkeh-====%@",NSStringFromCGRect(self.view.frame));
        tempView.backgroundColor = [UIColor blackColor];
        tempView.tag = 998;
        UITapGestureRecognizer *tempTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTempViewRemove:)];
        [tempView addGestureRecognizer:tempTap];
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height-320)/2, 320, 320)];
        [imgV setImage:img];
        [tempView addSubview:imgV];
        [self.view addSubview:tempView];
    }
}
-(void)clickAccessoryPhoto:(UIButton *)btn{
    NSString *name = [self.mArr_photo objectAtIndex:btn.tag];
    if([[name pathExtension] isEqualToString:@"png"]) {  //取得后缀名这.png的文件名
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file"]];
        NSString *imgPath=[tempPath stringByAppendingPathComponent:name];
        UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, self.view.frame.size.height)];
        D("tempviewshgkeh-====%@",NSStringFromCGRect(self.view.frame));
        tempView.backgroundColor = [UIColor blackColor];
        tempView.tag = 998;
        UITapGestureRecognizer *tempTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTempViewRemove:)];
        [tempView addGestureRecognizer:tempTap];
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height-320)/2, 320, 320)];
        [imgV setImage:img];
        [tempView addSubview:imgV];
        [self.view addSubview:tempView];
    }
}

//放大头像后，点击移除
-(void)clickTempViewRemove:(UITapGestureRecognizer *)tap{
    for (UIView *view in self.view.subviews) {
        if (view.tag == 998) {
            [view removeFromSuperview];
        }
    }
}
//刷新显示附件
-(void)addAccessoryPhoto{
    //清掉显示的附件
    for (UIButton *btn in self.mView_photo.subviews) {
        [btn removeFromSuperview];
    }
    //将选中的文件，在界面中显示
    CGRect rect0 = CGRectMake(0, 0, 25, 25);
    for (int i =0; i<self.mArr_photo.count; i++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeContactAdd];
        but.frame = CGRectMake(rect0.origin.x+2, rect0.origin.y+2, 25, 25);
        but.tag = i;
        [but setImage:[UIImage imageNamed:@"work_deleteAccessory"] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(deleteAccessoryPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [self.mView_photo addSubview:but];
        UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tempBtn.frame = CGRectMake(30, but.frame.origin.y, self.mView_accessory.frame.size.width-35, 25);
        [tempBtn setTitle:[self.mArr_photo objectAtIndex:i] forState:UIControlStateNormal];
        tempBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        tempBtn.tag = i;
        tempBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tempBtn addTarget:self action:@selector(clickAccessoryPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [self.mView_photo addSubview:tempBtn];
        rect0 = CGRectMake(0, but.frame.origin.y+25, 0, 25);
    }
    if (self.mArr_photo.count == 0) {
        rect0 = CGRectMake(0, 25, 25, 25);
    }
    self.mView_photo.frame = CGRectMake(self.mView_photo.frame.origin.x, self.mView_photo.frame.origin.y, self.mView_photo.frame.size.width, rect0.origin.y);
    [self setFrame];
}

//点击删除附件
-(void)deleteAccessoryPhoto:(UIButton *)btn{
    //从数组中删除
    [self.mArr_photo removeObjectAtIndex:btn.tag];
    //刷新界面
    [self addAccessoryPhoto];
}

//点击删除附件
-(void)deleteAccessory:(UIButton *)btn{
    //从数组中删除
    [self.mArr_accessory removeObjectAtIndex:btn.tag];
    //刷新界面
    [self addAccessory];
}

-(void)sendRequest{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    //发送获取接收人员列表请求
    [LoginSendHttp getInstance].mInt_forwardFlag = self.mInt_forwardFlag;
    [LoginSendHttp getInstance].mInt_forwardAll = self.mInt_forwardAll;
    [[LoginSendHttp getInstance] changeCurUnit];
    
    self.mProgressV.labelText = @"加载中...";
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
}

//检查当前网络是否可用
-(BOOL)checkNetWork{
    if([Reachability isEnableNetwork]==NO){
        self.mProgressV.mode = MBProgressHUDModeCustomView;
        self.mProgressV.labelText = NETWORKENABLE;
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
        return YES;
    }else{
        return NO;
    }
}

-(void)pressTap:(UITapGestureRecognizer *)tap{
    D("uuuu");
    [self.topView.mTextV_input resignFirstResponder];
    
}

- (void)Loading {
    sleep(TIMEOUT);
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    self.mProgressV.labelText = @"加载超时";
//    self.mProgressV.userInteractionEnabled = NO;
    sleep(2);
}

//点击发送短信按钮
-(void)sendMsgBtn:(UIButton *)btn{
    if (self.mInt_sendMsg == 0) {
        self.mInt_sendMsg = 1;
        [self.mBtn_sendMsg setImage:[UIImage imageNamed:@"forward_sendMsg1"] forState:UIControlStateNormal];
    } else {
        self.mInt_sendMsg = 0;
        [self.mBtn_sendMsg setImage:[UIImage imageNamed:@"forward_sendMsg2"] forState:UIControlStateNormal];
    }
}

//加载新建事务的勾选人员
-(NSMutableArray *)addMyUnitMember:(myUnit *)tempUnit{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<tempUnit.list.count; i++) {
        UserListModel *model2 = [tempUnit.list objectAtIndex:i];
        NSMutableArray *arr9 = model2.groupselit_selit;
        for (int n=0; n<arr9.count; n++) {
            groupselit_selitModel *model3 = [arr9 objectAtIndex:n];
            if (model3.mInt_select == 1) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:model3.flag forKey:@"flag"];
                [dic setValue:model3.selit forKey:@"selit"];
                [array addObject:dic];
            }
        }
    }
    return array;
}

//取消勾选人员
-(void)delMyUnitMember:(myUnit *)tempUnit{
    for (int i=0; i<tempUnit.list.count; i++) {
        UserListModel *model2 = [tempUnit.list objectAtIndex:i];
        NSMutableArray *arr9 = model2.groupselit_selit;
        for (int n=0; n<arr9.count; n++) {
            groupselit_selitModel *model3 = [arr9 objectAtIndex:n];
            if (model3.mInt_select == 1) {
                model3.mInt_select = 0;
            }
        }
    }
}

//点击发表按钮
-(void)clickSendBtn:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if (btn.tag == 1) {
        self.mInt_select_send = 1;
    }else if (btn.tag == 2){
        self.mInt_select_send = 2;
    }else if (btn.tag == 3){
        if (self.mTextV_enter.text.length == 0) {
            self.mProgressV.mode = MBProgressHUDModeCustomView;
            self.mProgressV.labelText = @"请输入内容";
            [self.mProgressV show:YES];
            [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
            return;
        }
        self.mInt_select_send = 3;
    }
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *array1 = [NSMutableArray array];
    NSMutableArray *array2 = [NSMutableArray array];
    
    if (self.mInt_where == 0) {//发送短信
        if (self.mInt_select_send == 3) {
            //当前单位
            myUnit *tempUnit = self.mModel_unitList.myUnit;
            [array addObjectsFromArray:[self addMyUnitMember:tempUnit]];
            //上级单位
            for (int i=0; i<self.mModel_unitList.UnitParents.count; i++) {
                myUnit *tempUnit = [self.mModel_unitList.UnitParents objectAtIndex:i];
                [array addObjectsFromArray:[self addMyUnitMember:tempUnit]];
            }
            //下级单位
            for (int i=0; i<self.mModel_unitList.subUnits.count; i++) {
                myUnit *tempUnit = [self.mModel_unitList.subUnits objectAtIndex:i];
                [array addObjectsFromArray:[self addMyUnitMember:tempUnit]];
            }
            for (int i=0; i<self.mModel_unitList.UnitClass.count; i++) {
                myUnit *tempUnit = [self.mModel_unitList.UnitClass objectAtIndex:i];
                [array addObjectsFromArray:[self addMyUnitMember:tempUnit]];
            }
        }else{
            //检索当前需要发送的ID
            for (int m=0; m<self.mModel_myUnit.list.count; m++) {
                UserListModel *model2 = [self.mModel_myUnit.list objectAtIndex:m];
                NSMutableArray *arr9 = model2.groupselit_selit;
                for (int n=0; n<arr9.count; n++) {
                    groupselit_selitModel *model3 = [arr9 objectAtIndex:n];
                    if (self.mInt_select_send == 1) {
                        model3.mInt_select = 1;
                    }else if (self.mInt_select_send == 2){
                        if (model3.mInt_select == 0) {
                            model3.mInt_select = 1;
                        } else {
                            model3.mInt_select = 0;
                        }
                    }
                }
            }
        }
    }else if (self.mInt_where == 1){//下发通知
        //循环遍历
        for (int i=0; i<self.mArr_notice.count; i++) {
            CommMsgUnitNotice *noticeModel = [self.mArr_notice objectAtIndex:i];
            for (int a=0; a<noticeModel.selitadmintomem.count; a++) {
                UserListModel *model = [noticeModel.selitadmintomem objectAtIndex:a];
                for (int m=0; m<model.groupselit_selit.count; m++) {
                    groupselit_selitModel *tempModel = [model.groupselit_selit objectAtIndex:m];
                    if (tempModel.selit.length>0) {
                        if (self.mInt_select_send == 1) {
                            tempModel.mInt_select = 1;
                        }else if (self.mInt_select_send == 2){
                            if (tempModel.mInt_select == 0) {
                                tempModel.mInt_select = 1;
                            } else {
                                tempModel.mInt_select = 0;
                            }
                        }else if (self.mInt_select_send == 3){
                            if (tempModel.mInt_select == 1) {
                                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                                [dic setValue:tempModel.flag forKey:@"flag"];
                                [dic setValue:tempModel.selit forKey:@"selit"];
                                [array addObject:dic];
                            }
                        }
                    }
                }
            }
        }
    }else if (self.mInt_where == 2){//短信直通车
        for (int i=0; i<self.mArr_SMS.count; i++) {
            SMSTreeArrayModel *model = [self.mArr_SMS objectAtIndex:i];
            for (int m=0; m<model.smsTree.count; m++) {
                SMSTreeUnitModel *tempModel = [model.smsTree objectAtIndex:m];
                if (self.mInt_select_send == 1) {
                    tempModel.mInt_select = 1;
                }else if (self.mInt_select_send == 2){
                    if (tempModel.mInt_select == 0) {
                        tempModel.mInt_select = 1;
                    } else {
                        tempModel.mInt_select = 0;
                    }
                }else if (self.mInt_select_send == 3){
                    if (i == 0) {
                        if (tempModel.mInt_select == 1) {
                            [array addObject:tempModel.id0];

                        }
                    }else if (i == 1){
                        if (tempModel.mInt_select == 1) {
                            [array1 addObject:tempModel.id0];

                        }
                    }else if (i == 2){
                        if (tempModel.mInt_select == 1) {
                            [array2 addObject:tempModel.id0];
                        }
                    }
                }
            }
        }
    }
    
    if (self.mInt_select_send == 1||self.mInt_select_send == 2) {
        [self.mCollectionV_list reloadData];
    }else if (self.mInt_select_send == 3){
        if (array.count==0) {
            self.mProgressV.mode = MBProgressHUDModeCustomView;
            self.mProgressV.labelText = @"请选择人员";
//            self.mProgressV.userInteractionEnabled = NO;
            [self.mProgressV show:YES];
            [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
            return;
        }
        //发表
        if (self.mInt_where == 0) {
            NSMutableArray *array0 = [NSMutableArray array];
            [array0 addObjectsFromArray:self.mArr_accessory];
            [array0 addObjectsFromArray:self.mArr_photo];
            D("array.count-====%lu",(unsigned long)array0.count);
            [[LoginSendHttp getInstance] creatCommMsgWith:self.mTextV_enter.text SMSFlag:self.mInt_sendMsg unitid:self.mModel_unitList.myUnit.TabIDStr classCount:0 grsms:1 array:array forwardMsgID:self.mStr_forwardTableID access:array0];
        }else if (self.mInt_where == 1) {//发表下发通知
            [[LoginSendHttp getInstance] creatCommMsgWith:self.mTextV_enter.text SMSFlag:self.mInt_sendMsg unitid:self.mModel_unitList.myUnit.TabIDStr classCount:(int)array.count grsms:1 arrMem:array arrGen:array1 forwardMsgID:self.mStr_forwardTableID];
        }if (self.mInt_where == 2) {//发表短信直通车
            [[LoginSendHttp getInstance] creatCommMsgWith:self.mTextV_enter.text SMSFlag:self.mInt_sendMsg unitid:[dm getInstance].mStr_tableID classCount:0 grsms:2 arrMem:array arrGen:array1 arrStu:array2];
        }
        
        self.mProgressV.labelText = @"加载中...";
        self.mProgressV.mode = MBProgressHUDModeIndeterminate;
//        self.mProgressV.userInteractionEnabled = NO;
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];

    }
    [self.mCollectionV_list reloadData];}

//向转发界面传递得到的人员单位列表
-(void)CMRevicer:(NSNotification *)noti{
    [self.mProgressV hide:YES];
    self.mStr_unit = [dm getInstance].mStr_unit;
    self.mInt_classNext = 0;
    if (self.mInt_where == 0) {//发送消息
        self.mModel_CMRevicer = noti.object;
//        self.mModel_myUnit = self.mModel_CMRevicer.myUnitRevicer;
    }else if (self.mInt_where == 1){//下发通知
        self.mModel_CMRevicer = noti.object;
//        self.mModel_myUnit = self.mModel_CMRevicer.myUnitRevicer;
//        D("self.mModel_myUnit-===%@,%lu",self.mModel_myUnit.UnitName,(unsigned long)self.mModel_myUnit.UserList.count);
//        self.mArr_notice = [NSMutableArray arrayWithArray:self.mModel_CMRevicer.selitadmintomem];
    }else if (self.mInt_where == 2){//短信直通车
        [self.mArr_SMS removeAllObjects];
        self.mArr_SMS = [NSMutableArray arrayWithArray:noti.object];
    }
    //加载单位目录
    [self addUnit];
    //刷新
    [self CollectionReloadData];
}

//获取到下发通知的权限
-(void)GetMsgAllReviceUnitList:(NSNotification *)noti{
    NSMutableArray *array = noti.object;
    self.mArr_notice = [NSMutableArray arrayWithArray:array];
}

//获取到下发通知的群发下属单位
-(void)GetMsgAllRevicer_toSubUnit:(NSNotification *)noti{
    NSMutableArray *array = noti.object;
    CommMsgUnitNotice *model = [self.mArr_notice objectAtIndex:0];
    model.selitadmintomem = [NSMutableArray arrayWithArray:array];
    if ([model.msgAll intValue] == 1) {//有权限
        self.mArr_nowNotice = array;
        //刷新
        [self CollectionReloadData];
    }else{//没有权限
        self.mProgressV.mode = MBProgressHUDModeCustomView;
        self.mProgressV.labelText = @"没有权限";
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
    }
}

//获取到下发通知的下属家长
-(void)GetMsgAllRevicer_toSchoolGe:(NSNotification *)noti{
    NSMutableArray *array = noti.object;
    CommMsgUnitNotice *model = [self.mArr_notice objectAtIndex:1];
    model.selitadmintomem = [NSMutableArray arrayWithArray:array];
    if ([model.msgAll intValue] == 1) {//有权限
        self.mArr_nowNotice = array;
        //刷新
        [self CollectionReloadData];
    }else{//没有权限
        self.mProgressV.mode = MBProgressHUDModeCustomView;
        self.mProgressV.labelText = @"没有权限";
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
    }
}

//通知界面更新，获取事务信息接收单位列表
-(void)CommMsgRevicerUnitList:(NSNotification *)noti{
    [self.mProgressV hide:YES];
    if (self.mInt_where == 0) {//发送消息
        self.mModel_unitList = noti.object;
        //获取当前单位的人员数组
        if ([dm getInstance].uType ==3) {
            [[LoginSendHttp getInstance] login_GetUnitClassRevicer:self.mModel_unitList.myUnit.TabID Flag:self.mModel_unitList.myUnit.flag];
        }else{
            [[LoginSendHttp getInstance] login_GetUnitRevicer:self.mModel_unitList.myUnit.TabID Flag:self.mModel_unitList.myUnit.flag];
        }
    }else if (self.mInt_where == 1){//下发通知
        if (self.mStr_unit.length==0) {
            self.mModel_unitList = noti.object;
            self.mStr_unit = self.mModel_unitList.myUnit.UintName;
        }
//        D("self.mModel_myUnit-===%@,%lu",self.mModel_myUnit.UnitName,(unsigned long)self.mModel_myUnit.UserList.count);
//        self.mArr_notice = [NSMutableArray arrayWithArray:self.mModel_CMRevicer.selitadmintomem];
        //获取当前的群发权限
        [[LoginSendHttp getInstance] login_GetMsgAllReviceUnitList];
    }else if (self.mInt_where == 2){//短信直通车
//        [self.mArr_SMS removeAllObjects];
//        self.mArr_SMS = [NSMutableArray arrayWithArray:noti.object];
    }
    //加载单位目录
    [self addUnit];
    
}

//获取到每个单位中的人员
-(void)GetUnitRevicer:(NSNotification *)noti{
    [self.mProgressV hide:YES];
    NSDictionary *dic = noti.object;
    NSString *unitID = [dic objectForKey:@"unitID"];
    NSArray *array = [dic objectForKey:@"array"];
    //找到当前这个单位，塞入数组
    
    //当前单位
    if ([self.mModel_unitList.myUnit.TabID intValue] == [unitID intValue]) {
        self.mModel_unitList.myUnit.list = [NSMutableArray arrayWithArray:array];
        self.mModel_myUnit = self.mModel_unitList.myUnit;
    }
    //上级单位
    for (int i=0; i<self.mModel_unitList.UnitParents.count; i++) {
        myUnit *unit = [self.mModel_unitList.UnitParents objectAtIndex:i];
        if ([unit.TabID intValue] == [unitID intValue]) {
            unit.list = [NSMutableArray arrayWithArray:array];
            self.mModel_myUnit = unit;
        }
    }
    //下级单位
    for (int i=0; i<self.mModel_unitList.subUnits.count; i++) {
        myUnit *unit = [self.mModel_unitList.subUnits objectAtIndex:i];
        if ([unit.TabID intValue] == [unitID intValue]) {
            unit.list = [NSMutableArray arrayWithArray:array];
            self.mModel_myUnit = unit;
        }
    }
    //班级
    for (int i=0; i<self.mModel_unitList.UnitClass.count; i++) {
        myUnit *unit = [self.mModel_unitList.UnitClass objectAtIndex:i];
        if ([unit.TabID intValue] == [unitID intValue]) {
            unit.list = [NSMutableArray arrayWithArray:array];
            self.mModel_myUnit = unit;
        }
    }
    //刷新
    [self CollectionReloadData];
}

//发表消息成功
-(void)creatCommMsg:(NSNotification *)noti{
    NSString *str = noti.object;
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    self.mProgressV.labelText = str;
//    self.mProgressV.userInteractionEnabled = NO;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
    self.topView.mTextV_input.text = @"";
    [self.topView.mArr_accessory removeAllObjects];
    //[self.mArr_photo removeAllObjects];
    //刷新界面
    [self addAccessoryPhoto];
    //刷新界面
    [self addAccessory];
    //
    if (self.mInt_where == 0) {//发送短信
        if (self.mInt_select_send == 3) {
            //当前单位
            myUnit *tempUnit = self.mModel_unitList.myUnit;
            [self delMyUnitMember:tempUnit];
            //上级单位
            for (int i=0; i<self.mModel_unitList.UnitParents.count; i++) {
                myUnit *tempUnit = [self.mModel_unitList.UnitParents objectAtIndex:i];
                [self delMyUnitMember:tempUnit];
            }
            //下级单位
            for (int i=0; i<self.mModel_unitList.subUnits.count; i++) {
                myUnit *tempUnit = [self.mModel_unitList.subUnits objectAtIndex:i];
                [self delMyUnitMember:tempUnit];
            }
            for (int i=0; i<self.mModel_unitList.UnitClass.count; i++) {
                myUnit *tempUnit = [self.mModel_unitList.UnitClass objectAtIndex:i];
                [self delMyUnitMember:tempUnit];
            }
        }else{
            //检索当前需要发送的ID
            for (int m=0; m<self.mModel_myUnit.list.count; m++) {
                UserListModel *model2 = [self.mModel_myUnit.list objectAtIndex:m];
                NSMutableArray *arr9 = model2.groupselit_selit;
                for (int n=0; n<arr9.count; n++) {
                    groupselit_selitModel *model3 = [arr9 objectAtIndex:n];
                    if (self.mInt_select_send == 1) {
                        model3.mInt_select = 1;
                    }else if (self.mInt_select_send == 2){
                        if (model3.mInt_select == 0) {
                            model3.mInt_select = 1;
                        } else {
                            model3.mInt_select = 0;
                        }
                    }
                }
            }
        }
    }else if (self.mInt_where == 1){//下发通知
        //循环遍历
        for (int i=0; i<self.mArr_notice.count; i++) {
            CommMsgUnitNotice *noticeModel = [self.mArr_notice objectAtIndex:i];
            for (int a=0; a<noticeModel.selitadmintomem.count; a++) {
                UserListModel *model = [noticeModel.selitadmintomem objectAtIndex:a];
                for (int m=0; m<model.groupselit_selit.count; m++) {
                    groupselit_selitModel *tempModel = [model.groupselit_selit objectAtIndex:m];
                    if (tempModel.selit.length>0) {
                        if (self.mInt_select_send == 1) {
                            tempModel.mInt_select = 1;
                        }else if (self.mInt_select_send == 2){
                            if (tempModel.mInt_select == 0) {
                                tempModel.mInt_select = 1;
                            } else {
                                tempModel.mInt_select = 0;
                            }
                        }else if (self.mInt_select_send == 3){
                            if (tempModel.mInt_select == 1) {
                                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                                [dic setValue:tempModel.flag forKey:@"flag"];
                                [dic setValue:tempModel.selit forKey:@"selit"];
                            }
                        }
                    }
                }
            }
        }
    }else if (self.mInt_where == 2){//短信直通车
        for (int i=0; i<self.mArr_SMS.count; i++) {
            SMSTreeArrayModel *model = [self.mArr_SMS objectAtIndex:i];
            for (int m=0; m<model.smsTree.count; m++) {
                SMSTreeUnitModel *tempModel = [model.smsTree objectAtIndex:m];
                if (self.mInt_select_send == 1) {
                    tempModel.mInt_select = 1;
                }else if (self.mInt_select_send == 2){
                    if (tempModel.mInt_select == 0) {
                        tempModel.mInt_select = 1;
                    } else {
                        tempModel.mInt_select = 0;
                    }
                }else if (self.mInt_select_send == 3){
                    if (i == 0) {
                        if (tempModel.mInt_select == 1) {
                            tempModel.mInt_select = 0;
                            
                        }
                    }else if (i == 1){
                        if (tempModel.mInt_select == 1) {
                            tempModel.mInt_select = 0;
                            
                        }
                    }else if (i == 2){
                        if (tempModel.mInt_select == 1) {
                            tempModel.mInt_select = 0;
                        }
                    }
                }
            }
        }
    }
    [self.mCollectionV_list reloadData];
    
}
-(void)noMore{
    sleep(1);
}

//加载单位目录
-(void)addUnit{
    //先移除界面中得以前加载的button
    for (UIButton *btn in self.mView_unit.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn removeFromSuperview];
        }
    }
    for (UIButton *btn in self.mScroll_btn3.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn removeFromSuperview];
        }
    }
    for (UIButton *btn in self.mScroll_btn5.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn removeFromSuperview];
        }
    }
    //当前单位
    NSString *tempUnitName;
    if (self.mStr_unit.length>0) {
        tempUnitName = self.mStr_unit;
    }else{
        tempUnitName = self.mModel_unitList.myUnit.UintName;
    }
    CGSize size1 = [tempUnitName sizeWithFont:[UIFont systemFontOfSize:12]];
    UIButton *tempBtn1 = [self addUnit_btn];
    tempBtn1.frame = CGRectMake(self.mLab_1.frame.origin.x+self.mLab_1.frame.size.width+5, self.mLab_1.frame.origin.y, size1.width+5, 26);
    [tempBtn1 setTitle:tempUnitName forState:UIControlStateNormal];
    if (self.mInt_where == 0) {
        [tempBtn1 addTarget:self action:@selector(myUnitRevicerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }else if (self.mInt_where == 1){
        //无
    }
    [self.mView_unit addSubview:tempBtn1];
    //上级单位
    if (self.mInt_where == 0) {
        NSMutableArray *tempArr2 = [NSMutableArray arrayWithArray:self.mModel_unitList.UnitParents];
        D("parentUnitRevicer-== %lu,%lu",(unsigned long)tempArr2.count,(unsigned long)self.mModel_unitList.UnitParents.count);
        CGRect rect2 = self.mLab_2.frame;
        for (int i=0; i<tempArr2.count; i++) {
            myUnit *tempModel = [tempArr2 objectAtIndex:i];
            UIButton *tempBtn = [self addUnit_btn];
            CGSize size = [tempModel.UintName sizeWithFont:[UIFont systemFontOfSize:12]];
            tempBtn.frame = CGRectMake(rect2.origin.x+rect2.size.width+5, rect2.origin.y, size.width+5, 26);
            [tempBtn setTitle:tempModel.UintName forState:UIControlStateNormal];
            tempBtn.tag = i;
            [tempBtn addTarget:self action:@selector(parentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.mView_unit addSubview:tempBtn];
            rect2 = tempBtn.frame;
        }
        if (tempArr2.count == 0) {
            UIButton *tempBtn = [self addUnit_btn];
            CGSize size = [@"无" sizeWithFont:[UIFont systemFontOfSize:12]];
            tempBtn.frame = CGRectMake(self.mLab_2.frame.origin.x+self.mLab_2.frame.size.width+5, self.mLab_2.frame.origin.y, size.width+5, 26);
            [tempBtn setTitle:@"无" forState:UIControlStateNormal];
            [self.mView_unit addSubview:tempBtn];
        }
    }else if (self.mInt_where == 1){
        self.mLab_2.text = @" 群 发 :";
        CGRect rect2 = self.mLab_2.frame;
        for (int i=0; i<2; i++) {
            NSString *name;
            UIButton *tempBtn = [self addUnit_btn];
            if (i==0) {
                name = @"群发给下属单位";
            }else{
                name = @"群发给学校家长";
            }
            CGSize size = [name sizeWithFont:[UIFont systemFontOfSize:12]];
            tempBtn.frame = CGRectMake(rect2.origin.x+rect2.size.width+5, rect2.origin.y, size.width+5, 26);
            [tempBtn setTitle:name forState:UIControlStateNormal];
            tempBtn.tag = i;
            [tempBtn addTarget:self action:@selector(parentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.mView_unit addSubview:tempBtn];
            rect2 = tempBtn.frame;
        }
    }
    
    //下级单位
    NSMutableArray *tempArr3 = [NSMutableArray array];
    if (self.mInt_defaultTV_index == 0||self.mInt_defaultTV_index == 1){
        tempArr3 = [NSMutableArray arrayWithArray:self.mModel_unitList.subUnits];
    }else {
        tempArr3 = [NSMutableArray arrayWithArray:self.mModel_unitList.UnitClass];
    }
    CGRect rect3 = CGRectMake(0, 0, 0, 0);
    for (int i=0; i<tempArr3.count; i++) {
        UIButton *tempBtn = [self addUnit_btn];
        NSString *str;
        myUnit *tempModel = [tempArr3 objectAtIndex:i];
        str = tempModel.UintName;
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12]];
        tempBtn.frame = CGRectMake(rect3.origin.x+rect3.size.width+5, rect3.origin.y, size.width+5, 26);
        [tempBtn setTitle:str forState:UIControlStateNormal];
        rect3 = tempBtn.frame;
        tempBtn.tag = i;
        [tempBtn addTarget:self action:@selector(subNextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.mScroll_btn3 addSubview:tempBtn];
    }
    if (tempArr3.count == 0) {
        UIButton *tempBtn = [self addUnit_btn];
        CGSize size = [@"无" sizeWithFont:[UIFont systemFontOfSize:12]];
        tempBtn.frame = CGRectMake(rect3.origin.x+rect3.size.width+5, rect3.origin.y, size.width+5, 26);
        [tempBtn setTitle:@"无" forState:UIControlStateNormal];
        rect3 = tempBtn.frame;
        [self.mScroll_btn3 addSubview:tempBtn];
    }
    self.mScroll_btn3.contentSize = CGSizeMake(rect3.origin.x+rect3.size.width, self.mScroll_btn3.frame.size.height);
    //如果是老师身份，有执教班级
    NSMutableArray *tempArr5 = [NSMutableArray array];
    if (self.mInt_defaultTV_index == 1){
        self.mLab_5.hidden = NO;
        self.mScroll_btn5.hidden = NO;
        tempArr5 = [NSMutableArray arrayWithArray:self.mModel_unitList.UnitClass];
        CGRect rect5 = CGRectMake(0, 0, 0, 0);
        for (int i=0; i<tempArr5.count; i++) {
            UIButton *tempBtn = [self addUnit_btn];
            NSString *str;
            myUnit *tempModel = [tempArr5 objectAtIndex:i];
            str = tempModel.UintName;
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12]];
            tempBtn.frame = CGRectMake(rect5.origin.x+rect5.size.width+5, rect5.origin.y, size.width+5, 26);
            [tempBtn setTitle:str forState:UIControlStateNormal];
            rect5 = tempBtn.frame;
            tempBtn.tag = i;
            [tempBtn addTarget:self action:@selector(jiaoClassBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.mScroll_btn5 addSubview:tempBtn];
        }
        if (tempArr5.count == 0) {
            UIButton *tempBtn = [self addUnit_btn];
            CGSize size = [@"无" sizeWithFont:[UIFont systemFontOfSize:12]];
            tempBtn.frame = CGRectMake(rect5.origin.x+rect5.size.width+5, rect5.origin.y, size.width+5, 26);
            [tempBtn setTitle:@"无" forState:UIControlStateNormal];
            rect3 = tempBtn.frame;
            [self.mScroll_btn5 addSubview:tempBtn];
        }
        self.mScroll_btn5.contentSize = CGSizeMake(rect5.origin.x+rect5.size.width, self.mScroll_btn5.frame.size.height);
    }else{
        self.mLab_5.hidden = YES;
        self.mScroll_btn5.hidden = YES;
    }
    //重新布局
    [self setFrame];
}
//点击当前单位按钮
-(void)myUnitRevicerBtnClick:(UIButton *)btn{
    self.mInt_classNext = 0;
    self.mModel_myUnit = self.mModel_unitList.myUnit;
    self.mLab_currentUnit.text = self.mModel_unitList.myUnit.UintName;
    //刷新
    [self CollectionReloadData];
}
//点击上级单位中得按钮
-(void)parentBtnClick:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if (self.mInt_where == 0) {
        self.mInt_classNext = 0;
        NSMutableArray *tempArr3 = [NSMutableArray array];
        tempArr3 = [NSMutableArray arrayWithArray:self.mModel_unitList.UnitParents];
        myUnit *tempUnit = [tempArr3 objectAtIndex:btn.tag];
        if (tempUnit.list.count>0) {
            self.mModel_myUnit = tempUnit;
            //刷新
            [self CollectionReloadData];
        }else{
            //获取当前单位中的人员
            [self sendRequest_member:tempUnit];
        }
    }else if (self.mInt_where == 1){//下发通知
        if (btn.tag == 0) {
            CommMsgUnitNotice *model = [self.mArr_notice objectAtIndex:0];
            if ([model.msgAll intValue] == 1) {//有权限
                self.mArr_nowNotice = [NSMutableArray arrayWithArray:model.selitadmintomem];
                //刷新
                [self CollectionReloadData];
            }else{//没有权限
                self.mProgressV.mode = MBProgressHUDModeCustomView;
                self.mProgressV.labelText = @"没有权限";
                [self.mProgressV show:YES];
                [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
            }
        }else{
            CommMsgUnitNotice *model = [self.mArr_notice objectAtIndex:1];
            if ([model.msgAll intValue] == 1) {//有权限
                self.mArr_nowNotice = [NSMutableArray arrayWithArray:model.selitadmintomem];
                //刷新
                [self CollectionReloadData];
            }else{//没有权限
                self.mProgressV.mode = MBProgressHUDModeCustomView;
                self.mProgressV.labelText = @"没有权限";
                [self.mProgressV show:YES];
                [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
            }
        }
    }
}
//刷新
-(void)CollectionReloadData{
    [self.mCollectionV_list reloadData];
    self.mCollectionV_list.frame = CGRectMake(self.mCollectionV_list.frame.origin.x, self.mCollectionV_list.frame.origin.y, self.mCollectionV_list.frame.size.width, self.mCollectionV_list.collectionViewLayout.collectionViewContentSize.height);
    float height = self.mCollectionV_list.collectionViewLayout.collectionViewContentSize.height;
    NSLog(@"height = %f",height);
    self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, self.mCollectionV_list.frame.origin.y+self.mCollectionV_list.frame.size.height+150);
}
//获取当前单位中的人员
-(void)sendRequest_member:(myUnit *)tempUnit{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    //获取当前单位的人员数组
    if (self.mInt_defaultTV_index==0||self.mInt_defaultTV_index==1) {
        [[LoginSendHttp getInstance] login_GetUnitRevicer:tempUnit.TabID Flag:tempUnit.flag];
    }else{
        [[LoginSendHttp getInstance] login_GetUnitClassRevicer:tempUnit.TabID Flag:tempUnit.flag];
    }
    self.mLab_currentUnit.text = tempUnit.UintName;
    self.mProgressV.labelText = @"加载中...";
    self.mProgressV.mode = MBProgressHUDModeIndeterminate;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
}

//获取当前单位中的人员
-(void)sendRequest_member2:(myUnit *)tempUnit flag:(int)a{//a==0是获取老师的单位，a==1获取老师的执教班级
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    //获取当前单位的人员数组
    if (self.mInt_defaultTV_index==0||self.mInt_defaultTV_index==1) {
        if (a==0) {
            [[LoginSendHttp getInstance] login_GetUnitRevicer:tempUnit.TabID Flag:tempUnit.flag];
        }else{
            [[LoginSendHttp getInstance] login_GetUnitClassRevicer:tempUnit.TabID Flag:tempUnit.flag];
        }
    }else{
        [[LoginSendHttp getInstance] login_GetUnitClassRevicer:tempUnit.TabID Flag:tempUnit.flag];
    }
    self.mLab_currentUnit.text = tempUnit.UintName;
    self.mProgressV.labelText = @"加载中...";
    self.mProgressV.mode = MBProgressHUDModeIndeterminate;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
}

//点击下级单位按钮
-(void)subNextBtnClick:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    NSMutableArray *tempArr3 = [NSMutableArray array];
    if (self.mInt_defaultTV_index == 0||self.mInt_defaultTV_index == 1){
        self.mInt_classNext = 0;
        tempArr3 = [NSMutableArray arrayWithArray:self.mModel_unitList.subUnits];
        myUnit *tempUnit = [tempArr3 objectAtIndex:btn.tag];
        if (tempUnit.list.count>0) {
            self.mModel_myUnit = tempUnit;
            //刷新
            [self CollectionReloadData];
        }else{
            //获取当前单位中的人员
            [self sendRequest_member2:tempUnit flag:0];
        }
        self.mLab_currentUnit.text = tempUnit.UintName;
    }else {
        self.mInt_classNext = 1;
        tempArr3 = [NSMutableArray arrayWithArray:self.mModel_unitList.UnitClass];
        myUnit *tempUnit = [tempArr3 objectAtIndex:btn.tag];
        if (tempUnit.list.count>0) {
            self.mModel_myUnit = tempUnit;
            //刷新
            [self CollectionReloadData];
        }else{
            //获取当前单位中的人员
            [self sendRequest_member2:tempUnit flag:0];
        }
        self.mLab_currentUnit.text = tempUnit.UintName;
    }
}

//点击执教班级按钮
-(void)jiaoClassBtnClick:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    NSMutableArray *tempArr3 = [NSMutableArray array];
    if (self.mInt_defaultTV_index==1){
        self.mInt_classNext = 0;
        tempArr3 = [NSMutableArray arrayWithArray:self.mModel_unitList.UnitClass];
        myUnit *tempUnit = [tempArr3 objectAtIndex:btn.tag];
        if (tempUnit.list.count>0) {
            self.mModel_myUnit = tempUnit;
            //刷新
            [self CollectionReloadData];
        }else{
            //获取当前单位中的人员
            [self sendRequest_member2:tempUnit flag:1];
        }
        self.mLab_currentUnit.text = tempUnit.UintName;
    }
}

-(UIButton *)addUnit_btn{
    UIButton *tempBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn1.backgroundColor = BtnColor;
    tempBtn1.titleLabel.font = [UIFont systemFontOfSize: 12];
    [tempBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return tempBtn1;
}
-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if ([dm getInstance].identity.count==0) {
        return 0;
    }
    if (tableView.tag == 100) {
        return [dm getInstance].identity.count;
    }else if (tableView.tag == 101){
        Identity_model *idenModel = [[dm getInstance].identity objectAtIndex:self.mInt_defaultTV_index];
        if (self.mInt_defaultTV_index==0||self.mInt_defaultTV_index==1) {
            return idenModel.UserUnits.count;
        }else if(self.mInt_defaultTV_index==2||self.mInt_defaultTV_index==3){
            return idenModel.UserClasses.count;
        }
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
    }
    if ([dm getInstance].identity.count==0) {
        return cell;
    }
    NSUInteger row = [indexPath row];
    if (tableView.tag == 100) {
        Identity_model *idenModel = [[dm getInstance].identity objectAtIndex:row];
        cell.textLabel.text = idenModel.RoleIdName;
        if (self.mInt_defaultTV_index == 0&&row == 0) {
            //让自动设置为选中状态
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    } else {
        cell.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        Identity_model *idenModel = [[dm getInstance].identity objectAtIndex:self.mInt_defaultTV_index];
        if (self.mInt_defaultTV_index==0||self.mInt_defaultTV_index==1) {
            Identity_UserUnits_model *userUnitsModel = [idenModel.UserUnits objectAtIndex:row];
            cell.textLabel.text = userUnitsModel.UnitName;
        }else if(self.mInt_defaultTV_index==2||self.mInt_defaultTV_index==3){
            Identity_UserClasses_model *userUnitsModel = [idenModel.UserClasses objectAtIndex:row];
            cell.textLabel.text = userUnitsModel.ClassName;
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        Identity_model *idenModel = [[dm getInstance].identity objectAtIndex:indexPath.row];
        self.mInt_defaultTV_index = [idenModel.RoleIdentity intValue]-1;
        [self.mTalbeV_sub reloadData];
//        [dm getInstance].uType = (int)indexPath.row+1;
        [dm getInstance].uType = [idenModel.RoleIdentity intValue];
    } else if (tableView.tag == 101){
        //检查当前网络是否可用
        if ([self checkNetWork]) {
        return;
    }
        Identity_model *idenModel = [[dm getInstance].identity objectAtIndex:self.mInt_defaultTV_index];
        if (self.mInt_defaultTV_index==0||self.mInt_defaultTV_index==1) {
            Identity_UserUnits_model *userUnitsModel = [idenModel.UserUnits objectAtIndex:indexPath.row];
            [dm getInstance].UID = [userUnitsModel.UnitID intValue];
            self.mStr_unit = userUnitsModel.UnitName;
            [dm getInstance].mStr_unit = userUnitsModel.UnitName;
            [dm getInstance].mStr_tableID = userUnitsModel.TabIDStr;
            self.mLab_currentUnit.text = userUnitsModel.UnitName;
        }else if(self.mInt_defaultTV_index==2||self.mInt_defaultTV_index==3){
            Identity_UserClasses_model *userUnitsModel = [idenModel.UserClasses objectAtIndex:indexPath.row];
            [dm getInstance].UID = [userUnitsModel.SchoolID intValue];
            [dm getInstance].mStr_unit = userUnitsModel.ClassName;
            [dm getInstance].mStr_tableID = userUnitsModel.TabIDStr;
            self.mStr_unit = userUnitsModel.ClassName;
            self.mLab_currentUnit.text = userUnitsModel.ClassName;
        }
        [self.mArr_notice removeAllObjects];
        [self.mArr_nowNotice removeAllObjects];
        //刷新
        [self CollectionReloadData];
        //发送获取列表请求
        [[LoginSendHttp getInstance] changeCurUnit];
        [[LoginSendHttp getInstance] getUserInfoWith:[NSString stringWithFormat:@"%d",[dm getInstance].uType] UID:[NSString stringWithFormat:@"%d",[dm getInstance].UID]];
        self.mProgressV.labelText = @"加载中...";
        self.mProgressV.mode = MBProgressHUDModeIndeterminate;
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
        self.mInt_right = 2;
        [self.mView_switch setHidden:YES];
    }
}

#pragma mark - Collection View Data Source
//collectionView里有多少个组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.mInt_where == 0) {//发送消息
        int a;
//        if (self.mInt_classNext == 1){
//            return 1;
//        }else {
            a = (int)self.mModel_myUnit.list.count;
//        }
        return a;
    }else if (self.mInt_where == 1){//下发通知
        return self.mArr_nowNotice.count;
    }else if (self.mInt_where == 2){//短信直通车
        return self.mArr_SMS.count;
    }
    return 0;
}
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    NSNumber *num = [NSNumber numberWithInteger:section];
    if([[dm getInstance].sectionSet containsObject:num])
    {
        
    }
    else
    {
        return 0;
    }
    if (self.mInt_where == 0) {//发送消息
//        if (self.mInt_classNext == 1){
////            return self.mModel_class.studentgens_genselit.count;
//            return self.mModel_myUnit.list.count;
//        }else {
            for (int i=0; i<self.mModel_myUnit.list.count; i++) {
                if (section == i) {
                    UserListModel *model = [self.mModel_myUnit.list objectAtIndex:i];
                    return model.groupselit_selit.count;
                }
            }
//        }
    }else if (self.mInt_where == 1){//下发通知
        UserListModel *model = [self.mArr_nowNotice objectAtIndex:section];
        return model.groupselit_selit.count;
//        selitadminModel *model = [self.mArr_nowNotice objectAtIndex:section];
//        return model.UserList.count;
    }else if (self.mInt_where == 2){//短信直通车
        SMSTreeArrayModel *model = [self.mArr_SMS objectAtIndex:section];
        return model.smsTree.count;
    }
    
    return 0;
}
//定义并返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Forward_cell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    if (!cell) {
        
    }
    
    if (self.mInt_where == 2){//短信直通车
        SMSTreeArrayModel *model = [self.mArr_SMS objectAtIndex:indexPath.section];
        SMSTreeUnitModel *smsModel = [model.smsTree objectAtIndex:indexPath.row];
        CGSize size = [smsModel.name sizeWithFont:[UIFont systemFontOfSize:12]];
        if (size.width>cell.mLab_name.frame.size.width) {
            cell.mLab_name.numberOfLines = 2;
        }
        cell.mLab_name.text = smsModel.name;
        //对权限对区分
        if (indexPath.section > 0&&[smsModel.uType intValue] == 1) {
            cell.mImgV_select.image = [UIImage imageNamed:@"forward_select1"];
            cell.mLab_name.textColor = [UIColor grayColor];
        }else{
            cell.mLab_name.textColor = [UIColor blackColor];
            if (smsModel.mInt_select == 0) {
                
                cell.mImgV_select.image = [UIImage imageNamed:@"forward_select1"];
            } else {
                cell.mImgV_select.image = [UIImage imageNamed:@"forward_select2"];
            }
        }
    }else{
        groupselit_selitModel *groupModel = [[groupselit_selitModel alloc] init];
        if (self.mInt_where == 0) {//发送消息
            UserListModel *model = [self.mModel_myUnit.list objectAtIndex:indexPath.section];
            groupModel = [model.groupselit_selit objectAtIndex:indexPath.row];
        }else if (self.mInt_where == 1){//下发通知
            UserListModel *model = [self.mArr_nowNotice objectAtIndex:indexPath.section];
            groupModel = [model.groupselit_selit objectAtIndex:indexPath.row];
//            groupselit_selitModel *model = [self.mArr_nowNotice objectAtIndex:indexPath.section];
//            groupModel = model;
        }
        if (groupModel.selit.length>0) {
            cell.mLab_name.textColor = [UIColor blackColor];
            if (groupModel.mInt_select == 0) {
                cell.mImgV_select.image = [UIImage imageNamed:@"forward_select1"];
            } else {
                cell.mImgV_select.image = [UIImage imageNamed:@"forward_select2"];
            }
        }else{
            cell.mLab_name.textColor = [UIColor grayColor];
            cell.mImgV_select.image = [UIImage imageNamed:@"forward_select1"];
        }
        CGSize size = [groupModel.Name sizeWithFont:[UIFont systemFontOfSize:12]];
        if (size.width>cell.mLab_name.frame.size.width) {
            cell.mLab_name.numberOfLines = 2;
        }
        cell.mLab_name.text = groupModel.Name;
        
    }
    
    
    return cell;
}
//定义并返回每个headerView或footerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"kind = %@",kind);
//    CollectionFootView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CollectionFootView" forIndexPath:indexPath];
    //footView.backgroundColor = [UIColor lightGrayColor];
    if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        //return footView;
    }
    Forward_section *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDetailedViewControllerID forIndexPath:indexPath];
    NSNumber *num = [NSNumber numberWithInteger:indexPath.section];
    if([[dm getInstance].sectionSet containsObject:num])
    {
        [view.addBtn setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        [view.triangleBtn setBackgroundImage:[UIImage imageNamed:@"13.png"] forState:UIControlStateNormal];
    }
    else
    {
        [view.addBtn setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
        [view.triangleBtn setBackgroundImage:[UIImage imageNamed:@"12.png"] forState:UIControlStateNormal];

    }
    
    if([[dm getInstance].sectionSet2 containsObject:num])
    {
        [view.rightBtn setBackgroundImage:[UIImage imageNamed:@"10.png"] forState:UIControlStateNormal];
    }
    else
    {
        [view.rightBtn setBackgroundImage:[UIImage imageNamed:@"9.png"] forState:UIControlStateNormal];
        
    }
    view.delegate = self;
    view.tag = indexPath.section;
    if (self.mInt_where == 0) {//发送消息
//        if (self.mInt_classNext == 1){
//            view.mLab_name.text = @"本班家长";
//        }else {
            UserListModel *model = [self.mModel_myUnit.list objectAtIndex:indexPath.section];
            view.mLab_name.text = model.GroupName;
//        }
    }else if (self.mInt_where == 1){//下发通知
        UserListModel *model = [self.mArr_nowNotice objectAtIndex:indexPath.section];
        view.mLab_name.text = model.GroupName;
    }else if (self.mInt_where == 2){//短信直通车
        SMSTreeArrayModel *model = [self.mArr_SMS objectAtIndex:indexPath.section];
        view.mLab_name.text = model.name;
    }
    return view;
}
//设置每组的cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //找到当前点击的cell，然后改变选中值，重置界面
    
    if (self.mInt_where == 2){//短信直通车
        SMSTreeArrayModel *model = [self.mArr_SMS objectAtIndex:indexPath.section];
        SMSTreeUnitModel *smsModel = [model.smsTree objectAtIndex:indexPath.row];
        //对权限对区分
        if (indexPath.section > 0&&[smsModel.uType intValue] == 1) {;
        }else{
            if (smsModel.mInt_select == 0) {
                smsModel.mInt_select = 1;
            }else{
                smsModel.mInt_select = 0;
            }
            [self.mCollectionV_list reloadData];
        }
    }else{
        groupselit_selitModel *groupModel;
        if (self.mInt_where == 0) {//发送消息
            UserListModel *model = [self.mModel_myUnit.list objectAtIndex:indexPath.section];
            groupModel = [model.groupselit_selit objectAtIndex:indexPath.row];
        }else if (self.mInt_where == 1){//下发通知
            UserListModel *model = [self.mArr_nowNotice objectAtIndex:indexPath.section];
            groupModel = [model.groupselit_selit objectAtIndex:indexPath.row];
        }
        if (groupModel.selit.length>0) {
            if (groupModel.mInt_select == 0) {
                groupModel.mInt_select = 1;
            }else{
                groupModel.mInt_select = 0;
            }
            [self.mCollectionV_list reloadData];
        }
    }
}
//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(([dm getInstance].width-60)/2, 40);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
//手动设置size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(120, 40);
}

//section点击事件
-(void)Forward_sectionClickBtnWith:(UIButton *)btn cell:(Forward_section *)section{
    
    if(btn.tag == 3||btn.tag == 4||btn.tag == 5)
    {
        [self CollectionReloadData];
    }
    else
    {
    //找到当前点击的cell，然后改变选中值，重置界面
    if (self.mInt_where == 0) {//发送消息
        UserListModel *model = [self.mModel_myUnit.list objectAtIndex:section.tag];
        [utils logArr:self.mModel_myUnit.list];
        
        for (int i=0; i<model.groupselit_selit.count; i++) {
            //得到分组
            groupselit_selitModel *groupModel = [model.groupselit_selit objectAtIndex:i];
            //判断是全选还是反选
            if (btn.tag == 1) {
                groupModel.mInt_select = 1;
                
                
                
            }else{
                if (groupModel.mInt_select == 0) {
                    groupModel.mInt_select = 1;
                }else{
                    groupModel.mInt_select = 0;
                }
            }
        }
        //        }
    }else if (self.mInt_where == 1){//下发通知
        UserListModel *model = [self.mArr_nowNotice objectAtIndex:section.tag];
        for (int i=0; i<model.groupselit_selit.count; i++) {
            //得到分组
            groupselit_selitModel *groupModel = [model.groupselit_selit objectAtIndex:i];
            //判断是全选还是反选
            if (btn.tag == 1) {
                if (groupModel.selit.length>0) {
                    groupModel.mInt_select = 1;
                }
            }else{
                if (groupModel.selit.length>0) {
                    if (groupModel.mInt_select == 0) {
                        groupModel.mInt_select = 1;
                    }else{
                        groupModel.mInt_select = 0;
                    }
                }
            }
        }
    }else if (self.mInt_where == 2){//短信直通车
        SMSTreeArrayModel *model = [self.mArr_SMS objectAtIndex:section.tag];
        for (int i=0; i<model.smsTree.count; i++) {
            //得到分组
            SMSTreeUnitModel *smsModel = [model.smsTree objectAtIndex:i];
            //对权限对区分
            if (section.tag > 0&&[smsModel.uType intValue] == 1) {;
            }else{
                //判断是全选还是反选
                if (btn.tag == 1) {
                    smsModel.mInt_select = 1;
                }else{
                    if (smsModel.mInt_select == 0) {
                        smsModel.mInt_select = 1;
                    }else{
                        smsModel.mInt_select = 0;
                    }
                }
            }
        }
    }
    [self.mCollectionV_list reloadData];
    }
}

//导航条点击事件
-(void)myNavigationGoback{
    [utils popViewControllerAnimated:YES];
}
-(void)navigationRightAction:(UIButton *)sender{
    if (self.mInt_right == 2) {
        self.mInt_right = 1;
        [self.mView_switch setHidden:NO];
    } else {
        self.mInt_right = 2;
        [self.mView_switch setHidden:YES];
    }
}
//键盘点击DO
#pragma mark - UITextView Delegate Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
//输入内容时，让提示消失
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        self.mLab_tishi.hidden = YES;
    } else {
        self.mLab_tishi.hidden = NO;
    }
}
-(void)mBtn_send:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
//    if (btn.tag == 1) {
//        self.mInt_select_send = 1;
//    }else if (btn.tag == 2){
//        self.mInt_select_send = 2;
//    }else if (btn.tag == 3){
        if (self.topView.mTextV_input.text.length == 0) {
            self.mProgressV.mode = MBProgressHUDModeCustomView;
            self.mProgressV.labelText = @"请输入内容";
            [self.mProgressV show:YES];
            [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
            return;
        }
        self.mInt_select_send = 3;
    //}
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *array1 = [NSMutableArray array];
    NSMutableArray *array2 = [NSMutableArray array];
    
    if (self.mInt_where == 0) {//发送短信
        if (self.mInt_select_send == 3) {
            //当前单位
            myUnit *tempUnit = self.mModel_unitList.myUnit;
            [array addObjectsFromArray:[self addMyUnitMember:tempUnit]];
            //上级单位
            for (int i=0; i<self.mModel_unitList.UnitParents.count; i++) {
                myUnit *tempUnit = [self.mModel_unitList.UnitParents objectAtIndex:i];
                [array addObjectsFromArray:[self addMyUnitMember:tempUnit]];
            }
            //下级单位
            for (int i=0; i<self.mModel_unitList.subUnits.count; i++) {
                myUnit *tempUnit = [self.mModel_unitList.subUnits objectAtIndex:i];
                [array addObjectsFromArray:[self addMyUnitMember:tempUnit]];
            }
            for (int i=0; i<self.mModel_unitList.UnitClass.count; i++) {
                myUnit *tempUnit = [self.mModel_unitList.UnitClass objectAtIndex:i];
                [array addObjectsFromArray:[self addMyUnitMember:tempUnit]];
            }
        }else{
            //检索当前需要发送的ID
            for (int m=0; m<self.mModel_myUnit.list.count; m++) {
                UserListModel *model2 = [self.mModel_myUnit.list objectAtIndex:m];
                NSMutableArray *arr9 = model2.groupselit_selit;
                for (int n=0; n<arr9.count; n++) {
                    groupselit_selitModel *model3 = [arr9 objectAtIndex:n];
                    if (self.mInt_select_send == 1) {
                        model3.mInt_select = 1;
                    }else if (self.mInt_select_send == 2){
                        if (model3.mInt_select == 0) {
                            model3.mInt_select = 1;
                        } else {
                            model3.mInt_select = 0;
                        }
                    }
                }
            }
        }
    }else if (self.mInt_where == 1){//下发通知
        //循环遍历
        for (int i=0; i<self.mArr_notice.count; i++) {
            CommMsgUnitNotice *noticeModel = [self.mArr_notice objectAtIndex:i];
            for (int a=0; a<noticeModel.selitadmintomem.count; a++) {
                UserListModel *model = [noticeModel.selitadmintomem objectAtIndex:a];
                for (int m=0; m<model.groupselit_selit.count; m++) {
                    groupselit_selitModel *tempModel = [model.groupselit_selit objectAtIndex:m];
                    if (tempModel.selit.length>0) {
                        if (self.mInt_select_send == 1) {
                            tempModel.mInt_select = 1;
                        }else if (self.mInt_select_send == 2){
                            if (tempModel.mInt_select == 0) {
                                tempModel.mInt_select = 1;
                            } else {
                                tempModel.mInt_select = 0;
                            }
                        }else if (self.mInt_select_send == 3){
                            if (tempModel.mInt_select == 1) {
                                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                                [dic setValue:tempModel.flag forKey:@"flag"];
                                [dic setValue:tempModel.selit forKey:@"selit"];
                                [array addObject:dic];
                            }
                        }
                    }
                }
            }
        }
    }else if (self.mInt_where == 2){//短信直通车
        for (int i=0; i<self.mArr_SMS.count; i++) {
            SMSTreeArrayModel *model = [self.mArr_SMS objectAtIndex:i];
            for (int m=0; m<model.smsTree.count; m++) {
                SMSTreeUnitModel *tempModel = [model.smsTree objectAtIndex:m];
                if (self.mInt_select_send == 1) {
                    tempModel.mInt_select = 1;
                }else if (self.mInt_select_send == 2){
                    if (tempModel.mInt_select == 0) {
                        tempModel.mInt_select = 1;
                    } else {
                        tempModel.mInt_select = 0;
                    }
                }else if (self.mInt_select_send == 3){
                    if (i == 0) {
                        if (tempModel.mInt_select == 1) {
                            [array addObject:tempModel.id0];
                            
                        }
                    }else if (i == 1){
                        if (tempModel.mInt_select == 1) {
                            [array1 addObject:tempModel.id0];
                            
                        }
                    }else if (i == 2){
                        if (tempModel.mInt_select == 1) {
                            [array2 addObject:tempModel.id0];
                        }
                    }
                }
            }
        }
    }
    
    if (self.mInt_select_send == 1||self.mInt_select_send == 2) {
        [self.mCollectionV_list reloadData];
    }else if (self.mInt_select_send == 3){
        if (array.count==0) {
            self.mProgressV.mode = MBProgressHUDModeCustomView;
            self.mProgressV.labelText = @"请选择人员";
            //            self.mProgressV.userInteractionEnabled = NO;
            [self.mProgressV show:YES];
            [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
            return;
        }
        //发表
        if (self.mInt_where == 0) {
            NSMutableArray *array0 = [NSMutableArray array];
            [array0 addObjectsFromArray:self.topView.mArr_accessory];
            //[array0 addObjectsFromArray:self.mArr_photo];
            D("array.count-====%lu",(unsigned long)array0.count);
            [[LoginSendHttp getInstance] creatCommMsgWith:self.topView.mTextV_input.text SMSFlag:self.topView.mInt_sendMsg unitid:self.mModel_unitList.myUnit.TabIDStr classCount:0 grsms:1 array:array forwardMsgID:self.mStr_forwardTableID access:array0];
        }else if (self.mInt_where == 1) {//发表下发通知
            [[LoginSendHttp getInstance] creatCommMsgWith:self.mTextV_enter.text SMSFlag:self.mInt_sendMsg unitid:self.mModel_unitList.myUnit.TabIDStr classCount:(int)array.count grsms:1 arrMem:array arrGen:array1 forwardMsgID:self.mStr_forwardTableID];
        }if (self.mInt_where == 2) {//发表短信直通车
            [[LoginSendHttp getInstance] creatCommMsgWith:self.mTextV_enter.text SMSFlag:self.mInt_sendMsg unitid:[dm getInstance].mStr_tableID classCount:0 grsms:2 arrMem:array arrGen:array1 arrStu:array2];
        }
        
        self.mProgressV.labelText = @"加载中...";
        self.mProgressV.mode = MBProgressHUDModeIndeterminate;
        //        self.mProgressV.userInteractionEnabled = NO;
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
        
    }
    [self.mCollectionV_list reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

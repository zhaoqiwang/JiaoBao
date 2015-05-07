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



-(void)viewDidDisappear:(BOOL)animated{
    //界面消失时，移除通知
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.mProgressV hide:YES];

    [self removeFromParentViewController];
}
-(void)refreshWorkView:(id)sender
{
    [self setFrame];
    [self CollectionReloadData];
}

-(void)viewWillAppear:(BOOL)animated{

    [self setFrame];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshWorkView" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshWorkView:) name:@"refreshWorkView" object:nil];

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
  }

- (void)viewDidLoad {
    [super viewDidLoad];
    [dm getInstance].notificationSymbol = 1;

    
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];


    
    self.mModel_myUnit = [[myUnit alloc] init];
    
    self.mProgressV = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.mProgressV];
    self.mProgressV.delegate = self;

    //大scrollview的坐标
    self.mScrollV_all.frame = CGRectMake(0, 20, [dm getInstance].width, [dm getInstance].height-44-10);

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
    self.mBtn_invertSelect.frame = CGRectMake([dm getInstance].width-60+15, self.mLab_4.frame.origin.y, 45, 29);
    //self.mBtn_invertSelect.backgroundColor = [UIColor lightGrayColor];
    self.mBtn_invertSelect.tag = 2;
    [self.mBtn_invertSelect addTarget:self action:@selector(clickSendBtn:) forControlEvents:UIControlEventTouchUpInside];

  
    
    //人员列表
    self.mCollectionV_list.frame = CGRectMake(Margin,self.mLab_4.frame.size.height+self.mLab_4.frame.origin.y, [dm getInstance].width, 0);
    self.mCollectionV_list.backgroundColor = [UIColor whiteColor];
    self.mCollectionV_list.layer.borderWidth = 1;
    self.mCollectionV_list.layer.borderColor = [[UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1] CGColor];
    [self.mCollectionV_list registerClass:[Forward_cell class] forCellWithReuseIdentifier:kCellID];
    [self.mCollectionV_list registerClass:[Forward_section class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDetailedViewControllerID];
    [self.mCollectionV_list registerClass:[CollectionFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FootView"];
    
     [self.mCollectionV_list registerNib:[UINib nibWithNibName:@"CollectionFootView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FootView"];
    

    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTap:)];
    tap2.delegate = self;
    [self.topView addGestureRecognizer:tap2];
    
    [self sendRequest];
}

-(void)setFrame
{
    //放单位信息的
    
    //接收人，全选，反选，发表
    self.headView.frame = CGRectMake(0, self.topView.frame.size.height+self.topView.frame.origin.y+20, [dm getInstance].width, 28);
    self.mLab_4.frame =CGRectMake(Margin, self.topView.frame.origin.y+self.topView.frame.size.height+20, self.mLab_4.frame.size.width, 29);
    self.imgV.frame = CGRectMake([dm getInstance].width-15-100+15, self.mLab_4.frame.origin.y+7, 14, 14);
    self.imgV.image = [UIImage imageNamed:@"blank.png"];
    self.mBtn_all.frame = CGRectMake([dm getInstance].width-100+15, self.mLab_4.frame.origin.y, 40, 29);
    self.mBtn_invertSelect.frame = CGRectMake([dm getInstance].width-60+15, self.mLab_4.frame.origin.y, 45, 29);

       self.mCollectionV_list.frame = CGRectMake(Margin, self.headView.frame.origin.y+self.headView.frame.size.height, self.mCollectionV_list.frame.size.width, self.mCollectionV_list.collectionViewLayout.collectionViewContentSize.height);
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
    [self.topView.mTextV_input resignFirstResponder];
    
}

- (void)Loading {
    sleep(TIMEOUT);
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    self.mProgressV.labelText = @"加载超时";
//    self.mProgressV.userInteractionEnabled = NO;
    sleep(2);
}

//通知界面更新，获取事务信息接收单位列表
-(void)CommMsgRevicerUnitList:(NSNotification *)noti{
    [self.mProgressV hide:YES];
        self.mModel_unitList = noti.object;

        if([dm getInstance].notificationSymbol ==1)
        {
             [[LoginSendHttp getInstance] login_GetUnitRevicer:self.mModel_unitList.myUnit.TabID Flag:self.mModel_unitList.myUnit.flag];
            
        }

    

    
}

//获取到每个单位中的人员
-(void)GetUnitRevicer:(NSNotification *)noti{
    [self.mProgressV hide:YES];
    NSDictionary *dic = noti.object;
    NSString *unitID = [dic objectForKey:@"unitID"];
    NSArray *array = [dic objectForKey:@"array"];
    
    //当前单位
    if ([self.mModel_unitList.myUnit.TabID intValue] == [unitID intValue]&&[unitID intValue] == [dm getInstance].UID) {
        self.mModel_unitList.myUnit.list = [NSMutableArray arrayWithArray:array];
        self.mModel_myUnit = self.mModel_unitList.myUnit;
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

    //
    [self.mCollectionV_list reloadData];
    
}
-(void)noMore{
    sleep(1);
}


//刷新
-(void)CollectionReloadData{
    [self.mCollectionV_list reloadData];
    self.mCollectionV_list.frame = CGRectMake(self.mCollectionV_list.frame.origin.x, self.mCollectionV_list.frame.origin.y, self.mCollectionV_list.frame.size.width, self.mCollectionV_list.collectionViewLayout.collectionViewContentSize.height);
    float height = self.mCollectionV_list.collectionViewLayout.collectionViewContentSize.height;
    NSLog(@"height = %f",height);
    self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, self.mCollectionV_list.frame.origin.y+self.mCollectionV_list.frame.size.height+150);
}

#pragma mark - Collection View Data Source
//collectionView里有多少个组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
        int a;
//        if (self.mInt_classNext == 1){
//            return 1;
//        }else {
            a = (int)self.mModel_myUnit.list.count;
//        }
        return a;
   
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
    
    return 0;
}
//定义并返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Forward_cell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    if (!cell) {
        
    }
    
          groupselit_selitModel *groupModel = [[groupselit_selitModel alloc] init];
            UserListModel *model = [self.mModel_myUnit.list objectAtIndex:indexPath.section];
            groupModel = [model.groupselit_selit objectAtIndex:indexPath.row];
    
        if (groupModel.selit.length>0) {
            cell.mLab_name.textColor = [UIColor blackColor];
            if (groupModel.mInt_select == 0) {
                cell.mImgV_select.image = [UIImage imageNamed:@"blank"];
            } else {
                cell.mImgV_select.image = [UIImage imageNamed:@"selected"];
            }
        }else{
            cell.mLab_name.textColor = [UIColor grayColor];
            cell.mImgV_select.image = [UIImage imageNamed:@"blank"];
        }
        CGSize size = [groupModel.Name sizeWithFont:[UIFont systemFontOfSize:12]];
        if (size.width>cell.mLab_name.frame.size.width) {
            cell.mLab_name.numberOfLines = 2;
        }
        cell.mLab_name.text = groupModel.Name;
        
    
    
    
    return cell;
}
//定义并返回每个headerView或footerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    Forward_section *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kDetailedViewControllerID forIndexPath:indexPath];
    
    NSNumber *num = [NSNumber numberWithInteger:indexPath.section];
    if([[dm getInstance].sectionSet containsObject:num])
    {
        [view.addBtn setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        [view.triangleBtn setImage:[UIImage imageNamed:@"bTri.png"] forState:UIControlStateNormal];
    }
    else
    {
        [view.addBtn setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
        [view.triangleBtn setImage:[UIImage imageNamed:@"rTri.png"] forState:UIControlStateNormal];

    }
    UserListModel *model = [self.mModel_myUnit.list objectAtIndex:indexPath.section];
    if(model.sectionSelSymbol ==1)
    {
        [view.rightBtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    }
    else
    {
        [view.rightBtn setImage:[UIImage imageNamed:@"blank.png"] forState:UIControlStateNormal];

        
    }

    
    

    view.delegate = self;
    view.tag = indexPath.section;

    view.mLab_name.text = model.GroupName;

    

    CGSize size = [view.mLab_name.text sizeWithFont:[UIFont systemFontOfSize:12]];

    view.addBtn.frame = CGRectMake(view.mLab_name.frame.origin.x+size.width, 5, 30, 30);
    
    return view;
}
//设置每组的cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *num = [NSNumber numberWithInteger:indexPath.section ];

    UserListModel *model = [self.mModel_myUnit.list objectAtIndex:indexPath.section];

        groupselit_selitModel *groupModel;
        groupModel = [model.groupselit_selit objectAtIndex:indexPath.row];
  

            [self.mCollectionV_list reloadData];
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
    UserListModel *model = [self.mModel_myUnit.list objectAtIndex:section.tag];

    if(btn.tag == 6)
    {
        [self CollectionReloadData];
    }
    else if(btn.tag == 7)
    {
        if(model.sectionSelSymbol == 0||model.sectionSelSymbol == 2)
        {
            model.sectionSelSymbol = 1;
            for (int i=0; i<model.groupselit_selit.count; i++)
            {
                groupselit_selitModel *groupModel = [model.groupselit_selit objectAtIndex:i];
                groupModel.mInt_select = 1;
                
            }
            
        }
        else if(model.sectionSelSymbol == 1)
        {

        }


    }
    else if(btn.tag == 2)
    {
        if(model.sectionSelSymbol == 1)
        {
            model.sectionSelSymbol = 0;
            for (int i=0; i<model.groupselit_selit.count; i++)
            {
                groupselit_selitModel *groupModel = [model.groupselit_selit objectAtIndex:i];
                groupModel.mInt_select = 0;
                
            }
            
        }
        else if(model.sectionSelSymbol == 0)
        {
            model.sectionSelSymbol = 1;
            for (int i=0; i<model.groupselit_selit.count; i++)
            {
                groupselit_selitModel *groupModel = [model.groupselit_selit objectAtIndex:i];
                groupModel.mInt_select = 1;
                
            }
        }
        else if(model.sectionSelSymbol == 2)
        {
            model.sectionSelSymbol = 0;
            for (int i=0; i<model.groupselit_selit.count; i++)
            {
                groupselit_selitModel *groupModel = [model.groupselit_selit objectAtIndex:i];
                if(groupModel.mInt_select==0)
                {
                    groupModel.mInt_select = 1;

                    
                }
                else
                {
                    groupModel.mInt_select = 0;

                    
                }
                
            }
        }
        
    }
    BOOL isAll=NO;
    for(int i=0;i<self.mModel_myUnit.list.count;i++)
    {
        UserListModel *model = [self.mModel_myUnit.list objectAtIndex:i];
        isAll = model.sectionSelSymbol;

        
    }
    

            [self.mCollectionV_list reloadData];
    
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

-(void)mBtn_send:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
//    if (btn.tag == 1) {
//        btn.tag = 1;
//    }else if (btn.tag == 2){
//        btn.tag = 2;
//    }else if (btn.tag == 3){
        if (self.topView.mTextV_input.text.length == 0) {
            self.mProgressV.mode = MBProgressHUDModeCustomView;
            self.mProgressV.labelText = @"请输入内容";
            [self.mProgressV show:YES];
            [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
            return;
        }
        btn.tag = 3;
    //}
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *array1 = [NSMutableArray array];
    NSMutableArray *array2 = [NSMutableArray array];
    
      if (btn.tag == 1||btn.tag == 2) {
        [self.mCollectionV_list reloadData];
    }else if (btn.tag == 3){
        if (array.count==0) {
            self.mProgressV.mode = MBProgressHUDModeCustomView;
            self.mProgressV.labelText = @"请选择人员";
            //            self.mProgressV.userInteractionEnabled = NO;
            [self.mProgressV show:YES];
            [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
            return;
        }
        //发表
            NSMutableArray *array0 = [NSMutableArray array];
            [array0 addObjectsFromArray:self.topView.mArr_accessory];
            //[array0 addObjectsFromArray:self.mArr_photo];
            D("array.count-====%lu",(unsigned long)array.count);
//            [[LoginSendHttp getInstance] creatCommMsgWith:self.topView.mTextV_input.text SMSFlag:self.topView.mInt_sendMsg unitid:self.mModel_unitList.myUnit.TabIDStr classCount:0 grsms:1 array:array forwardMsgID:self.mStr_forwardTableID access:array0];
        
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



@end

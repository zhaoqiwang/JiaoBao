//
//  MoreUnitWorkView.m
//  JiaoBao
//
//  Created by Zqw on 15-4-23.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "MoreUnitWorkView.h"
#import "Reachability.h"

@implementation MoreUnitWorkView
@synthesize mViewTop,mScrollV_all,mModel_unitList,mArr_display,mArr_sumData,mTableV_work,mInt_readflag,mInt_requestCount,mInt_requestCount2,mProgressV,mInt_flag,mModel_right;

-(void)dealloc1{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshWorkView:) name:@"refreshWorkView" object:nil];


}

- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self)
    {
        // Initialization code
        self.frame = frame;
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshWorkView" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshWorkView:) name:@"refreshWorkView" object:nil];
        //通知界面更新，获取事务信息接收单位列表
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CommMsgRevicerUnitList" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CommMsgRevicerUnitList:) name:@"CommMsgRevicerUnitList" object:nil];
        //获取到每个单位中的人员
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetUnitRevicer" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetUnitRevicer:) name:@"GetUnitRevicer" object:nil];
        //添加附件后重置界面
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshWorkView" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMoreUnitView) name:@"refreshWorkView" object:nil];
        //发表消息成功推送
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"creatCommMsg" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatCommMsg:) name:@"creatCommMsg" object:nil];
        //第一次进入此界面，发送数据请求
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fristGotoMoreUnit" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fristGotoMoreUnit) name:@"fristGotoMoreUnit" object:nil];
        //获取发送权限
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetCommPerm" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetCommPerm:) name:@"GetCommPerm" object:nil];
        
        self.mArr_sumData = [NSMutableArray array];
        self.mArr_display = [NSArray array];
        self.mInt_readflag = 0;
        self.mInt_requestCount = 0;
        self.mInt_requestCount2 = 0;
        //总框
        self.mScrollV_all = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, self.frame.size.height-0)];
        [self addSubview:self.mScrollV_all];
        //上半部分
        self.mViewTop = [[NewWorkTopView alloc] init];
        self.mViewTop.delegate = self;
        [self.mScrollV_all addSubview:self.mViewTop];
        //表格
        self.mTableV_work = [[UITableView alloc] initWithFrame:CGRectMake(0, self.mViewTop.frame.size.height, frame.size.width, 48*7)];
        self.mTableV_work.delegate = self;
        self.mTableV_work.dataSource = self;
        self.mTableV_work.scrollEnabled = NO;
        [self.mScrollV_all addSubview:self.mTableV_work];
        
        //加载提示框
        self.mProgressV = [[MBProgressHUD alloc]initWithView:self];
        [self addSubview:self.mProgressV];
        self.mProgressV.delegate = self;
        //刚进入界面时，加载全部数据
//        [self sendRequest];
    }
    return self;
}

-(void)GetCommPerm:(id)sender{
    NSMutableDictionary *dic = [sender object];
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag intValue] ==0) {//成功
        self.mModel_right = [dic objectForKey:@"model"];
        //添加基本数据
        [self addData];
        [self reloadDataForDisplayArray];//初始化将要显示的数据
    }else{
        self.mProgressV.mode = MBProgressHUDModeCustomView;
        self.mProgressV.labelText = @"获取权限失败";
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
    }
}

//第一次进入此界面，发送数据请求
-(void)fristGotoMoreUnit{
    if (self.mInt_flag ==0) {
        self.mInt_flag = 1;
//        if (self.mArr_sumData.count>0) {
        if (([self.mModel_right.ParentCommRight intValue] ==0&&[self.mModel_right.SubUnitCommRight intValue] ==0)||self.mArr_sumData.count==0) {
            [self.mScrollV_all removeFromSuperview];
            self.mProgressV.mode = MBProgressHUDModeCustomView;
            self.mProgressV.labelText = @"无发送权限或没有其他单位";
            [dm getInstance].thirdFlag = @"1";
            [self.mProgressV show:YES];
            [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
        }else{
            [self sendRequest];
        }
    }
}
-(void)refreshWorkView:(id)sender
{
    [self refreshMoreUnitView];
}

//添加附件后重置界面
-(void)refreshMoreUnitView{
    self.mViewTop.frame = CGRectMake(0, 0, [dm getInstance].width, self.mViewTop.frame.size.height);
    self.mTableV_work.frame = CGRectMake(0, self.mViewTop.frame.origin.y+self.mViewTop.frame.size.height, [dm getInstance].width, self.mTableV_work.contentSize.height);
    self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, self.mTableV_work.frame.origin.y+self.mTableV_work.contentSize.height);
}

//发表消息成功
-(void)creatCommMsg:(NSNotification *)noti{
    NSString *str = noti.object;
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    self.mProgressV.labelText = str;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
    self.mViewTop.mTextV_input.text = @"";
    [self.mViewTop.mArr_accessory removeAllObjects];
    //[self.mArr_photo removeAllObjects];
    //刷新界面
    [self.mViewTop addAccessoryPhoto];
    //刷新界面
    [self refreshMoreUnitView];
    //重置数据
    for (TreeView_node *node in self.mArr_sumData) {
        node.mInt_select = 0;
        for(TreeView_node *node2 in node.sonNodes){
            node2.mInt_select = 0;
            for(TreeView_node *node3 in node2.sonNodes){
                node3.mInt_select = 0;
                for(TreeView_node *node4 in node3.sonNodes){
                    node4.mInt_select = 0;
                }
            }
        }
    }
    //刷新
    [self reloadDataForDisplayArray];
    
}

-(void)sendRequest{
    self.mInt_requestCount = 0;
    self.mInt_requestCount2 = 0;
    //上级单位
    TreeView_node *node1;
    for (TreeView_node *node in self.mArr_sumData) {
        if ([node.flag isEqual:@"+2"]) {
            node1 = node;
        }
    }
//    for (int i=0; i<self.mModel_unitList.UnitParents.count; i++) {
        for(TreeView_node *node2 in node1.sonNodes){
            NewWorkTree_model *tempModel = node2.nodeData;
            myUnit *temp = tempModel.mModel_unit;
            self.mInt_requestCount ++;
            if ([dm getInstance].uType == 1||[dm getInstance].uType == 2) {
                [[LoginSendHttp getInstance] login_GetUnitRevicer:temp.TabID Flag:temp.flag];
            }else{
                [[LoginSendHttp getInstance] login_GetUnitClassRevicer:temp.TabID Flag:temp.flag];
            }
        }
//    }
    //下级单位
    TreeView_node *node2;
    for (TreeView_node *node in self.mArr_sumData) {
        if ([node.flag isEqual:@"+3"]) {
            node2 = node;
        }
    }
    //判断是子类还是班级
//    NSMutableArray *sub_unit ;
//    if (self.mModel_unitList.subUnits.count>0) {
//        sub_unit = [NSMutableArray arrayWithArray:self.mModel_unitList.subUnits];
//    }else{
//        sub_unit = [NSMutableArray arrayWithArray:self.mModel_unitList.UnitClass];
//    }
//    for (int i=0; i<sub_unit.count; i++) {
        for(TreeView_node *node3 in node2.sonNodes){
            self.mInt_requestCount ++;
            NewWorkTree_model *tempModel = node3.nodeData;
            myUnit *temp = tempModel.mModel_unit;
            if (self.mModel_unitList.subUnits.count>0) {
                [[LoginSendHttp getInstance] login_GetUnitRevicer:temp.TabID Flag:temp.flag];
            }else{
                [[LoginSendHttp getInstance] login_GetUnitClassRevicer:temp.TabID Flag:temp.flag];
            }
        }
//    }
    
    self.mProgressV.labelText = @"加载中...";
    self.mProgressV.mode = MBProgressHUDModeIndeterminate;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
}

- (void)Loading {
    sleep(TIMEOUT);
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    self.mProgressV.labelText = @"加载超时";
    sleep(2);
}

//点击发送按钮
-(void)mBtn_send:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if (self.mViewTop.mTextV_input.text.length == 0) {
        self.mProgressV.mode = MBProgressHUDModeCustomView;
        self.mProgressV.labelText = @"请输入内容";
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
        return;
    }
    //循环找需要发送的人
    NSMutableArray *array = [NSMutableArray array];
    for (TreeView_node *node in self.mArr_sumData) {
        NewWorkTree_model *temp2 = node.nodeData;
        if ([temp2.mStr_name isEqual:@"所有班级"]) {
            
        }else{
            for(TreeView_node *node2 in node.sonNodes){
                for(TreeView_node *node3 in node2.sonNodes){
                    for(TreeView_node *node4 in node3.sonNodes){
                        if (node4.mInt_select == 1) {
                            NewWorkTree_model *model = node4.nodeData;
                            groupselit_selitModel *model3 = model.mModel_people;
                            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                            [dic setValue:model3.flag forKey:@"flag"];
                            [dic setValue:model3.selit forKey:@"selit"];
                            [array addObject:dic];
                        }
                    }
                }
            }
        }
    }
    if (array.count==0) {
        self.mProgressV.mode = MBProgressHUDModeCustomView;
        self.mProgressV.labelText = @"请选择人员";
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
        return;
    }
    //发表
    [[LoginSendHttp getInstance] creatCommMsgWith:self.mViewTop.mTextV_input.text SMSFlag:self.mViewTop.mInt_sendMsg unitid:self.mModel_unitList.myUnit.TabIDStr classCount:0 grsms:1 array:array forwardMsgID:@"" access:self.mViewTop.mArr_accessory];
    self.mProgressV.labelText = @"加载中...";
    self.mProgressV.mode = MBProgressHUDModeIndeterminate;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
}

//通知界面更新，获取事务信息接收单位列表
-(void)CommMsgRevicerUnitList:(NSNotification *)noti{
    self.mModel_unitList = noti.object;
    //判断是否只有当前一个单位
    if (self.mModel_unitList.UnitParents.count==0&&self.mModel_unitList.subUnits.count==0) {
        [self.mArr_sumData removeAllObjects];
    }else{
//        TreeView_node *node0 = [self.mArr_sumData objectAtIndex:0];
        TreeView_node *node0;
        for (TreeView_node *node in self.mArr_sumData) {
            if ([node.flag isEqual:@"+1"]) {
                node0 = node;
                
                //当前单位
                myUnit *tempMyUnit= self.mModel_unitList.myUnit;
                //第1根节点
                TreeView_node *node6 = [[TreeView_node alloc]init];
                node6.nodeLevel = 1;
                node6.type = 1;
                node6.sonNodes = nil;
                node6.isExpanded = FALSE;
                node6.flag = tempMyUnit.TabID;
                node6.nodeFlag  = [NSString stringWithFormat:@"%@-%@",node0.nodeFlag,node6.flag];
                NewWorkTree_model *temp6 =[[NewWorkTree_model alloc]init];
                temp6.mStr_name = tempMyUnit.UintName;
                temp6.mModel_unit = tempMyUnit;
                temp6.mStr_img_open_close = @"root_close";
                node6.nodeData = temp6;
                
                node0.sonNodes = [NSMutableArray arrayWithObjects:node6,nil];
            }
        }
        
        //上级单位
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
//        TreeView_node *node1 = [self.mArr_sumData objectAtIndex:1];
        TreeView_node *node1;
        for (TreeView_node *node in self.mArr_sumData) {
            if ([node.flag isEqual:@"+2"]) {
                node1 = node;
                
                //对人员进行排序
                self.mModel_unitList.UnitParents = [self userNameChineseSort:self.mModel_unitList.UnitParents Flag:2];
                for (int i=0; i<self.mModel_unitList.UnitParents.count; i++) {
                    myUnit *tempUnit = [self.mModel_unitList.UnitParents objectAtIndex:i];
                    //第1根节点
                    TreeView_node *node = [[TreeView_node alloc]init];
                    node.nodeLevel = 1;
                    node.type = 1;
                    node.sonNodes = nil;
                    node.isExpanded = FALSE;
                    node.flag = tempUnit.TabID;
                    node.nodeFlag  = [NSString stringWithFormat:@"%@-%@",node1.nodeFlag,node.flag];
                    NewWorkTree_model *temp =[[NewWorkTree_model alloc]init];
                    temp.mStr_name = tempUnit.UintName;
                    temp.mModel_unit = tempUnit;
                    temp.mStr_img_open_close = @"root_close";
                    node.nodeData = temp;
                    [tempArr addObject:node];
                }
                
                node1.sonNodes = [NSMutableArray arrayWithArray:tempArr];
            }
        }
        
        //下级单位
        NSMutableArray *tempArr2 = [[NSMutableArray alloc] init];
//        TreeView_node *node2 = [self.mArr_sumData objectAtIndex:2];
        TreeView_node *node2;
        for (TreeView_node *node in self.mArr_sumData) {
            if ([node.flag isEqual:@"+3"]) {
                node2 = node;
                
                //判断是子类还是班级
                NSMutableArray *sub_unit ;
                if (self.mModel_unitList.subUnits.count>0) {
                    sub_unit = [NSMutableArray arrayWithArray:self.mModel_unitList.subUnits];
                }else{
                    sub_unit = [NSMutableArray arrayWithArray:self.mModel_unitList.UnitClass];
                    NewWorkTree_model *temp2 = node2.nodeData;
                    temp2.mStr_name = @"所有班级";
                }
                //对人员进行排序
                sub_unit = [self userNameChineseSort:sub_unit Flag:2];
                for (int i=0; i<sub_unit.count; i++) {
                    myUnit *tempUnit = [sub_unit objectAtIndex:i];
                    //第1根节点
                    TreeView_node *node = [[TreeView_node alloc]init];
                    node.nodeLevel = 1;
                    node.type = 1;
                    node.sonNodes = nil;
                    node.isExpanded = FALSE;
                    node.flag = tempUnit.TabID;
                    node.nodeFlag  = [NSString stringWithFormat:@"%@-%@",node2.nodeFlag,node.flag];
                    NewWorkTree_model *temp =[[NewWorkTree_model alloc]init];
                    temp.mStr_name = tempUnit.UintName;
                    temp.mModel_unit = tempUnit;
                    temp.mStr_img_open_close = @"root_close";
                    node.nodeData = temp;
                    [tempArr2 addObject:node];
                }
                
                node2.sonNodes = [NSMutableArray arrayWithArray:tempArr2];
            }
        }
    }
    
    [self reloadDataForDisplayArray];
}

//获取到每个单位中的人员
-(void)GetUnitRevicer:(NSNotification *)noti{
    self.mInt_requestCount2 ++;
    if (self.mInt_requestCount == self.mInt_requestCount2) {
        [self.mProgressV hide:YES];
    }
    NSDictionary *dic = noti.object;
    NSString *unitID = [dic objectForKey:@"unitID"];
    NSArray *array = [dic objectForKey:@"array"];
    //找到当前这个单位，塞入数组
    
    //当前单位
    if ([self.mModel_unitList.myUnit.TabID intValue] == [unitID intValue]) {
        self.mModel_unitList.myUnit.list = [NSMutableArray arrayWithArray:array];
    }
    //上级单位
    for (int i=0; i<self.mModel_unitList.UnitParents.count; i++) {
        myUnit *unit = [self.mModel_unitList.UnitParents objectAtIndex:i];
        if ([unit.TabID intValue] == [unitID intValue]) {
            unit.list = [NSMutableArray arrayWithArray:array];
        }
    }
    //下级单位
    for (int i=0; i<self.mModel_unitList.subUnits.count; i++) {
        myUnit *unit = [self.mModel_unitList.subUnits objectAtIndex:i];
        if ([unit.TabID intValue] == [unitID intValue]) {
            unit.list = [NSMutableArray arrayWithArray:array];
        }
    }
    //班级
    for (int i=0; i<self.mModel_unitList.UnitClass.count; i++) {
        myUnit *unit = [self.mModel_unitList.UnitClass objectAtIndex:i];
        if ([unit.TabID intValue] == [unitID intValue]) {
            unit.list = [NSMutableArray arrayWithArray:array];
        }
    }
    //找到当前的节点
    TreeView_node *tempNode = [[TreeView_node alloc] init];
    for (TreeView_node *node in self.mArr_sumData) {
        for(TreeView_node *node2 in node.sonNodes){
            NewWorkTree_model *temp = node2.nodeData;
            if ([temp.mModel_unit.TabID isEqual:unitID]) {
                tempNode = node2;
                break;
            }
            for(TreeView_node *node3 in node2.sonNodes){
                NewWorkTree_model *temp = node3.nodeData;
                if ([temp.mModel_unit.TabID isEqual:unitID]) {
                    tempNode = node3;
                    break;
                }
            }
        }
    }
    //对分组排序
    array = [self userNameChineseSort:(NSMutableArray *)array Flag:3];
    //往数组中塞数据
    NSMutableArray *tempArr2 = [[NSMutableArray alloc] init];
    for (int i=0; i<array.count; i++) {
        UserListModel *model = [array objectAtIndex:i];
        NewWorkTree_model *tempUnit = tempNode.nodeData;
        //第2根节点
        TreeView_node *node0 = [[TreeView_node alloc]init];
        node0.nodeLevel = 2;
        node0.type = 2;
        node0.sonNodes = nil;
        node0.isExpanded = FALSE;
        node0.flag = [NSString stringWithFormat:@"%@_%d",tempUnit.mModel_unit.TabID,self.mInt_readflag];
        node0.nodeFlag  = [NSString stringWithFormat:@"%@-%@",tempNode.nodeFlag,node0.flag];
        NewWorkTree_model *temp =[[NewWorkTree_model alloc]init];
        temp.mStr_name = model.GroupName;
        temp.mModel_group = model;
        temp.mStr_img_open_close = @"root_close";
        node0.nodeData = temp;
        //对人员进行排序
        model.groupselit_selit = [self userNameChineseSort:model.groupselit_selit Flag:1];
        //检查当前分组的子类数组
        NSMutableArray *tempArr3 = [[NSMutableArray alloc] init];
        for (int a=0; a<model.groupselit_selit.count; a++) {
            groupselit_selitModel *groupModel = [model.groupselit_selit objectAtIndex:a];
            //第3根节点
            TreeView_node *node = [[TreeView_node alloc]init];
            node.nodeLevel = 3;
            node.type = 3;
            node.sonNodes = nil;
            node.isExpanded = FALSE;
//            node.flag = [NSString stringWithFormat:@"%@_%d",tempUnit.TabID,self.mInt_readflag];
            node.nodeFlag  = [NSString stringWithFormat:@"%@-%@",node0.nodeFlag,groupModel.AccID];
            NewWorkTree_model *temp =[[NewWorkTree_model alloc]init];
            temp.mStr_name = groupModel.Name;
            temp.mModel_people = groupModel;
            temp.mStr_img_open_close = @"root_close";
            node.nodeData = temp;
            [tempArr3 addObject:node];
        }
        node0.sonNodes = [NSMutableArray arrayWithArray:tempArr3];
        [tempArr2 addObject:node0];
        self.mInt_readflag++;
    }
    tempNode.sonNodes = [NSMutableArray arrayWithArray:tempArr2];
    //刷新
    [self reloadDataForDisplayArray];
}

//对人员1和分组2进行排序，
-(NSMutableArray *)userNameChineseSort:(NSMutableArray *)array Flag:(int)flag{
    //Step2:获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[array count];i++){
        ChineseString *chineseString=[[ChineseString alloc]init];
        if (flag == 1) {
            groupselit_selitModel *model = [array objectAtIndex:i];
            chineseString.string=[NSString stringWithString:model.Name];
            chineseString.groupselit = model;
        }else if (flag == 2){
            myUnit *model = [array objectAtIndex:i];
            chineseString.string=[NSString stringWithString:model.UintName];
            chineseString.myUnitModel = model;
        }else if (flag == 3){
            UserListModel *model = [array objectAtIndex:i];
            chineseString.string=[NSString stringWithString:model.GroupName];
            chineseString.userListModel = model;
        }
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            NSString *pinYinResult=[NSString string];
            for(int j=0;j<chineseString.string.length;j++){
                NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin=pinYinResult;
        }else{
            chineseString.pinYin=@"";
        }
        [chineseStringsArray addObject:chineseString];
    }
    
    //Step3:按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    // Step4:如果有需要，再把排序好的内容从ChineseString类中提取出来
    NSMutableArray *result=[NSMutableArray array];
    for(int i=0;i<[chineseStringsArray count];i++){
        if (flag == 1) {
            groupselit_selitModel *tempModel = ((ChineseString*)[chineseStringsArray objectAtIndex:i]).groupselit;
            [result addObject:tempModel];
        }else if (flag == 2){
            myUnit *tempModel = ((ChineseString*)[chineseStringsArray objectAtIndex:i]).myUnitModel;
            [result addObject:tempModel];
        }else if (flag == 3){
            UserListModel *tempModel = ((ChineseString*)[chineseStringsArray objectAtIndex:i]).userListModel;
            [result addObject:tempModel];
        }
    }
    
    return result;
}

//添加数据
-(void)addData{
    //第0根节点
    TreeView_node *node0 = [[TreeView_node alloc]init];
    if ([self.mModel_right.UnitCommRight intValue] ==1) {
        node0.nodeLevel = 0;
        node0.type = 0;
        node0.sonNodes = nil;
        node0.isExpanded = FALSE;
        node0.flag = @"+1";
        node0.nodeFlag  = @"+1";
        NewWorkTree_model *temp0 =[[NewWorkTree_model alloc]init];
        temp0.mStr_name = @"当前单位";
        temp0.mStr_img_open_close = @"root_close";
        node0.nodeData = temp0;
    }
    
    TreeView_node *node1 = [[TreeView_node alloc]init];
    if ([self.mModel_right.ParentCommRight intValue] ==1) {
        node1.nodeLevel = 0;
        node1.type = 0;
        node1.sonNodes = nil;
        node1.isExpanded = FALSE;
        node1.flag = @"+2";
        node1.nodeFlag  = @"+2";
        NewWorkTree_model *temp1 =[[NewWorkTree_model alloc]init];
        temp1.mStr_name = @"上级单位";
        temp1.mStr_img_open_close = @"root_close";
        node1.nodeData = temp1;
    }
    
    TreeView_node *node2 = [[TreeView_node alloc]init];
    if ([self.mModel_right.SubUnitCommRight intValue] ==1) {
        node2.nodeLevel = 0;
        node2.type = 0;
        node2.sonNodes = nil;
        node2.isExpanded = FALSE;
        node2.flag = @"+3";
        node2.nodeFlag  = @"+3";
        NewWorkTree_model *temp2 =[[NewWorkTree_model alloc]init];
        temp2.mStr_name = @"下级单位";
        temp2.mStr_img_open_close = @"root_close";
        node2.nodeData = temp2;
    }
    
    self.mArr_sumData = [NSMutableArray arrayWithObjects:node0,node1,node2, nil];
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_display.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"TreeView_Level0_Cell";
    static NSString *indentifier1 = @"TreeView_Level1_Cell";
//    static NSString *indentifier2 = @"TreeView_Level2_Cell";
    TreeView_node *node = [mArr_display objectAtIndex:indexPath.row];
    if(node.type == 0||node.type == 1){//类型为0的cell
        TreeView_Level0_Cell *cell = (TreeView_Level0_Cell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TreeView_Level0_Cell" owner:self options:nil] lastObject];
            cell.frame = CGRectMake(0, 0, [dm getInstance].width, 48);
        }
        cell.delegate = self;
        cell.mNode = node;
        cell.mBtn_detail.userInteractionEnabled = NO;
        [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
        [cell setNeedsDisplay]; //重新描绘cell
        
        return cell;
    }else if(node.type == 1){//类型为1的cell
        TreeView_Level1_Cell *cell = (TreeView_Level1_Cell *)[tableView dequeueReusableCellWithIdentifier:indentifier1];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TreeView_Level1_Cell" owner:self options:nil] lastObject];
            cell.frame = CGRectMake(0, 0, [dm getInstance].width, 32);
        }
        cell.mNode = node;
//        cell.delegate = self;
        [self loadDataForTreeViewCell:cell with:node];
        [cell setNeedsDisplay];
        return cell;
    }else if(node.type == 2){//类型为2的cell
        TreeView_Level0_Cell *cell = (TreeView_Level0_Cell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TreeView_Level0_Cell" owner:self options:nil] lastObject];
            cell.frame = CGRectMake(0, 0, [dm getInstance].width, 48);
        }
        cell.delegate = self;
        cell.mNode = node;
        cell.mBtn_detail.userInteractionEnabled = NO;
        [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
        [cell setNeedsDisplay]; //重新描绘cell
        
        return cell;
    }else if(node.type == 3){//类型为2的cell
        TreeView_Level0_Cell *cell = (TreeView_Level0_Cell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TreeView_Level0_Cell" owner:self options:nil] lastObject];
            cell.frame = CGRectMake(0, 0, [dm getInstance].width, 48);
        }
        //        cell.delegate = self;
        cell.mNode = node;
        cell.mBtn_detail.userInteractionEnabled = NO;
        [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
        [cell setNeedsDisplay]; //重新描绘cell
        
        return cell;
    }
    return 0;
}

/*---------------------------------------
 为不同类型cell填充数据
 --------------------------------------- */
-(void) loadDataForTreeViewCell:(UITableViewCell*)cell with:(TreeView_node*)node{
    if(node.type == 0||node.type == 1){
        TreeView_Level0_Cell *cell0 = (TreeView_Level0_Cell*)cell;
        NewWorkTree_model *nodeData = node.nodeData;
        cell0.mLab_name.text = nodeData.mStr_name;
        cell0.mImgV_head.hidden = NO;
        cell0.mBtn_detail.hidden = YES;
        if (node.type == 0) {
            cell0.mLab_name.textColor = [UIColor colorWithRed:255/255.0 green:103/255.0 blue:1/255.0 alpha:1];
            cell0.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        }else{
            cell0.mLab_name.textColor = [UIColor colorWithRed:41/255.0 green:41/255.0 blue:41/255.0 alpha:1];
            cell0.backgroundColor = [UIColor whiteColor];
        }
        
        if (node.isExpanded) {
            [cell0.mImgV_head setImage:[UIImage imageNamed:@"bTri"]];
            [cell0.mImgV_open_close setImage:[UIImage imageNamed:@"plus"]];
        } else {
            [cell0.mImgV_head setImage:[UIImage imageNamed:@"rTri"]];
            [cell0.mImgV_open_close setImage:[UIImage imageNamed:@"add"]];
        }
        //定位
        CGSize nameSize = [nodeData.mStr_name sizeWithFont:[UIFont systemFontOfSize:15]];
        cell0.mImgV_head.frame = CGRectMake(10*node.type+10, 20, 10, 10);
        cell0.mLab_name.frame = CGRectMake(cell0.mImgV_head.frame.origin.x+10, cell0.mLab_name.frame.origin.y, nameSize.width, cell0.mLab_name.frame.size.height);
        cell0.mImgV_open_close.frame = CGRectMake(cell0.mLab_name.frame.origin.x+nameSize.width, 20, 10, 10);
        cell0.mImgV_number.hidden = YES;
        cell0.mLab_number.hidden = YES;
        cell0.mBtn_detail.hidden = YES;
        cell0.mImgV_open_close.hidden = NO;
        
        cell0.mBtn_reverse.hidden = NO;
        cell0.mBtn_all.hidden = NO;
        cell0.mBtn_reverse.frame = CGRectMake([dm getInstance].width-40, 0, 40, 48);
        [cell0.mBtn_reverse setTitle:@"反选" forState:UIControlStateNormal];
        cell0.mBtn_all.frame = CGRectMake(cell0.mBtn_reverse.frame.origin.x-78, 9, 68, 30);
        if (node.mInt_select == 0) {
            [cell0.mBtn_all setBackgroundImage:[UIImage imageNamed:@"newWork_reverseSelect"] forState:UIControlStateNormal];
        }else{
            [cell0.mBtn_all setBackgroundImage:[UIImage imageNamed:@"newWork_allSelect"] forState:UIControlStateNormal];
        }
        
    }
    
    else if(node.type == 1){
//        TreeView_Level1_Cell *cell1 = (TreeView_Level1_Cell*)cell;
//        TreeView_Level1_Model *nodeData = node.nodeData;
//        cell1.mLab_name.text = nodeData.mStr_name;
//        [cell1.mBtn_detail setImage:[UIImage imageNamed:nodeData.mStr_img_detail] forState:UIControlStateNormal];
//        cell1.mBtn_detail.frame = CGRectMake([dm getInstance].width-44-10, 0, 44, 32);
//        cell1.mBtn_detail.tag = node.readflag;
//        if (node.isExpanded) {
//            [cell1.mImgV_open_close setImage:[UIImage imageNamed:@"root_open"]];
//        } else {
//            [cell1.mImgV_open_close setImage:[UIImage imageNamed:nodeData.mStr_img_open_close]];
//        }
//        //定位
//        CGSize nameSize = [nodeData.mStr_name sizeWithFont:[UIFont systemFontOfSize:15]];
//        cell1.mLab_name.frame = CGRectMake(cell1.mLab_name.frame.origin.x, cell1.mLab_name.frame.origin.y, nameSize.width, cell1.mLab_name.frame.size.height);
//        if (nodeData.mInt_number>0) {
//            cell1.mImgV_number.hidden = NO;
//            cell1.mLab_number.hidden = NO;
//            UIImage *img = [UIImage imageNamed:@"root_dian"];
//            CGSize numSize = [[NSString stringWithFormat:@"%d",nodeData.mInt_number] sizeWithFont:[UIFont systemFontOfSize:16]];
//            cell1.mImgV_number.frame = CGRectMake(cell1.mLab_name.frame.origin.x+cell1.mLab_name.frame.size.width, (32-img.size.height)/2, numSize.width+5, img.size.height);
//            [cell1.mImgV_number setImage:img];
//            cell1.mLab_number.frame = cell1.mImgV_number.frame;
//            cell1.mLab_number.text = [NSString stringWithFormat:@"%d",nodeData.mInt_number];
//        }else{
//            cell1.mImgV_number.hidden = YES;
//            cell1.mLab_number.hidden = YES;
//        }
    }else if(node.type == 2){
        TreeView_Level0_Cell *cell0 = (TreeView_Level0_Cell*)cell;
        NewWorkTree_model *nodeData = node.nodeData;
        cell0.mLab_name.text = nodeData.mStr_name;
        cell0.mImgV_head.hidden = NO;
        cell0.mBtn_detail.hidden = YES;
        cell0.mLab_name.textColor = [UIColor colorWithRed:41/255.0 green:41/255.0 blue:41/255.0 alpha:1];
        cell0.backgroundColor = [UIColor whiteColor];
        
        if (node.isExpanded) {
            [cell0.mImgV_head setImage:[UIImage imageNamed:@"bTri"]];
            [cell0.mImgV_open_close setImage:[UIImage imageNamed:@"plus"]];
        } else {
            [cell0.mImgV_head setImage:[UIImage imageNamed:@"rTri"]];
            [cell0.mImgV_open_close setImage:[UIImage imageNamed:@"add"]];
        }
        //定位
        CGSize nameSize = [nodeData.mStr_name sizeWithFont:[UIFont systemFontOfSize:15]];
        cell0.mImgV_head.frame = CGRectMake(10*node.type+10, 20, 10, 10);
        cell0.mLab_name.frame = CGRectMake(cell0.mImgV_head.frame.origin.x+10, cell0.mLab_name.frame.origin.y, nameSize.width, cell0.mLab_name.frame.size.height);
        cell0.mImgV_open_close.frame = CGRectMake(cell0.mLab_name.frame.origin.x+nameSize.width, 20, 10, 10);
        cell0.mImgV_number.hidden = YES;
        cell0.mLab_number.hidden = YES;
        cell0.mBtn_detail.hidden = YES;
        cell0.mImgV_open_close.hidden = NO;
        
        cell0.mBtn_reverse.hidden = NO;
        cell0.mBtn_all.hidden = NO;
        cell0.mBtn_reverse.frame = CGRectMake([dm getInstance].width-40, 0, 40, 48);
        [cell0.mBtn_reverse setTitle:@"反选" forState:UIControlStateNormal];
        cell0.mBtn_all.frame = CGRectMake(cell0.mBtn_reverse.frame.origin.x-78, 9, 68, 30);
        if (node.mInt_select == 0) {
            [cell0.mBtn_all setBackgroundImage:[UIImage imageNamed:@"newWork_reverseSelect"] forState:UIControlStateNormal];
        }else{
            [cell0.mBtn_all setBackgroundImage:[UIImage imageNamed:@"newWork_allSelect"] forState:UIControlStateNormal];
        }
    }else if(node.type == 3){
        TreeView_Level0_Cell *cell0 = (TreeView_Level0_Cell*)cell;
        NewWorkTree_model *nodeData = node.nodeData;
        cell0.mLab_name.text = nodeData.mStr_name;
        cell0.mImgV_head.hidden = NO;
        cell0.mBtn_detail.hidden = YES;
        cell0.mBtn_reverse.hidden = YES;
        cell0.mBtn_all.hidden = YES;
        cell0.mLab_name.textColor = [UIColor colorWithRed:41/255.0 green:41/255.0 blue:41/255.0 alpha:1];
        cell0.backgroundColor = [UIColor whiteColor];
        if (node.mInt_select == 1) {
            [cell0.mImgV_head setImage:[UIImage imageNamed:@"selected"]];
        } else {
            [cell0.mImgV_head setImage:[UIImage imageNamed:@"blank"]];
        }
        //定位
        CGSize nameSize = [nodeData.mStr_name sizeWithFont:[UIFont systemFontOfSize:15]];
        cell0.mImgV_head.frame = CGRectMake(10*node.type+10, 20, 10, 10);
        cell0.mLab_name.frame = CGRectMake(cell0.mImgV_head.frame.origin.x+20, cell0.mLab_name.frame.origin.y, nameSize.width, cell0.mLab_name.frame.size.height);
        cell0.mImgV_open_close.frame = CGRectMake(cell0.mLab_name.frame.origin.x+nameSize.width, 20, 10, 10);
        cell0.mImgV_number.hidden = YES;
        cell0.mLab_number.hidden = YES;
        cell0.mBtn_detail.hidden = YES;
        cell0.mImgV_open_close.hidden = YES;
    }
}

/*---------------------------------------
 cell高度默认为50
 --------------------------------------- */
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    TreeView_node *node = [mArr_display objectAtIndex:indexPath.row];
    if(node.type == 0||node.type == 1||node.type == 2){//类型为0的cell
        return 48;
    }else if(node.type == 1){//类型为1的cell
        return 32;
    }else if(node.type == 2){//类型为2的cell
        return 65;
    }else if(node.type == 3){//类型为3的cell
        return 48;
    }
    return 0;
}

/*---------------------------------------
 处理cell选中事件，需要自定义的部分
 --------------------------------------- */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TreeView_node *node = [self.mArr_display objectAtIndex:indexPath.row];
    
    if(node.type == 3){
        if (node.mInt_select == 0) {
            node.mInt_select = 1;
        }else{
            node.mInt_select = 0;
        }
        [self selectedNowBtn:node.nodeFlag];
        [self.mTableV_work reloadData];
    }
    else {
        [self reloadDataForDisplayArrayChangeAt:node.flag];//修改cell的状态(关闭或打开)
    }
}

//获取当前单位中的人员
-(void)sendRequest_member2:(myUnit *)tempUnit flag:(int)a{//a==0是获取老师的单位，a==1获取老师的执教班级
    //获取当前单位的人员数组
    if ([dm getInstance].uType == 1||[dm getInstance].uType == 2) {
//        if (a==0) {
            [[LoginSendHttp getInstance] login_GetUnitRevicer:tempUnit.TabID Flag:tempUnit.flag];
//        }else{
//            [[LoginSendHttp getInstance] login_GetUnitClassRevicer:tempUnit.TabID Flag:tempUnit.flag];
//        }
    }else{
        [[LoginSendHttp getInstance] login_GetUnitClassRevicer:tempUnit.TabID Flag:tempUnit.flag];
    }
//    self.mLab_currentUnit.text = tempUnit.UintName;
    
}


/*---------------------------------------
 初始化将要显示的cell的数据
 --------------------------------------- */
-(void) reloadDataForDisplayArray{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];

    for (TreeView_node *node in self.mArr_sumData) {
        NewWorkTree_model *temp2 = node.nodeData;
        if ([temp2.mStr_name isEqual:@"所有班级"]) {
            
        }else{
            [tmp addObject:node];
            if(node.isExpanded){
                for(TreeView_node *node2 in node.sonNodes){
                    [tmp addObject:node2];
                    if(node2.isExpanded){
                        for(TreeView_node *node3 in node2.sonNodes){
                            [tmp addObject:node3];
                            if(node3.isExpanded){
                                for(TreeView_node *node4 in node3.sonNodes){
                                    [tmp addObject:node4];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    self.mArr_display = [NSArray arrayWithArray:tmp];
    [self.mTableV_work reloadData];
    self.mTableV_work.frame = CGRectMake(0, self.mTableV_work.frame.origin.y, [dm getInstance].width, self.mTableV_work.contentSize.height);
    self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, self.mTableV_work.frame.origin.y+self.mTableV_work.contentSize.height);
}

/*---------------------------------------
 修改cell的状态(关闭或打开)
 --------------------------------------- */
-(void) reloadDataForDisplayArrayChangeAt:(NSString *)row{
    for (TreeView_node *node in self.mArr_sumData) {
        if([node.flag isEqual:row]){
            node.isExpanded = !node.isExpanded;
        }
        for(TreeView_node *node2 in node.sonNodes){
            if([node2.flag isEqual:row]){
                node2.isExpanded = !node2.isExpanded;
            }
            for(TreeView_node *node3 in node2.sonNodes){
                if([node3.flag isEqual:row]){
                    node3.isExpanded = !node3.isExpanded;
                }
            }
        }
    }
    [self reloadDataForDisplayArray];
}

//全选
-(void)selectedmBtn_all:(TreeView_Level0_Cell *)cell{
    NSString *flag = cell.mNode.flag;
    for (TreeView_node *node in self.mArr_sumData) {
        if([node.flag isEqual:flag]){
            node.mInt_select = 1;
            for(TreeView_node *node2 in node.sonNodes){
                node2.mInt_select = 1;
                for(TreeView_node *node3 in node2.sonNodes){
                    node3.mInt_select = 1;
                    for(TreeView_node *node4 in node3.sonNodes){
                        node4.mInt_select = 1;
                    }
                }
            }
        }else{
            for(TreeView_node *node2 in node.sonNodes){
                if([node2.flag isEqual:flag]){
                    node2.mInt_select = 1;
                    for(TreeView_node *node3 in node2.sonNodes){
                        node3.mInt_select = 1;
                        for(TreeView_node *node4 in node3.sonNodes){
                            node4.mInt_select = 1;
                        }
                    }
                }else{
                    for(TreeView_node *node3 in node2.sonNodes){
                         if([node3.flag isEqual:flag]){
                             node3.mInt_select = 1;
                             for(TreeView_node *node4 in node3.sonNodes){
                                 node4.mInt_select = 1;
                             }
                         }
                    }
                }
            }
        }
    }
//    [self selectAllBtn:self.mArr_sumData Flag:flag];
    [self selectedNowBtn:cell.mNode.nodeFlag];
    [self reloadDataForDisplayArray];
}

-(void)selectAllBtn:(NSArray *)array Flag:(NSString *)flag{
    for (TreeView_node *node in array) {
        if([node.flag isEqual:flag]){
            node.mInt_select = 1;
            [self selectAllBtn2:node.sonNodes];
        }else{
            [self selectAllBtn:node.sonNodes Flag:flag];
        }
    }
}

-(void)selectAllBtn2:(NSArray *)array{
    for(TreeView_node *node in array){
        node.mInt_select = 1;
        [self selectAllBtn2:node.sonNodes];
    }
}

//反选
-(void)selectedmBtn_reverse:(TreeView_Level0_Cell *)cell{
    NSString *flag = cell.mNode.flag;
    for (TreeView_node *node in self.mArr_sumData) {
        if([node.flag isEqual:flag]){
            for(TreeView_node *node2 in node.sonNodes){
//                [self reverseBtn:node2];
                for(TreeView_node *node3 in node2.sonNodes){
//                    [self reverseBtn:node3];
                    for(TreeView_node *node4 in node3.sonNodes){
                        [self reverseBtn:node4];
                    }
                }
            }
        }else{
            for(TreeView_node *node2 in node.sonNodes){
                if([node2.flag isEqual:flag]){
                    for(TreeView_node *node3 in node2.sonNodes){
//                        [self reverseBtn:node3];
                        for(TreeView_node *node4 in node3.sonNodes){
                            [self reverseBtn:node4];
                        }
                    }
                }else{
                    for(TreeView_node *node3 in node2.sonNodes){
                        if([node3.flag isEqual:flag]){
//                            node3.mInt_select = 0;
                            for(TreeView_node *node4 in node3.sonNodes){
                                [self reverseBtn:node4];
                            }
                        }
                    }
                }
            }
        }
    }
    
    if (cell.mNode.type==0&&cell.mNode.sonNodes.count==0) {
        if (cell.mNode.sonNodes.count==0) {
            if (cell.mNode.mInt_select == 0) {
                cell.mNode.mInt_select = 1;
            }else{
                cell.mNode.mInt_select = 0;
            }
        }
    }else{
        [self test:cell.mNode];
        [self selectedNowBtn:[NSString stringWithFormat:@"%@",cell.mNode.nodeFlag]];
        [self test:cell.mNode];
    }
    
    [self reloadDataForDisplayArray];
}

-(void)test:(TreeView_node *)node{
    if (node.type !=3) {
        int a=0;
        for (TreeView_node *node2 in node.sonNodes) {
            [self test:node2];
            if (node2.mInt_select == 0) {
                a++;
            }
        }
        if (a==0) {
            node.mInt_select = 1;
        }else{
            node.mInt_select = 0;
        }
    }
}

-(void)reverseBtn:(TreeView_node *)node{
    if (node.mInt_select == 0) {
        node.mInt_select = 1;
    }else{
        node.mInt_select = 0;
    }
}

//循环计算是否应该勾选状态
-(void)selectedNowBtn:(NSString *)nodeFlag{
    NSArray *array = [nodeFlag componentsSeparatedByString:@"-"];
    NSString *tempStr = [NSString stringWithFormat:@"%@-",[array objectAtIndex:0]];
    for (int i=1; i<array.count-1; i++) {
        tempStr = [NSString stringWithFormat:@"%@%@-",tempStr,[array objectAtIndex:i]];
    };
    int a=0;
    for (int i=0; i<self.mArr_display.count; i++) {
        TreeView_node *node = [self.mArr_display objectAtIndex:i];
        NSString *tempNodeStr = node.nodeFlag;
        NSRange range = [tempNodeStr rangeOfString:tempStr];//判断字符串是否包含
        if (range.length >0){//包含
            if (node.mInt_select == 0) {
                a++;
            }
        }
    }
    
    if (a>0) {//当前级别，没有全部勾选
        tempStr = [tempStr substringToIndex:([tempStr length]-1)];
        for (int i=0; i<self.mArr_display.count; i++) {
            
            TreeView_node *node = [self.mArr_display objectAtIndex:i];
            NSString *tempNodeStr = node.nodeFlag;
            if ([tempNodeStr isEqual:tempStr]) {
                node.mInt_select = 0;
            }
        }
        NSArray *array2 = [tempStr componentsSeparatedByString:@"-"];
        if (array2.count>1) {
            NSString *tempStr2 = [NSString stringWithFormat:@"%@",[array2 objectAtIndex:0]];
            for (int i=1; i<array2.count; i++) {
                tempStr2 = [NSString stringWithFormat:@"%@-%@",tempStr2,[array2 objectAtIndex:i]];
            }
            [self selectedNowBtn:tempStr2];
        }
    }else{
        tempStr = [tempStr substringToIndex:([tempStr length]-1)];
        for (int i=0; i<self.mArr_display.count; i++) {
            
            TreeView_node *node = [self.mArr_display objectAtIndex:i];
            NSString *tempNodeStr = node.nodeFlag;
            if ([tempNodeStr isEqual:tempStr]) {
                node.mInt_select = 1;
            }
        }
        NSArray *array2 = [tempStr componentsSeparatedByString:@"-"];
        if (array2.count>1) {
            NSString *tempStr2 = [NSString stringWithFormat:@"%@",[array2 objectAtIndex:0]];
            for (int i=1; i<array2.count; i++) {
                tempStr2 = [NSString stringWithFormat:@"%@-%@",tempStr2,[array2 objectAtIndex:i]];
            }
            [self selectedNowBtn:tempStr2];
        }
    }
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

-(void)noMore{
    sleep(1);
}

@end

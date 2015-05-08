//
//  WorkView.m
//  JiaoBao
//
//  Created by Zqw on 14-10-22.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "WorkView.h"
#import "Reachability.h"

@implementation WorkView
@synthesize mTableV_work,mBtn_new,mArr_display,mArr_sumData,mProgressV;

- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self) {
        // Initialization code
        //通知界面更新未读消息数量
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UnReadMsg" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnReadMsg) name:@"UnReadMsg" object:nil];
        //通知界面刷新消息cell
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UnReadMsgCell" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnReadMsgCell:) name:@"UnReadMsgCell" object:nil];
        //通知界面刷新消息cell头像
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UnReadMsgCellImg" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnReadMsgCellImg:) name:@"UnReadMsgCellImg" object:nil];
        self.frame = frame;
        self.mTableV_work = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-51)];
        self.mTableV_work.delegate = self;
        self.mTableV_work.dataSource = self;
        [self addSubview:self.mTableV_work];
        self.mBtn_new = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img_btn = [UIImage imageNamed:@"root_addBtn"];
        [self.mBtn_new setBackgroundImage:img_btn forState:UIControlStateNormal];
        self.mBtn_new.frame = CGRectMake(([dm getInstance].width-img_btn.size.width)/2, self.frame.size.height-51+(51-img_btn.size.height)/2, img_btn.size.width, img_btn.size.height);
        [self.mBtn_new setTitle:@"新建事务、发布通知" forState:UIControlStateNormal];
        [self.mBtn_new setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.mBtn_new addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mBtn_new];
        //添加数据
        [self addData];
        [self reloadDataForDisplayArray];//初始化将要显示的数据
        //加载提示框
        self.mProgressV = [[MBProgressHUD alloc]initWithView:self];
        [self addSubview:self.mProgressV];
        self.mProgressV.delegate = self;
    }
    return self;
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

- (void)loading {
    sleep(TIMEOUT);
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    self.mProgressV.labelText = @"加载超时";
    [self.mTableV_work headerEndRefreshing];
    [self.mTableV_work footerEndRefreshing];
    sleep(2);
}
-(void)noMore{
    sleep(1);
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//MBProgressHUD代理
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
//    [self.mProgressV removeFromSuperview];
//    self.mProgressV = nil;
}
-(void)clickBtn:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    D("点击新建事务、发布通知按钮");
    ForwardViewController *forward = [[ForwardViewController alloc] init];
    //forward.mStr_navName = @"新建事务";
    forward.mInt_forwardFlag = 1;
    forward.mInt_forwardAll = 2;
    forward.mInt_flag = 1;
    forward.mInt_all = 2;
    //forward.mInt_where = 0;
    [utils pushViewController:forward animated:YES];
}
-(void)UnReadMsg{
    NSString *temp = [NSString stringWithFormat:@"%d",[[dm getInstance].unReadMsg1 intValue] + [[dm getInstance].unReadMsg2 intValue]];
    D("tempCount -=== %@",temp);
    TreeView_node *node0 = [self.mArr_sumData objectAtIndex:0];
    ((TreeView_Level0_Model *)node0.nodeData).mInt_number = [temp intValue];
    TreeView_node *node6 = [node0.sonNodes objectAtIndex:0];
    ((TreeView_Level1_Model *)node6.nodeData).mInt_number = [[dm getInstance].unReadMsg1 intValue];
    TreeView_node *node7 = [node0.sonNodes objectAtIndex:1];
    ((TreeView_Level1_Model *)node7.nodeData).mInt_number = [[dm getInstance].unReadMsg2 intValue];
    
    [self reloadDataForDisplayArray];
}
//通知界面刷新消息cell头像
-(void)UnReadMsgCellImg:(NSNotification *)noti{
    [self.mTableV_work reloadData];
}
//通知界面刷新消息cell
-(void)UnReadMsgCell:(NSNotification *)noti{
    [self.mProgressV hide:YES];
    NSMutableDictionary *dic = noti.object;
    NSMutableArray *array = [dic valueForKey:@"array"];
    int tag = [[dic valueForKey:@"tag"] intValue];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (int i=0; i<array.count; i++) {
        UnReadMsg_model *unReadMsgModel = [array objectAtIndex:i];
        //第2根节点
        TreeView_node *node = [[TreeView_node alloc]init];
        node.nodeLevel = 2;
        node.type = 2;
        node.sonNodes = nil;
        node.isExpanded = FALSE;
        TreeView_Level2_Model *temp =[[TreeView_Level2_Model alloc]init];
        temp.mStr_name = unReadMsgModel.UserName;
        //若是回复我的，显示回复内容
        if (unReadMsgModel.MsgTabIDStr.length>0) {
            temp.mStr_img_detail = unReadMsgModel.FeeBackMsg;
        }else{
            temp.mStr_img_detail = unReadMsgModel.MsgContent;
        }
        
        temp.mStr_headImg = @"root_img";
        temp.mStr_time = unReadMsgModel.RecDate;
        temp.mStr_TabIDStr = unReadMsgModel.TabIDStr;
        temp.mStr_JiaoBaoHao = unReadMsgModel.JiaoBaoHao;
        temp.mStr_MsgTabIDStr = unReadMsgModel.MsgTabIDStr;
        node.nodeData = temp;
        [tempArr addObject:node];
    }
    if (tag == 6) {
        TreeView_node *node0 = [self.mArr_sumData objectAtIndex:0];
        TreeView_node *node6 = [node0.sonNodes objectAtIndex:0];
        node6.sonNodes = [NSMutableArray arrayWithArray:tempArr];
    }else if (tag == 8){
        TreeView_node *node1 = [self.mArr_sumData objectAtIndex:1];
        TreeView_node *node8 = [node1.sonNodes objectAtIndex:0];
        node8.sonNodes = [NSMutableArray arrayWithArray:tempArr];
    }else if (tag == 9){
        TreeView_node *node1 = [self.mArr_sumData objectAtIndex:1];
        TreeView_node *node9 = [node1.sonNodes objectAtIndex:1];
        node9.sonNodes = [NSMutableArray arrayWithArray:tempArr];
    }else if (tag == 2){
        TreeView_node *node2 = [self.mArr_sumData objectAtIndex:2];
        node2.sonNodes = [NSMutableArray arrayWithArray:tempArr];
    }else if (tag == 4){
        TreeView_node *node4 = [self.mArr_sumData objectAtIndex:4];
        node4.sonNodes = [NSMutableArray arrayWithArray:tempArr];
    }else if (tag == 7){
        TreeView_node *node0 = [self.mArr_sumData objectAtIndex:0];
        TreeView_node *node7 = [node0.sonNodes objectAtIndex:1];
        node7.sonNodes = [NSMutableArray arrayWithArray:tempArr];
    }
    [self reloadDataForDisplayArray];
}
//添加数据
-(void)addData{
    //第0根节点
    TreeView_node *node0 = [[TreeView_node alloc]init];
    node0.nodeLevel = 0;
    node0.type = 0;
    node0.sonNodes = nil;
    node0.isExpanded = FALSE;
    node0.readflag = 0;
    TreeView_Level0_Model *temp0 =[[TreeView_Level0_Model alloc]init];
    temp0.mStr_name = @"待处理信息";
    temp0.mStr_headImg = @"root_waitingProcess";
    temp0.mStr_img_detail = @"root_detail";
    temp0.mStr_img_open_close = @"root_close";
    temp0.mInt_number = 0;
    temp0.mInt_show = 1;
    node0.nodeData = temp0;
    
    TreeView_node *node1 = [[TreeView_node alloc]init];
    node1.nodeLevel = 0;
    node1.type = 0;
    node1.sonNodes = nil;
    node1.isExpanded = FALSE;
    node1.readflag = 1;
    TreeView_Level0_Model *temp1 =[[TreeView_Level0_Model alloc]init];
    temp1.mStr_name = @"已处理信息";
    temp1.mStr_headImg = @"root_processed";
    temp1.mStr_img_detail = @"root_detail";
    temp1.mStr_img_open_close = @"root_close";
    temp1.mInt_number = 0;
    temp1.mInt_show = 1;
    node1.nodeData = temp1;
    
    TreeView_node *node2 = [[TreeView_node alloc]init];
    node2.nodeLevel = 0;
    node2.type = 0;
    node2.sonNodes = nil;
    node2.isExpanded = FALSE;
    node2.readflag = 2;
    TreeView_Level0_Model *temp2 =[[TreeView_Level0_Model alloc]init];
    temp2.mStr_name = @"发出的信息";
    temp2.mStr_headImg = @"root_sendMsg";
    temp2.mStr_img_detail = @"root_detail";
    temp2.mStr_img_open_close = @"root_close";
    temp2.mInt_number = 0;
    temp2.mInt_show = 1;
    node2.nodeData = temp2;
    
    TreeView_node *node3 = [[TreeView_node alloc]init];
    node3.nodeLevel = 0;
    node3.type = 0;
    node3.sonNodes = nil;
    node3.isExpanded = FALSE;
    node3.readflag = 3;
    TreeView_Level0_Model *temp3 =[[TreeView_Level0_Model alloc]init];
    temp3.mStr_name = @"下发通知信息";
    temp3.mStr_headImg = @"root_sendNotice";
    temp3.mStr_img_detail = @"root_detail";
    temp3.mStr_img_open_close = @"root_close";
    temp3.mInt_number = 0;
    temp3.mInt_show = 0;
    node3.nodeData = temp3;
    
    TreeView_node *node4 = [[TreeView_node alloc]init];
    node4.nodeLevel = 0;
    node4.type = 0;
    node4.sonNodes = nil;
    node4.isExpanded = FALSE;
    node4.readflag = 4;
    TreeView_Level0_Model *temp4 =[[TreeView_Level0_Model alloc]init];
    temp4.mStr_name = @"转发上级通知";
    temp4.mStr_headImg = @"root_forwardNotice";
    temp4.mStr_img_detail = @"root_detail";
    temp4.mStr_img_open_close = @"root_close";
    temp4.mInt_number = 0;
    temp4.mInt_show = 1;
    node4.nodeData = temp4;
    
    TreeView_node *node5 = [[TreeView_node alloc]init];
    node5.nodeLevel = 0;
    node5.type = 0;
    node5.sonNodes = nil;
    node5.isExpanded = FALSE;
    node5.readflag = 5;
    TreeView_Level0_Model *temp5 =[[TreeView_Level0_Model alloc]init];
    temp5.mStr_name = @"短信直通车";
    temp5.mStr_headImg = @"root_SMS";
    temp5.mStr_img_detail = @"root_detail";
    temp5.mStr_img_open_close = @"root_close";
    temp5.mInt_number = 0;
    temp5.mInt_show = 0;
    node5.nodeData = temp5;
    
    //第1根节点
    TreeView_node *node6 = [[TreeView_node alloc]init];
    node6.nodeLevel = 1;
    node6.type = 1;
    node6.sonNodes = nil;
    node6.isExpanded = FALSE;
    node6.readflag = 6;
    TreeView_Level1_Model *temp6 =[[TreeView_Level1_Model alloc]init];
    temp6.mStr_name = @"发给我的";
    temp6.mStr_img_detail = @"root_detail";
    temp6.mStr_img_open_close = @"root_close";
    temp6.mInt_number = 0;
    node6.nodeData = temp6;
    
    TreeView_node *node7 = [[TreeView_node alloc]init];
    node7.nodeLevel = 1;
    node7.type = 1;
    node7.sonNodes = nil;
    node7.isExpanded = FALSE;
    node7.readflag = 7;
    TreeView_Level1_Model *temp7 =[[TreeView_Level1_Model alloc]init];
    temp7.mStr_name = @"回复我的";
    temp7.mStr_img_detail = @"root_detail";
    temp7.mStr_img_open_close = @"root_close";
    temp7.mInt_number = 0;
    node7.nodeData = temp7;
    
    TreeView_node *node8 = [[TreeView_node alloc]init];
    node8.nodeLevel = 1;
    node8.type = 1;
    node8.sonNodes = nil;
    node8.isExpanded = FALSE;
    node8.readflag = 8;
    TreeView_Level1_Model *temp8 =[[TreeView_Level1_Model alloc]init];
    temp8.mStr_name = @"未回复的";
    temp8.mStr_img_detail = @"root_detail";
    temp8.mStr_img_open_close = @"root_close";
    temp8.mInt_number = 0;
    node8.nodeData = temp8;
    
    TreeView_node *node9 = [[TreeView_node alloc]init];
    node9.nodeLevel = 1;
    node9.type = 1;
    node9.sonNodes = nil;
    node9.isExpanded = FALSE;
    node9.readflag = 3;
    node9.readflag = 9;
    TreeView_Level1_Model *temp9 =[[TreeView_Level1_Model alloc]init];
    temp9.mStr_name = @"已回复的";
    temp9.mStr_img_detail = @"root_detail";
    temp9.mStr_img_open_close = @"root_close";
    temp9.mInt_number = 0;
    node9.nodeData = temp9;
    
    //第2根节点
//    TreeView_node *node10 = [[TreeView_node alloc]init];
//    node10.nodeLevel = 2;
//    node10.type = 2;
//    node10.sonNodes = nil;
//    node10.isExpanded = FALSE;
//    TreeView_Level2_Model *temp10 =[[TreeView_Level2_Model alloc]init];
//    temp10.mStr_name = @"flywarrior";
//    temp10.mStr_img_detail = @"老是失眠怎么办啊";
//    temp10.mStr_headImg = @"root_SMS";
//    temp10.mStr_time = @"2014-10-25 10:00";
//    node10.nodeData = temp10;
//    
//    TreeView_node *node11 = [[TreeView_node alloc]init];
//    node11.nodeLevel = 2;
//    node11.type = 2;
//    node11.sonNodes = nil;
//    node11.isExpanded = FALSE;
//    TreeView_Level2_Model *temp11 =[[TreeView_Level2_Model alloc]init];
//    temp11.mStr_name = @"flywarrior2";
//    temp11.mStr_img_detail = @"用头用力撞下键盘就好了。";
//    temp11.mStr_headImg = @"root_SMS";
//    temp11.mStr_time = @"2014-10-25 10:01";
//    node11.nodeData = temp11;
    
    //装载数据
//    node6.sonNodes = [NSMutableArray arrayWithObjects:node10, nil];
//    node2.sonNodes = [NSMutableArray arrayWithObjects:node11, nil];
    node0.sonNodes = [NSMutableArray arrayWithObjects:node6,node7,nil];
    node1.sonNodes = [NSMutableArray arrayWithObjects:node8,node9,nil];
    self.mArr_sumData = [NSMutableArray arrayWithObjects:node0,node1,node2,node3,node4,node5, nil];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_display.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"TreeView_Level0_Cell";
    static NSString *indentifier1 = @"TreeView_Level1_Cell";
    static NSString *indentifier2 = @"TreeView_Level2_Cell";
    TreeView_node *node = [mArr_display objectAtIndex:indexPath.row];
    if(node.type == 0){//类型为0的cell
        TreeView_Level0_Cell *cell = (TreeView_Level0_Cell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TreeView_Level0_Cell" owner:self options:nil] lastObject];
            cell.frame = CGRectMake(0, 0, [dm getInstance].width, 48);
        }
        cell.delegate = self;
        cell.mNode = node;
        if (node.readflag == 0||node.readflag == 1) {
            cell.mBtn_detail.userInteractionEnabled = NO;
        } else {
            cell.mBtn_detail.userInteractionEnabled = YES;
        }
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
        cell.delegate = self;
        [self loadDataForTreeViewCell:cell with:node];
        [cell setNeedsDisplay];
        return cell;
    }else{//类型为2的cell
        TreeView_Level2_Cell *cell = (TreeView_Level2_Cell *)[tableView dequeueReusableCellWithIdentifier:indentifier2];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TreeView_Level2_Cell" owner:self options:nil] lastObject];
            cell.frame = CGRectMake(0, 0, [dm getInstance].width, 65);
        }
        cell.mNode = node;
        [self loadDataForTreeViewCell:cell with:node];
        [cell setNeedsDisplay];
        return cell;
    }
    return 0;
}

/*---------------------------------------
 为不同类型cell填充数据
 --------------------------------------- */
-(void) loadDataForTreeViewCell:(UITableViewCell*)cell with:(TreeView_node*)node{
    if(node.type == 0){
        TreeView_Level0_Cell *cell0 = (TreeView_Level0_Cell*)cell;
        TreeView_Level0_Model *nodeData = node.nodeData;
        cell0.mLab_name.text = nodeData.mStr_name;
        //本地图片
        [cell0.mImgV_head setImage:[UIImage imageNamed:nodeData.mStr_headImg]];
        [cell0.mBtn_detail setImage:[UIImage imageNamed:nodeData.mStr_img_detail] forState:UIControlStateNormal];
        cell0.mBtn_detail.frame = CGRectMake([dm getInstance].width-44-10, 0, 44, 48);
        cell0.mBtn_detail.tag = node.readflag;
        if (node.isExpanded) {
            [cell0.mImgV_open_close setImage:[UIImage imageNamed:@"root_open"]];
        } else {
            [cell0.mImgV_open_close setImage:[UIImage imageNamed:nodeData.mStr_img_open_close]];
        }
        //定位
        CGSize nameSize = [nodeData.mStr_name sizeWithFont:[UIFont systemFontOfSize:15]];
        cell0.mLab_name.frame = CGRectMake(cell0.mLab_name.frame.origin.x, cell0.mLab_name.frame.origin.y, nameSize.width, cell0.mLab_name.frame.size.height);
        if (nodeData.mInt_number>0) {
            cell0.mImgV_number.hidden = NO;
            cell0.mLab_number.hidden = NO;
            UIImage *img = [UIImage imageNamed:@"root_dian"];
            CGSize numSize = [[NSString stringWithFormat:@"%d",nodeData.mInt_number] sizeWithFont:[UIFont systemFontOfSize:16]];
            cell0.mImgV_number.frame = CGRectMake(cell0.mLab_name.frame.origin.x+cell0.mLab_name.frame.size.width, (48-img.size.height)/2+2, numSize.width+5, img.size.height);
            [cell0.mImgV_number setImage:img];
            cell0.mLab_number.frame = cell0.mImgV_number.frame;
            cell0.mLab_number.text = [NSString stringWithFormat:@"%d",nodeData.mInt_number];
        }else{
            cell0.mImgV_number.hidden = YES;
            cell0.mLab_number.hidden = YES;
        }
        //是否显示详情按钮
        if (nodeData.mInt_show == 1) {
            cell0.mBtn_detail.hidden = NO;
            cell0.mImgV_open_close.hidden = NO;
        }else{
            cell0.mBtn_detail.hidden = YES;
            cell0.mImgV_open_close.hidden = YES;
        }
    }
    
    else if(node.type == 1){
        TreeView_Level1_Cell *cell1 = (TreeView_Level1_Cell*)cell;
        TreeView_Level1_Model *nodeData = node.nodeData;
        cell1.mLab_name.text = nodeData.mStr_name;
        [cell1.mBtn_detail setImage:[UIImage imageNamed:nodeData.mStr_img_detail] forState:UIControlStateNormal];
        cell1.mBtn_detail.frame = CGRectMake([dm getInstance].width-44-10, 0, 44, 32);
        cell1.mBtn_detail.tag = node.readflag;
        if (node.isExpanded) {
            [cell1.mImgV_open_close setImage:[UIImage imageNamed:@"root_open"]];
        } else {
            [cell1.mImgV_open_close setImage:[UIImage imageNamed:nodeData.mStr_img_open_close]];
        }
        //定位
        CGSize nameSize = [nodeData.mStr_name sizeWithFont:[UIFont systemFontOfSize:15]];
        cell1.mLab_name.frame = CGRectMake(cell1.mLab_name.frame.origin.x, cell1.mLab_name.frame.origin.y, nameSize.width, cell1.mLab_name.frame.size.height);
        if (nodeData.mInt_number>0) {
            cell1.mImgV_number.hidden = NO;
            cell1.mLab_number.hidden = NO;
            UIImage *img = [UIImage imageNamed:@"root_dian"];
            CGSize numSize = [[NSString stringWithFormat:@"%d",nodeData.mInt_number] sizeWithFont:[UIFont systemFontOfSize:16]];
            cell1.mImgV_number.frame = CGRectMake(cell1.mLab_name.frame.origin.x+cell1.mLab_name.frame.size.width, (32-img.size.height)/2, numSize.width+5, img.size.height);
            [cell1.mImgV_number setImage:img];
            cell1.mLab_number.frame = cell1.mImgV_number.frame;
            cell1.mLab_number.text = [NSString stringWithFormat:@"%d",nodeData.mInt_number];
        }else{
            cell1.mImgV_number.hidden = YES;
            cell1.mLab_number.hidden = YES;
        }
    }else{
        TreeView_Level2_Cell *cell2 = (TreeView_Level2_Cell*)cell;
        TreeView_Level2_Model *nodeData = node.nodeData;
        cell2.mLab_name.text = nodeData.mStr_name;
        cell2.mLab_detail.text = nodeData.mStr_img_detail;
        cell2.mLab_time.text = nodeData.mStr_time;
        cell2.mLab_time.frame = CGRectMake([dm getInstance].width-cell2.mLab_time.frame.size.width-20, cell2.mLab_time.frame.origin.y, cell2.mLab_time.frame.size.width, cell2.mLab_time.frame.size.height);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",nodeData.mStr_JiaoBaoHao]];
        UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
        if (img.size.width>0) {
            [cell2.mImgV_head setImage:img];
        }else{
            [cell2.mImgV_head setImage:[UIImage imageNamed:nodeData.mStr_headImg]];
        }
    }
}

/*---------------------------------------
 cell高度默认为50
 --------------------------------------- */
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    TreeView_node *node = [mArr_display objectAtIndex:indexPath.row];
    if(node.type == 0){//类型为0的cell
        return 48;
    }else if(node.type == 1){//类型为1的cell
        return 32;
    }else if(node.type == 2){//类型为2的cell
        return 65;
    }
    return 0;
}

/*---------------------------------------
 处理cell选中事件，需要自定义的部分
 --------------------------------------- */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TreeView_node *node = [self.mArr_display objectAtIndex:indexPath.row];
    
    D("indexPath.row-== %ld,%d,%d",(long)indexPath.row,node.readflag,node.type);
    if(node.type == 2){
        TreeView_Level2_Model *nodeData = node.nodeData;
        MsgDetailViewController *msgDetailVC = [[MsgDetailViewController alloc] init];
        msgDetailVC.mModel_tree2 = nodeData;
        [utils pushViewController:msgDetailVC animated:YES];
    }
    else {
        //检查当前网络是否可用
        if ([self checkNetWork]) {
        return;
    }
        [self reloadDataForDisplayArrayChangeAt:node.readflag];//修改cell的状态(关闭或打开)
        if ((node.readflag == 6||node.readflag == 7||node.readflag == 8||node.readflag == 9||node.readflag == 4)&&node.isExpanded) {
            D("111111111");
            //获取发给我的待处理信息
            [[LoginSendHttp getInstance] wait_unReadMsgWithTag:node.readflag page:@"1"];
            self.mProgressV.labelText = @"加载中...";
            self.mProgressV.mode = MBProgressHUDModeIndeterminate;
            [self.mProgressV show:YES];
            [self.mProgressV showWhileExecuting:@selector(loading) onTarget:self withObject:nil animated:YES];
        }else if (node.readflag == 2&&node.isExpanded){//获取自己发出的信息
            [[LoginSendHttp getInstance] getMyselfSendMsgWithPage:@"1"];
            self.mProgressV.labelText = @"加载中...";
            self.mProgressV.mode = MBProgressHUDModeIndeterminate;
            [self.mProgressV show:YES];
            [self.mProgressV showWhileExecuting:@selector(loading) onTarget:self withObject:nil animated:YES];
        }else if (node.readflag == 3){
            ForwardViewController *forward = [[ForwardViewController alloc] init];
            //forward.mStr_navName = @"下发通知";
            forward.mInt_forwardFlag = 1;
            forward.mInt_forwardAll = 1;
            forward.mInt_flag = 1;
            forward.mInt_all = 1;
            //forward.mInt_where = 1;
            [utils pushViewController:forward animated:YES];
        }else if (node.readflag == 5){
            ForwardViewController *forward = [[ForwardViewController alloc] init];
            //forward.mStr_navName = @"短信直通车";
            forward.mInt_forwardFlag = 2;
            forward.mInt_forwardAll = 2;
            forward.mInt_flag = 2;
            forward.mInt_all = 2;
            //forward.mInt_where = 2;
            [utils pushViewController:forward animated:YES];
        }
//        if (node.type == 0) {
//            TreeView_Level0_Cell *cell = (TreeView_Level0_Cell*)[tableView cellForRowAtIndexPath:indexPath];
//            if(cell.mNode.isExpanded ){
//                [self rotateArrow:cell with:M_PI_2];
//            }else{
//                [self rotateArrow:cell with:0];
//            }
//        } else if (node.type == 1){
//            TreeView_Level1_Cell *cell1 = (TreeView_Level1_Cell*)[tableView cellForRowAtIndexPath:indexPath];
//            if(cell1.mNode.isExpanded ){
//                [self rotateArrow1:cell1 with:M_PI_2];
//            }else{
//                [self rotateArrow1:cell1 with:0];
//            }
//        }
    }
}

/*---------------------------------------
 旋转箭头图标
 --------------------------------------- */
//-(void) rotateArrow:(TreeView_Level0_Cell*) cell with:(double)degree{
//    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//        cell.mImgV_open_close.layer.transform = CATransform3DMakeRotation(degree, 0, 0, 1);
//    } completion:NULL];
//}
//-(void) rotateArrow1:(TreeView_Level1_Cell*) cell with:(double)degree{
//    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//        cell.mImgV_open_close.layer.transform = CATransform3DMakeRotation(degree, 0, 0, 1);
//    } completion:NULL];
//}

/*---------------------------------------
 初始化将要显示的cell的数据
 --------------------------------------- */
-(void) reloadDataForDisplayArray{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    for (TreeView_node *node in self.mArr_sumData) {
        [tmp addObject:node];
        if(node.isExpanded){
            for(TreeView_node *node2 in node.sonNodes){
                [tmp addObject:node2];
                if(node2.isExpanded){
                    for(TreeView_node *node3 in node2.sonNodes){
                        [tmp addObject:node3];
                    }
                }
            }
        }
    }
    self.mArr_display = [NSArray arrayWithArray:tmp];
    [self.mTableV_work reloadData];
}

/*---------------------------------------
 修改cell的状态(关闭或打开)
 --------------------------------------- */
-(void) reloadDataForDisplayArrayChangeAt:(NSInteger)row{
    for (TreeView_node *node in self.mArr_sumData) {
        if(node.readflag == row){
            node.isExpanded = !node.isExpanded;
        }
        for(TreeView_node *node2 in node.sonNodes){
            if(node2.readflag == row){
                node2.isExpanded = !node2.isExpanded;
            }
        }
    }
    [self reloadDataForDisplayArray];
}
//在cell0中，点击详情按钮
-(void)selectedMoreBtn0:(TreeView_Level0_Cell *)cell{
    D("在cell0中，点击详情按钮");
    int a = (int)cell.mBtn_detail.tag;
    //跳转到详情列表界面
    [self gotoWorkListDetailVC:a];
}
//在cell1中，点击详情按钮
-(void)selectedMoreBtn1:(TreeView_Level1_Cell *)cell{
    D("在cell1中，点击详情按钮");
    int a = (int)cell.mBtn_detail.tag;
    //跳转到详情列表界面
    [self gotoWorkListDetailVC:a];
}
//跳转到详情列表界面
-(void)gotoWorkListDetailVC:(int)tag{
    WorkDetailListViewController *work = [[WorkDetailListViewController alloc] init];
    work.mInt_tag = tag;
    if (tag == 2) {//发出的信息
        work.mStr_navName = @"发出的信息";
    } else if (tag == 4){//转发上级
        work.mStr_navName = @"上级通知";
    }else if (tag == 6){//发给我的
        work.mStr_navName = @"待处理发给我的信息";
    }else if (tag == 7){//回复我的
        work.mStr_navName = @"待处理回复我的信息";
    }else if (tag == 8){//未回复的
        work.mStr_navName = @"已处理未回复的信息";
    }else if (tag == 9){//已回复的
        work.mStr_navName = @"已处理已回复的信息";
    }
    work.mInt_page = 1;
    [utils pushViewController:work animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

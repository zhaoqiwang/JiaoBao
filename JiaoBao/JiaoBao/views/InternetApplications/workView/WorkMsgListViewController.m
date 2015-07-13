//
//  WorkMsgListViewController.m
//  JiaoBao
//
//  Created by Zqw on 15-2-10.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "WorkMsgListViewController.h"
#import "Reachability.h"
#import "ReSendMsgViewController.h"
#import "MobClick.h"
#import "UIImageView+WebCache.h"
@interface WorkMsgListViewController ()

@end

@implementation WorkMsgListViewController
@synthesize mBtn_send,mTableV_detail,mTextF_text,mView_text,mArr_list,mNav_navgationBar,mArr_feeback,mArr_msg,mInt_down,mInt_up,mStr_lastID,mStr_name,mStr_tableID,mInt_page,mArr_attList,mInt_file,mInt_flag,mInt_our,mInt_msg,mArr_readList,mStr_flag,mArr_photos,mProgressV;

-(instancetype)init{
    self = [super init];
    self.mArr_list = [[NSMutableArray alloc] init];
    self.mArr_msg = [[NSMutableArray alloc] init];
    self.mArr_feeback = [[NSMutableArray alloc] init];
    self.mArr_attList = [[NSMutableArray alloc] init];
    self.mArr_readList = [[NSMutableArray alloc] init];
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:UMMESSAGE];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    //取单个用户发给我消息列表，new
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SendToMeMsgList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SendToMeMsgList:) name:@"SendToMeMsgList" object:nil];
    //获取我发送的消息列表
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetMySendMsgList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetMySendMsgList:) name:@"GetMySendMsgList" object:nil];
    //通知界面刷新信息详情
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MsgDetail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MsgDetail:) name:@"MsgDetail" object:nil];
    //键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    //通知信息详情界面，更新下载文件的进度条
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loadingProgress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingProgress:) name:@"loadingProgress" object:nil];
    //通知信息详情界面回复是否成功
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addFeeBack" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFeeBack:) name:@"addFeeBack" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:UMMESSAGE];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    // Do any additional setup after loading the view from its nib.
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_name];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    self.mTableV_detail.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height+self.mNav_navgationBar.frame.origin.y, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height-51);
    //添加表格的下拉刷新
    self.mTableV_detail.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mTableV_detail.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    if (self.mInt_flag == 1) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 30)];
        label.font = [UIFont systemFontOfSize:13];
        label.text = @"                              下拉加载更多";
        label.textAlignment = NSTextAlignmentLeft;
        self.mTableV_detail.tableHeaderView = label;
        [self.mTableV_detail addHeaderWithTarget:self action:@selector(headerRereshing)];
        self.mTableV_detail.headerPullToRefreshText = @"下拉刷新";
        self.mTableV_detail.headerReleaseToRefreshText = @"松开后刷新";
        self.mTableV_detail.headerRefreshingText = @"正在刷新...";
    }
    else
    {
        self.mTableV_detail.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height+self.mNav_navgationBar.frame.origin.y, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height-51);
        self.mTableV_detail.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 10)];

        self.dropDownLabel.frame = CGRectZero;
        
    }
    
    //输入View坐标
    self.mView_text.frame = CGRectMake(0, [dm getInstance].height-51, [dm getInstance].width, 51);
    //输入框
    self.mTextF_text.frame = CGRectMake(15, 10, [dm getInstance].width-15-70, 51-20);
    self.mTextF_text.delegate = self;
    self.mTextF_text.returnKeyType = UIReturnKeyDone;//return键的类型
    //发送按钮
    self.mBtn_send.frame = CGRectMake([dm getInstance].width-65, 0, 60, 51);
    [self.mBtn_send addTarget:self action:@selector(clickSendBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.mProgressV = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.mProgressV];
    self.mProgressV.delegate = self;
    
    [[LoginSendHttp getInstance] msgDetailwithUID:self.mStr_tableID page:1 feeBack:self.mStr_tableID ReadFlag:self.mStr_flag];
    [MBProgressHUD showMessage:@"" toView:self.view];
}

//通知界面刷新信息详情
-(void)MsgDetail:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    [self.mTableV_detail headerEndRefreshing];
    [self.mTableV_detail footerEndRefreshing];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        NSMutableArray *tempArr = [dic valueForKey:@"array"];
        if (self.mInt_page > 1) {
            if (tempArr.count>0) {
                [self.mArr_feeback addObjectsFromArray:tempArr];
            }
        }else{
            self.mArr_feeback = [NSMutableArray arrayWithArray:tempArr];
        }
        //判断是否隐藏加载更多按钮
        if (tempArr.count==20) {
            [self.mTableV_detail addFooterWithTarget:self action:@selector(footerRereshing)];
            self.mTableV_detail.footerPullToRefreshText = @"上拉加载更多";
            self.mTableV_detail.footerReleaseToRefreshText = @"松开加载更多数据";
            self.mTableV_detail.footerRefreshingText = @"正在加载...";
        }else{
            [self.mTableV_detail removeFooter];
        }
        //加入内容列表为空，加入
        if (self.mArr_msg.count==0) {
            UnReadMsg_model *modelMsg = [dic valueForKey:@"model"];
            CommMsgListModel *model = [[CommMsgListModel alloc] init];
            model.TabIDStr = modelMsg.TabIDStr;
            model.MsgContent = modelMsg.MsgContent;
            model.RecDate = modelMsg.RecDate;
            model.UserName = modelMsg.UserName;
            model.JiaoBaoHao = modelMsg.JiaoBaoHao;
            model.NoReadCount = @"";
            model.NoReplyCount = @"";
            model.ReadFlag = @"";
            model.flag = @"0";
            [self.mArr_msg addObject:model];
            [self.mArr_attList addObjectsFromArray:modelMsg.arrayAttList];
            //阅读人员列表
            self.mArr_readList = [NSMutableArray arrayWithArray:modelMsg.arrayReaderList];
        }
        //定位
        [self addArray];
    }else{
        [MBProgressHUD showError:@"" toView:self.view];
    }
}

//取单个用户发给我消息列表
-(void)SendToMeMsgList:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    [self.mTableV_detail headerEndRefreshing];
    [self.mTableV_detail footerEndRefreshing];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag intValue] ==0) {//成功
        SendToMeUserListModel *model = [dic objectForKey:@"model"];
        D("lastID = %@",model.LastID);
        
        //[utils logDic:noti.object];
        if (model.LastID.length==0) {
            [self.mTableV_detail removeHeader];
            [self.dropDownLabel setFrame:CGRectZero];
            self.mTableV_detail.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height+10, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height-51);
        }
        self.mStr_lastID = model.LastID;
        
        //将值倒序插入
        if (model.CommMsgList.count>1) {
            if (self.mArr_msg.count==1) {
                for (int i=1; i<model.CommMsgList.count; i++) {
                    CommMsgListModel *modelTemp = [model.CommMsgList objectAtIndex:i];
                    [self.mArr_msg insertObject:modelTemp atIndex:0];
                }
            }else{
                for (int i=0; i<model.CommMsgList.count; i++) {
                    CommMsgListModel *modelTemp = [model.CommMsgList objectAtIndex:i];
                    [self.mArr_msg insertObject:modelTemp atIndex:0];
                }
            }
        }
        [self addArray];
    }else{
        [MBProgressHUD showError:@"获取失败" toView:self.view];
    }
}

-(void)GetMySendMsgList:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    [self.mTableV_detail headerEndRefreshing];
    [self.mTableV_detail footerEndRefreshing];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag intValue] ==0) {//成功
        NSMutableArray *array = [dic objectForKey:@"array"];
        if (array.count>1) {
            //将值倒序插入
            if (self.mArr_msg.count==1) {
                for (int i=1; i<array.count; i++) {
                    CommMsgListModel *modelTemp = [array objectAtIndex:i];
                    [self.mArr_msg insertObject:modelTemp atIndex:0];
                }
            }else{
                for (int i=0; i<array.count; i++) {
                    CommMsgListModel *modelTemp = [array objectAtIndex:i];
                    [self.mArr_msg insertObject:modelTemp atIndex:0];
                }
            }
        }
        
        if (array.count!=20) {
            [self.mTableV_detail removeHeader];
        }
        [self addArray];
    }else{
        [MBProgressHUD showError:@"获取失败" toView:self.view];
    }
}

-(void)addArray{
    [self.mArr_list removeAllObjects];
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,[self.mArr_msg count])];
    [self.mArr_list insertObjects:self.mArr_msg atIndexes:indexes];
    [self.mArr_list addObjectsFromArray:self.mArr_feeback];
    [self.mTableV_detail reloadData];
}

//检查当前网络是否可用
-(BOOL)checkNetWork{
    if([Reachability isEnableNetwork]==NO){
        [MBProgressHUD showError:NETWORKENABLE toView:self.view];
        return YES;
    }else{
        return NO;
    }
}

-(void)ProgressViewLoad{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    [MBProgressHUD showMessage:@"" toView:self.view];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    CommMsgListModel *model = [self.mArr_msg objectAtIndex:0];
//    self.mInt_index = 1;
    //取单个用户发给我消息列表 new
    self.mInt_msg = (int)self.mArr_msg.count/20+1;
    if (self.mInt_our == 1) {
        [[LoginSendHttp getInstance] login_GetMySendMsgList:@"20" Page:[NSString stringWithFormat:@"%d",self.mInt_msg] SendName:@"" sDate:@"" eDate:@""];
    }else if (self.mInt_our == 2){
        [[LoginSendHttp getInstance] login_SendToMeMsgList:@"20" Page:[NSString stringWithFormat:@"%d",self.mInt_msg] senderAccId:model.JiaoBaoHao sDate:@"" eDate:@"" readFlag:@"" lastId:self.mStr_lastID];
    }
    [self.dropDownLabel setFrame:CGRectZero];
    self.mTableV_detail.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height+self.mNav_navgationBar.frame.origin.y, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height-51);
    self.mTableV_detail.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 10)];
    [self ProgressViewLoad];
}
- (void)footerRereshing{
    //检查当前网络是否可用
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    D("点击查看更多按钮");
    if (self.mArr_feeback.count>=20) {
        self.mInt_page = (int)self.mArr_feeback.count/20+1;
        D("self.mint.page-====%lu %d",(unsigned long)self.mArr_feeback.count,self.mInt_page);
        CommMsgListModel *model = [self.mArr_msg objectAtIndex:self.mArr_msg.count-1];
        [[LoginSendHttp getInstance] msgDetailwithUID:model.TabIDStr page:self.mInt_page feeBack:@"" ReadFlag:self.mStr_flag];
        
        [MBProgressHUD showMessage:@"" toView:self.view];
    } else {
        [MBProgressHUD showError:@"没有更多了" toView:self.view];
    }
}

//点击发送按钮
-(void)clickSendBtn:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    D("点击发送按钮");
    [self.mTextF_text resignFirstResponder];
    if (self.mTextF_text.text.length==0) {
        [MBProgressHUD showError:@"请输入内容" toView:self.view];
        return;
    }
    [MobClick event:@"WorkMsgList_clickSendBtn" label:@""];

    CommMsgListModel *model = [self.mArr_msg objectAtIndex:self.mArr_msg.count-1];
    [[LoginSendHttp getInstance] addFeeBackWithUID:model.TabIDStr content:self.mTextF_text.text];
    [MBProgressHUD showMessage:@"发送中..." toView:self.view];
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_list.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"WorkMsgListCell";
    WorkMsgListCell *cell = (WorkMsgListCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WorkMsgListCell" owner:self options:nil] lastObject];
    }
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //判断要显示哪种类型的数据
    if (self.mArr_msg.count>indexPath.row) {
        CommMsgListModel *model = [self.mArr_list objectAtIndex:indexPath.row];
        [cell.mImgV_head sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,model.JiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//        //文件名
//        NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.JiaoBaoHao]];
//        UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
//        if (img.size.width>0) {
//            [cell.mImgV_head setImage:img];
//        }else{
//            [cell.mImgV_head setImage:[UIImage imageNamed:@"root_img"]];
//            //获取头像
//            [[ExchangeHttp getInstance] getUserInfoFace:model.JiaoBaoHao];
//        }
        cell.mImgV_head.frame = CGRectMake(10, 33, 40, 40);
        //姓名
        cell.mLab_name.hidden = YES;
        //时间
        CGSize timeSize = [[NSString stringWithFormat:@"%@",model.RecDate] sizeWithFont:[UIFont systemFontOfSize:12]];
        D("jkljkjk-====%@",model.JiaoBaoHao);
        cell.mLab_time.frame = CGRectMake(([dm getInstance].width-timeSize.width-20)/2, 0, 70, 20);
        cell.mLab_time.text = model.RecDate;
        cell.mLab_time.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        cell.mLab_time.backgroundColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1];
        //将图层的边框设置为圆脚
        cell.mLab_time.layer.cornerRadius = 2;
        cell.mLab_time.layer.masksToBounds = YES;
        //按钮
        cell.mBtn_work.hidden = NO;
        cell.mBtn_work.frame = CGRectMake([dm getInstance].width-55, 33, 50, 30);
        [cell.mBtn_work setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.mBtn_work.backgroundColor = [UIColor colorWithRed:5/255.0 green:164/255.0 blue:170/255.0 alpha:1];
        //将图层的边框设置为圆脚
        cell.mBtn_work.layer.cornerRadius = 5;
        cell.mBtn_work.layer.masksToBounds = YES;
        //内容
        CGFloat tempW;
        //判断是不是需要显示详情的cell
        if (self.mInt_our == 1) {//自己发送的
            tempW = [dm getInstance].width-50-70-10;
            cell.mBtn_work.hidden = NO;
            if (self.mArr_msg.count==indexPath.row+1) {
                cell.mBtn_work.hidden = YES;
                tempW = [dm getInstance].width-50-30;
//                cell.mBtn_work.enabled = YES;
//                [cell.mBtn_work setTitle:@"再发" forState:UIControlStateNormal];
//                [cell.mBtn_work addTarget:self action:@selector(clickAttListSendBtn:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                cell.mBtn_work.enabled = NO;
                [cell.mBtn_work setTitle:@"详情" forState:UIControlStateNormal];
            }
        }else{
            cell.mBtn_work.enabled = NO;
            if (self.mArr_msg.count==indexPath.row+1) {
                tempW = [dm getInstance].width-50-30;
                cell.mBtn_work.hidden = YES;
            }else{
                tempW = [dm getInstance].width-50-70-10;
                cell.mBtn_work.hidden = NO;
            }
            
            if ([model.ReadFlag intValue]==0) {
                [cell.mBtn_work setTitle:@"未阅" forState:UIControlStateNormal];
            }else if ([model.ReadFlag intValue]==1) {
                [cell.mBtn_work setTitle:@"待回复" forState:UIControlStateNormal];
            }else if ([model.ReadFlag intValue]==2) {
                [cell.mBtn_work setTitle:@"再回复" forState:UIControlStateNormal];
            }
        }
        
        CGSize contentSize = [model.MsgContent sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(tempW, 20000) lineBreakMode:NSLineBreakByWordWrapping];
        cell.mLab_content.text = model.MsgContent;
        cell.mLab_content.font = [UIFont systemFontOfSize:16];
        D("contenent0-0--==%f,%f,%@",contentSize.width,contentSize.height,model.MsgContent);
        //计算宽度
        CGFloat cellFloat;
        if (contentSize.width<tempW) {
            cellFloat = contentSize.width;
        }else{
            cellFloat = tempW;
        }
        //计算行数
//        cell.mLab_content.numberOfLines = contentSize.width/tempW;
        [cell.mLab_content setNumberOfLines:0];
        cell.mLab_content.frame = CGRectMake(65, 38, cellFloat, contentSize.height);
        D("lsjfljglsj-====%@,%ld,%f,%f",NSStringFromCGRect(cell.mLab_content.frame),(long)cell.mLab_content.numberOfLines,contentSize.width,tempW);
        CGRect rect = cell.mLab_content.frame;
        if (self.mArr_msg.count == indexPath.row+1) {
            //是否有附件
            for (int i=0; i<self.mArr_attList.count; i++) {
                MsgDetail_AttList *model = [self.mArr_attList objectAtIndex:i];
                NSString *attStr = [NSString stringWithFormat:@"附件:%@(%@)",model.OrgFilename,model.FileSize];
                CGSize size = [attStr sizeWithFont:[UIFont systemFontOfSize:11]];
                if (size.width>tempW) {
                    size.width = tempW;
                }
                if (size.width>cellFloat) {
                    cellFloat = size.width;
                }
                rect = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height+2, size.width, size.height);
                UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                tempBtn.frame = rect;
                tempBtn.titleLabel.font = [UIFont systemFontOfSize: 13];
                [tempBtn setTitle:attStr forState:UIControlStateNormal];
                [tempBtn setTitleColor:[UIColor colorWithRed:17/255.0 green:107/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
                tempBtn.tag = i+1;
                [tempBtn addTarget:self action:@selector(clickAttListBtn:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:tempBtn];
                
                D("detail.attListModel -== %@,%@,%@",model.dlurl,model.OrgFilename,model.FileSize);
            }
        }
        //背景色
//        cell.mImgV_background.image = [UIImage imageNamed:@"workMsg"];
        [cell.mImgV_background setImage:[[UIImage imageNamed:@"workMsg"]stretchableImageWithLeftCapWidth:25 topCapHeight:20]];
        cell.mImgV_background.frame = CGRectMake(55, cell.mLab_content.frame.origin.y-5, cellFloat+15, rect.origin.y+rect.size.height-15);
        //再计算行高,看内容是否高于头像
        CGFloat lineH;
        CGFloat tempBack = cell.mImgV_background.frame.origin.y+cell.mImgV_background.frame.size.height+5;
        if (tempBack>60) {
            lineH = tempBack;
        }else{
            lineH = 60;
        }
        //分割线
        cell.mLab_line.frame = CGRectMake(0, lineH-1, [dm getInstance].width, .5);
        cell.mLab_line.hidden = YES;
        cell.frame = CGRectMake(0, 0, [dm getInstance].width, lineH);
    }else{
        MsgDetail_FeebackList *model = [self.mArr_list objectAtIndex:indexPath.row];
        //姓名
        cell.mLab_name.hidden = NO;
        cell.mLab_name.numberOfLines = 0;
        cell.mLab_name.lineBreakMode = NSLineBreakByCharWrapping;
        D("jkljkjk-====%@",model.Jiaobaohao);
        cell.mLab_name.text = model.UserName;
        cell.mLab_name.textAlignment = NSTextAlignmentLeft;
        cell.mLab_name.font = [UIFont systemFontOfSize:11];
//        CGRect rect=[cell.mLab_name.text boundingRectWithSize:CGSizeMake(40, 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin
//                                      attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11],NSFontAttributeName, nil]  context:nil];
        CGSize size = [cell.mLab_name.text sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(40, 1000)];
        cell.mLab_name.frame = CGRectMake([dm getInstance].width-55, 62, 40, size.height);
        [cell.mImgV_head sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,model.Jiaobaohao] placeholderImage:[UIImage  imageNamed:@"root_img"]];
        //cell.mLab_name.textColor = [UIColor colorWithRed:41/255.0 green:41/255.0 blue:41/255.0 alpha:1];
        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//        //文件名
//        NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.Jiaobaohao]];
//        UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
//        if (img.size.width>0) {
//            [cell.mImgV_head setImage:img];
//        }else{
//            [cell.mImgV_head setImage:[UIImage imageNamed:@"root_img"]];
//            //获取头像
//            [[ExchangeHttp getInstance] getUserInfoFace:model.Jiaobaohao];
//        }
        cell.mImgV_head.frame = CGRectMake([dm getInstance].width-50, 20, 40, 40);
        
        //时间
//        CGSize timeSize = [[NSString stringWithFormat:@"%@",model.RecDate] sizeWithFont:[UIFont systemFontOfSize:12]];
//        cell.mLab_time.frame = CGRectMake(0, 2, [dm getInstance].width, timeSize.height);
//        cell.mLab_time.text = model.RecDate;
        cell.mLab_time.hidden = YES;
        //按钮
        cell.mBtn_work.hidden = YES;
        
        //内容
        CGFloat tempW = [dm getInstance].width-50-70-10;
        CGSize contentSize = [model.FeeBackMsg sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(tempW, 2000) lineBreakMode:NSLineBreakByWordWrapping];
        cell.mLab_content.text = model.FeeBackMsg;
        //NSLog(@"contentSize_width = %f contentSize_width = %f",contentSize.width,contentSize.height);
        cell.mLab_content.font = [UIFont systemFontOfSize:16];
        //计算宽度
        CGFloat cellFloat;
        if (contentSize.width<tempW) {
            cellFloat = contentSize.width;
            //cellFloat = tempW;
        }else{
            cellFloat = tempW;
        }
        //计算行数
//        cell.mLab_content.numberOfLines = contentSize.width/tempW;
        [cell.mLab_content setNumberOfLines:0];
        cell.mLab_content.frame = CGRectMake([dm getInstance].width-cellFloat-60, cell.mImgV_head.frame.origin.y+5, cellFloat, contentSize.height);
        //背景色
//        cell.mImgV_background.image = [UIImage imageNamed:@"workDetail"];
        [cell.mImgV_background setImage:[[UIImage imageNamed:@"workDetail"]stretchableImageWithLeftCapWidth:25 topCapHeight:20]];
        cell.mImgV_background.frame = CGRectMake([dm getInstance].width-cellFloat-65, cell.mLab_content.frame.origin.y-5, cellFloat+10, cell.mLab_content.frame.size.height+20);
        //再计算行高,看内容是否高于头像
        CGFloat lineH;
        CGFloat tempBack = cell.mImgV_background.frame.origin.y+cell.mImgV_background.frame.size.height+5;
        CGFloat tempBack1 = cell.mImgV_head.frame.origin.y+cell.mImgV_head.frame.size.height+5;
        if (tempBack>tempBack1) {
            lineH = tempBack;
        }else{
            lineH = tempBack1;
        }
        //分割线
//        cell.mLab_line.frame = CGRectMake(0, lineH-1, [dm getInstance].width, .5);
        cell.mLab_line.hidden = YES;
        cell.frame = CGRectMake(0, 0, [dm getInstance].width, lineH);
        
    }
    cell.contentView.backgroundColor = self.view.backgroundColor;
    
    return cell;
}

// 用于延时显示图片，以减少内存的使用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    WorkMsgListCell *cell2 = (WorkMsgListCell *)cell;
    if (self.mArr_msg.count>indexPath.row) {
        CommMsgListModel *model = [self.mArr_list objectAtIndex:indexPath.row];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.JiaoBaoHao]];
        UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
        if (img.size.width>0) {
            [cell2.mImgV_head setImage:img];
        }else{
            [cell2.mImgV_head setImage:[UIImage imageNamed:@"root_img"]];
        }
    }else{
        MsgDetail_FeebackList *model = [self.mArr_list objectAtIndex:indexPath.row];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.Jiaobaohao]];
        UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
        if (img.size.width>0) {
            [cell2.mImgV_head setImage:img];
        }else{
            [cell2.mImgV_head setImage:[UIImage imageNamed:@"root_img"]];
        }
    }
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    UITableViewCell *cell= [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        return cell.frame.size.height+17;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.mArr_msg.count>indexPath.row+1) {
        WorkMsgListViewController *work = [[WorkMsgListViewController alloc] init];
        CommMsgListModel *model = [self.mArr_list objectAtIndex:indexPath.row];
        work.mStr_name = @"信息详情";
        work.mInt_flag = 2;
        work.mStr_flag = model.NoReadCount;
        work.mInt_our = self.mInt_our;
        work.mStr_tableID = model.TabIDStr;
        [utils pushViewController:work animated:YES];
    }
}

-(void)clickAttListSendBtn:(UIButton *)btn{
    D("wyeoiurwghfkljgvn;lk");
    ReSendMsgViewController *reSend = [[ReSendMsgViewController alloc] init];
    reSend.mArr_member = [NSMutableArray arrayWithArray:self.mArr_readList];
    [utils pushViewController:reSend animated:YES];
}

//通知信息详情界面回复是否成功
-(void)addFeeBack:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSDictionary *dic = noti.object;
    NSString *str = [dic objectForKey:@"msg"];
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag isEqual:@"1"]) {//成功
        [MBProgressHUD showSuccess:str toView:self.view];
        MsgDetail_FeebackList *model = [[MsgDetail_FeebackList alloc] init];
        model.FeeBackMsg = self.mTextF_text.text;
        model.Jiaobaohao = [dm getInstance].jiaoBaoHao;
        model.UserName = [dm getInstance].name;
        [self.mArr_feeback insertObject:model atIndex:0];
        self.mTextF_text.text = @"";
        [self.mTextF_text resignFirstResponder];
        [self addArray];
    } else {//失败
        [MBProgressHUD showError:str toView:self.view];
    }
}
//点击附件按钮下载文件按钮
-(void)clickAttListBtn:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    D("点击附件按钮下载文件按钮.tag-=  %ld",(long)btn.tag);
    MsgDetail_AttList *model = [self.mArr_attList objectAtIndex:btn.tag-1];
    self.mInt_file = (int)btn.tag;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //文件名
//    NSString *fileName = [NSString stringWithFormat:@"%@%@",model.dlurl,model.OrgFilename];
//    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
    //判断文件夹是否存在
    if(![fileManager fileExistsAtPath:tempPath]) {//如果不存在
        [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *imgPath=[tempPath stringByAppendingPathComponent:model.OrgFilename];
    D("imgPath-== %@",imgPath);
    BOOL yesNo=[[NSFileManager defaultManager] fileExistsAtPath:imgPath];
    if (!yesNo) {//不存在
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"文件可以下载，但是有可能无法显示或执行，确认下载附件%@?",model.OrgFilename] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 10;
        [alert show];
    }else {//存在
//        self.mProgressV.labelText = @"已下载此文件";
//        self.mProgressV.mode = MBProgressHUDModeCustomView;
//        [self.mProgressV show:YES];
//        [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
        // 1.封装图片数据
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
        
        NSArray * rslt = [model.OrgFilename componentsSeparatedByString:@"."];//在“.”的位置将文件名分成几块
        NSString * str = [rslt objectAtIndex:[rslt count]-1];//找到最后一块，即为后缀名
        
        if (([str isEqual:@"png"]||[str isEqual:@"gif"]||[str isEqual:@"jpg"]||[str isEqual:@"bmp"])){
            NSMutableArray *photos0 = [NSMutableArray array];
            NSArray * rslt = [model.OrgFilename componentsSeparatedByString:@"."];//在“.”的位置将文件名分成几块
            NSString * str = [rslt objectAtIndex:[rslt count]-1];//找到最后一块，即为后缀名
            if (([str isEqual:@"png"]||[str isEqual:@"gif"]||[str isEqual:@"jpg"]||[str isEqual:@"bmp"])){
                NSString * getImageStrPath = [NSString stringWithFormat:@"%@/%@",tempPath,model.OrgFilename];
                [photos0 addObject:[MWPhoto photoWithFilePath:getImageStrPath]];
            }
            self.mArr_photos = photos0;
            // Create browser
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            browser.displayActionButton = NO;//分享按钮,默认是
            browser.displayNavArrows = NO;//左右分页切换,默认否
            browser.displaySelectionButtons = NO;//是否显示选择按钮在图片上,默认否
            browser.alwaysShowControls = NO;//控制条件控件 是否显示,默认否
            browser.zoomPhotosToFill = NO;//是否全屏,默认是
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            browser.wantsFullScreenLayout = YES;//是否全屏
#endif
            browser.enableGrid = NO;//是否允许用网格查看所有图片,默认是
            browser.startOnGrid = NO;//是否第一张,默认否
            browser.enableSwipeToDismiss = NO;
            
            double delayInSeconds = 0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
            });
            
            self.navigationController.title = @"";
            [self.navigationController pushViewController:browser animated:YES];
        }else{
            OpenFileViewController *openFile = [[OpenFileViewController alloc] init];
            openFile.mStr_name = model.OrgFilename;
            [utils pushViewController:openFile animated:YES];
        }
    }
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.mArr_photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.mArr_photos.count)
        return [self.mArr_photos objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    D("Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    D("Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

//UIAlertView回调
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10) {
        if (buttonIndex == 1) {
            //检查当前网络是否可用
            if ([self checkNetWork]) {
                return;
            }
            MsgDetail_AttList *model = [self.mArr_attList objectAtIndex:self.mInt_file-1];
            [[LoginSendHttp getInstance] msgDetailDownLoadFileWithURL:model.dlurl fileName:model.OrgFilename vc:self];

            [self.mProgressV show:YES];
            self.mProgressV.mode = MBProgressHUDModeDeterminateHorizontalBar;
            self.mProgressV.progress = 0;
            // Set determinate mode
            //[MBProgressHUD showMessage:@"下载中..." toView:self.view];
        }
    }
}
-(void)setProgress:(float)newProgress{
        [self.mProgressV setProgress:newProgress];
    D("进度是：%@",[NSString stringWithFormat:@"%0.f",newProgress*100]);
    self.mProgressV.labelText = [NSString stringWithFormat:@"已经下载：%0.f%%",newProgress*100];
    if (newProgress>=1) {
        [self.mProgressV hide:YES];
    }

}

//通知信息详情界面，更新下载文件的进度条
-(void)loadingProgress:(NSNotification *)noti{
    NSString *str = noti.object;
    float temp = [str intValue];
    //[self.mProgressV show:YES];
    self.mProgressV.mode = MBProgressHUDModeDeterminateHorizontalBar;
    self.mProgressV.progress = temp;
    if (temp>=1) {
        [self.mProgressV hide:YES];
    }
}

- (void) keyboardWasShown:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSValue *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.mTableV_detail.frame = CGRectMake(0, 44, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height-51-keyboardSize.height+[dm getInstance].statusBar);
                         self.mView_text.frame = CGRectMake(0, [dm getInstance].height-keyboardSize.height-51, [dm getInstance].width, 51);
                     }
                     completion:^(BOOL finished){
                         ;
                     }];
}
- (void) keyboardWasHidden:(NSNotification *) notif{
    NSDictionary *userInfo = [notif userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         if(self.mInt_flag ==0)
                         {
                            self.mTableV_detail.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height+self.mNav_navgationBar.frame.origin.y, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height-51);
                         }
                         else
                         {
                            self.mTableV_detail.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height+self.mNav_navgationBar.frame.origin.y, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height-51);
                         }
   
                         //self.mTableV_detail.frame = CGRectMake(0, 44, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height-51+[dm getInstance].statusBar);
                         self.mView_text.frame = CGRectMake(0, [dm getInstance].height-51, [dm getInstance].width, 51);
                     }
                     completion:^(BOOL finished){
                         ;
                     }];
}

//键盘点击DO
#pragma mark - UITextView Delegate Methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        //若其有输入内容，则发送
        if (self.mTextF_text.text.length>0) {
            [self clickSendBtn:nil];
        }
        return NO;
    }
    return YES;
}

//导航条返回按钮
-(void)myNavigationGoback{
    [utils popViewControllerAnimated:YES];
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

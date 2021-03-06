//
//  ClassView.m
//  JiaoBao
//
//  Created by Zqw on 15-3-19.
//  Copyright (c) 2015年 JSY. All rights reserved.
//test

#import "ClassView.h"
#import "Reachability.h"
#import "MobClick.h"
#import "IQKeyboardManager.h"
#import "RCLabel.h"

@implementation ClassView
@synthesize mArr_attention,mView_button,mArr_class,mArr_local,mArr_sum,mArr_unit,mBtn_photo,mTableV_list,mInt_index,mArr_attentionTop,mArr_classTop,mArr_localTop,mArr_sumTop,mArr_unitTop,mInt_flag,mView_popup,mView_text,mBtn_send,mTextF_text,mInt_changeUnit;
-(void)refreshClassView:(id)sender
{
    [MBProgressHUD hideHUDForView:self];
    [self.mTableV_list reloadData];
}

- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    
    self.finishSymbol = 0;
    self.finishSybmol2 = 0;
    if (self) {
        // Initialization code
        self.frame = frame;
        
        //做bug服务器显示当前的哪个界面
        NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
        [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];

        self.backgroundColor = [UIColor whiteColor];

        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshClassView" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshClassView:) name:@"refreshClassView" object:nil];
        //通知学校界面，获取到的单位和个人数据,本单位或本班
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UnitArthListIndex" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnitArthListIndex:) name:@"UnitArthListIndex" object:nil];
        //取单位空间发表的最新或推荐文章,本地和全部
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ShowingUnitArthList" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowingUnitArthList:) name:@"ShowingUnitArthList" object:nil];
        //通知学校界面，获取到的关注数据
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MyAttUnitArthListIndex" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MyAttUnitArthListIndex:) name:@"MyAttUnitArthListIndex" object:nil];
        //我的班级文章列表
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AllMyClassArthList" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AllMyClassArthList:) name:@"AllMyClassArthList" object:nil];
        //获取到头像后刷新
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"exchangeGetFaceImg" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TopArthListIndexImg:) name:@"exchangeGetFaceImg" object:nil];
        //通知学校界面，切换成功身份成功，清空数组
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeCurUnit" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCurUnit:) name:@"changeCurUnit" object:nil];
        //切换账号时，更新数据
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RegisterView" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RegisterView:) name:@"RegisterView" object:nil];
        //将获取到的评论列表传到界面
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AirthCommentsList2" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AirthCommentsList2:) name:@"AirthCommentsList2" object:nil];
        //获取文章的附加信息
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetArthInfo" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetArthInfo:) name:@"GetArthInfo" object:nil];
        //通知文章详情界面刷新点赞
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AirthLikeIt" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AirthLikeIt:) name:@"AirthLikeIt" object:nil];
        //键盘事件
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
        //文章评论
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AirthAddComment" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AirthAddComment:) name:@"AirthAddComment" object:nil];
        //通知主页进行修改点击量、点赞数等值
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetArthInfoModel" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetArthInfoModel:) name:@"GetArthInfoModel" object:nil];
        
        self.mArr_unit = [NSMutableArray array];
        self.mArr_class = [NSMutableArray array];
        self.mArr_local = [NSMutableArray array];
        self.mArr_attention = [NSMutableArray array];
        self.mArr_sum = [NSMutableArray array];
        self.mArr_unitTop = [NSMutableArray array];
        self.mArr_classTop = [NSMutableArray array];
        self.mArr_localTop = [NSMutableArray array];
        self.mArr_attentionTop = [NSMutableArray array];
        self.mArr_sumTop = [NSMutableArray array];
        self.mInt_index = 0;
        //可滑动界面
//        self.mScrollV_sum = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, self.frame.size.height - 51)];
//        [self addSubview:self.mScrollV_sum];
//        self.mScrollV_sum.contentSize = CGSizeMake([dm getInstance].width, 488);
        
        //放四个按钮
        self.mView_button = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 42)];
        self.mView_button.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:247/255.0 alpha:1];
        [self addSubview:self.mView_button];
        
        //加载按钮
        for (int i=0; i<5; i++) {
            UIButton *tempbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tempbtn.tag = i;
            if (i == 0) {
                tempbtn.selected = YES;
            }
            [tempbtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"classView_%d",i]] forState:UIControlStateSelected];
            [tempbtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"classView_click_%d",i]] forState:UIControlStateNormal];
            tempbtn.frame = CGRectMake((([dm getInstance].width-56*5)/6)*(i+1)+56*i, 0, 56, 42);
            [tempbtn addTarget:self action:@selector(btnChange:) forControlEvents:UIControlEventTouchUpInside];
            [self.mView_button addSubview:tempbtn];
        }
        //列表
//        self.mTableV_list = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, self.frame.size.height) style:UITableViewStyleGrouped];
        self.mTableV_list = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, [dm getInstance].width, self.frame.size.height-44)];
        self.mTableV_list.delegate=self;
        self.mTableV_list.dataSource=self;
//        self.mTableV_list.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view = [[UIView alloc]init];
        self.mTableV_list.tableFooterView = view;

//        self.mTableV_list.scrollEnabled = NO;
        [self addSubview:self.mTableV_list];
        [self.mTableV_list addHeaderWithTarget:self action:@selector(headerRereshing)];
        self.mTableV_list.headerPullToRefreshText = @"下拉刷新";
        self.mTableV_list.headerReleaseToRefreshText = @"松开后刷新";
        self.mTableV_list.headerRefreshingText = @"正在刷新...";
        [self.mTableV_list addFooterWithTarget:self action:@selector(footerRereshing)];
        self.mTableV_list.footerPullToRefreshText = @"上拉加载更多";
        self.mTableV_list.footerReleaseToRefreshText = @"松开加载更多数据";
        self.mTableV_list.footerRefreshingText = @"正在加载...";
        //新建按钮
//        self.mBtn_photo = [UIButton buttonWithType:UIButtonTypeCustom];
//        UIImage *img_btn = [UIImage imageNamed:@"root_addBtn"];
//        [self.mBtn_photo setBackgroundImage:img_btn forState:UIControlStateNormal];
//        [self.mBtn_photo addTarget:self action:@selector(clickPosting:) forControlEvents:UIControlEventTouchUpInside];
//        self.mBtn_photo.frame = CGRectMake(([dm getInstance].width-img_btn.size.width)/2, self.frame.size.height-51+(51-img_btn.size.height)/2, img_btn.size.width, img_btn.size.height);
//        [self.mBtn_photo setTitle:@"拍照发布" forState:UIControlStateNormal];
//        [self.mBtn_photo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self addSubview:self.mBtn_photo];
        
        self.mView_popup = [[PopupWindow alloc] init];
        self.mView_popup.delegate = self;
        [self addSubview:self.mView_popup];
        self.mView_popup.hidden = YES;
        
        //输入View坐标
        self.mView_text = [[UIView alloc] init];
        self.mView_text.frame = CGRectMake(0, 500, [dm getInstance].width, 51);
        self.mView_text.backgroundColor = [UIColor whiteColor];
        //添加边框
        self.mView_text.layer.borderWidth = .5;
        self.mView_text.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
        [self addSubview:self.mView_text];
        //输入框
        self.mTextF_text = [[UITextField alloc] init];
        self.mTextF_text.frame = CGRectMake(15, 10, [dm getInstance].width-15*2, 51-20);
        self.mTextF_text.placeholder = @"请输入评论内容";
        self.mTextF_text.delegate = self;
        self.mTextF_text.font = [UIFont systemFontOfSize:14];
        self.mTextF_text.borderStyle = UITextBorderStyleRoundedRect;
        self.mTextF_text.returnKeyType = UIReturnKeyDone;//return键的类型
        [self.mView_text addSubview:self.mTextF_text];
        //发送按钮
//        self.mBtn_send = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.mBtn_send.frame = CGRectMake([dm getInstance].width-65, 0, 60, 51);
//        [self.mBtn_send addTarget:self action:@selector(clickSendBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [self.mBtn_send setTitle:@"发送" forState:UIControlStateNormal];
//        self.mBtn_send.titleLabel.font = [UIFont systemFontOfSize:14];
//        [self.mBtn_send setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [self.mView_text addSubview:self.mBtn_send];
//        [self.mView_text setHidden:YES];
        
    }
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, [dm getInstance].height/3, [dm getInstance].width, 50)];
    
    self.label.textColor = [UIColor grayColor];
    //self.label.font = [UIFont systemFontOfSize:15];
    self.label.textAlignment = NSTextAlignmentCenter;
    return self;
}

//通知主页进行修改点击量、点赞数等值
-(void)GetArthInfoModel:(NSNotification *)noti{
    GetArthInfoModel *model = noti.object;
    NSString *tableID = [NSString stringWithFormat:@"%@",model.TabIDStr];
    if (self.mInt_index == 2) {
        for (int i=0; i<self.mArr_unitTop.count; i++) {
            ClassModel *classModel = [self.mArr_unitTop objectAtIndex:i];
            if ([classModel.TabIDStr isEqual:tableID]) {
                classModel.ViewCount = [NSString stringWithFormat:@"%d",model.ViewCount+1];
                classModel.ClickCount = [NSString stringWithFormat:@"%d",model.ClickCount+1];
                classModel.LikeCount = [NSString stringWithFormat:@"%d",model.LikeCount];
                break;
            }
        }
        for (int i=0; i<self.mArr_unit.count; i++) {
            ClassModel *classModel = [self.mArr_unit objectAtIndex:i];
            if ([classModel.TabIDStr isEqual:tableID]) {
                classModel.ViewCount = [NSString stringWithFormat:@"%d",model.ViewCount+1];
                classModel.ClickCount = [NSString stringWithFormat:@"%d",model.ClickCount+1];
                classModel.LikeCount = [NSString stringWithFormat:@"%d",model.LikeCount];
                break;
            }
        }
    }else if (self.mInt_index == 3){
        for (int i=0; i<self.mArr_classTop.count; i++) {
            ClassModel *classModel = [self.mArr_classTop objectAtIndex:i];
            if ([classModel.TabIDStr isEqual:tableID]) {
                classModel.ViewCount = [NSString stringWithFormat:@"%d",model.ViewCount+1];
                classModel.ClickCount = [NSString stringWithFormat:@"%d",model.ClickCount+1];
                classModel.LikeCount = [NSString stringWithFormat:@"%d",model.LikeCount];
                break;
            }
        }
        for (int i=0; i<self.mArr_class.count; i++) {
            ClassModel *classModel = [self.mArr_class objectAtIndex:i];
            if ([classModel.TabIDStr isEqual:tableID]) {
                classModel.ViewCount = [NSString stringWithFormat:@"%d",model.ViewCount+1];
                classModel.ClickCount = [NSString stringWithFormat:@"%d",model.ClickCount+1];
                classModel.LikeCount = [NSString stringWithFormat:@"%d",model.LikeCount];
                break;
            }
        }
    }else if (self.mInt_index == 1){
        for (int i=0; i<self.mArr_local.count; i++) {
            ClassModel *classModel = [self.mArr_local objectAtIndex:i];
            if ([classModel.TabIDStr isEqual:tableID]) {
                classModel.ViewCount = [NSString stringWithFormat:@"%d",model.ViewCount+1];
                classModel.ClickCount = [NSString stringWithFormat:@"%d",model.ClickCount+1];
                classModel.LikeCount = [NSString stringWithFormat:@"%d",model.LikeCount];
                break;
            }
        }
    }else if (self.mInt_index == 4){
        for (int i=0; i<self.mArr_attention.count; i++) {
            ClassModel *classModel = [self.mArr_attention objectAtIndex:i];
            if ([classModel.TabIDStr isEqual:tableID]) {
                classModel.ViewCount = [NSString stringWithFormat:@"%d",model.ViewCount+1];
                classModel.ClickCount = [NSString stringWithFormat:@"%d",model.ClickCount+1];
                classModel.LikeCount = [NSString stringWithFormat:@"%d",model.LikeCount];
                break;
            }
        }
    }else if (self.mInt_index == 0){
        for (int i=0; i<self.mArr_sum.count; i++) {
            ClassModel *classModel = [self.mArr_sum objectAtIndex:i];
            D("sdl;fgjad;fgiljsdj-===%@,%@",classModel.TabIDStr,tableID);
            if ([classModel.TabIDStr isEqual:tableID]) {
                classModel.ViewCount = [NSString stringWithFormat:@"%d",model.ViewCount+1];
                classModel.ClickCount = [NSString stringWithFormat:@"%d",model.ClickCount+1];
                classModel.LikeCount = [NSString stringWithFormat:@"%d",model.LikeCount];
                break;
            }
        }
    }
    
    [self.mTableV_list reloadData];
}

//将获取到的评论列表传到界面
-(void)AirthCommentsList2:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    NSString *flag = [noti.object objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        CommentsListObjModel *model = [noti.object objectForKey:@"model"];
        NSString *tableID = [noti.object objectForKey:@"tableID"];
        if (self.mInt_index == 2) {
            for (int i=0; i<self.mArr_unitTop.count; i++) {
                ClassModel *classModel = [self.mArr_unitTop objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:tableID]) {
                    classModel.mArr_comment = [NSMutableArray arrayWithArray:model.commentsList];
                    [self getCommentHeight:classModel];

                    break;
                }
            }
            for (int i=0; i<self.mArr_unit.count; i++) {
                ClassModel *classModel = [self.mArr_unit objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:tableID]) {
                    classModel.mArr_comment = [NSMutableArray arrayWithArray:model.commentsList];
                    [self getCommentHeight:classModel];
                    break;
                }
            }
        }else if (self.mInt_index == 3){
            for (int i=0; i<self.mArr_classTop.count; i++) {
                ClassModel *classModel = [self.mArr_classTop objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:tableID]) {
                    classModel.mArr_comment = [NSMutableArray arrayWithArray:model.commentsList];
                    [self getCommentHeight:classModel];
                    break;
                }
            }
            for (int i=0; i<self.mArr_class.count; i++) {
                ClassModel *classModel = [self.mArr_class objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:tableID]) {
                    classModel.mArr_comment = [NSMutableArray arrayWithArray:model.commentsList];
                    [self getCommentHeight:classModel];
                    break;
                }
            }
        }else if (self.mInt_index == 1){
            for (int i=0; i<self.mArr_local.count; i++) {
                ClassModel *classModel = [self.mArr_local objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:tableID]) {
                    classModel.mArr_comment = [NSMutableArray arrayWithArray:model.commentsList];
                    [self getCommentHeight:classModel];
                    break;
                }
            }
        }else if (self.mInt_index == 4){
            for (int i=0; i<self.mArr_attention.count; i++) {
                ClassModel *classModel = [self.mArr_attention objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:tableID]) {
                    classModel.mArr_comment = [NSMutableArray arrayWithArray:model.commentsList];
                    [self getCommentHeight:classModel];
                    break;
                }
            }
        }else if (self.mInt_index == 0){
            for (int i=0; i<self.mArr_sum.count; i++) {
                ClassModel *classModel = [self.mArr_sum objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:tableID]) {
                    classModel.mArr_comment = [NSMutableArray arrayWithArray:model.commentsList];
                    [self getCommentHeight:classModel];
                    break;
                }
            }
        }
        
        [self.mTableV_list reloadData];
    }else{
        [MBProgressHUD showError:@"超时" toView:self];
    }
}
-(float)getCommentHeight:(ClassModel*)classModel
{
    float h = 0;
    for(int i=0;i<classModel.mArr_comment.count;i++)
    {
        commentsListModel *tempModel = [classModel.mArr_comment objectAtIndex:i];
        
        NSString *string1 = tempModel.UserName;
        NSString *string2 = tempModel.Commnets;
        string1 = [string1 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        
        NSString *string = [NSString stringWithFormat:@"%@:%@",string1,string2];
        
        CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-65, 1000)];
        
        h = h+size.height;
        
    }
    classModel.commentHeight = h;
    return classModel.commentHeight;
}
//点击弹出框中的赞或者评论按钮
-(void)PopupWindowClickBtn:(PopupWindow *)PopupWindow Button:(UIButton *)btn{
    self.mView_popup.hidden = YES;
    [self.mView_popup.mBtn_like setTitle:@"点赞" forState:UIControlStateNormal];
    
    if (btn.tag == 0) {
        [MobClick event:@"ClassView_PopupWindowClickBtn" label:@"点赞"];
        //先判断是否已经获取到是否已经点赞的附加信息
        if (self.mView_popup.mModel_class.mModel_info.TabID >0) {//获取到
            if (self.mView_popup.mModel_class.mModel_info.Likeflag >=0){//没有点赞，发送点赞请求
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:BUGFROM] isEqual:@"ArthDetailViewController"]) {
                    
                }else{
                    [[ShareHttp getInstance] shareHttpAirthLikeIt:self.mView_popup.mModel_class.TabIDStr Flag:[NSString stringWithFormat:@"%d",self.mView_popup.mModel_class.mModel_info.Likeflag]];
                    [self ProgressViewLoad:@"点赞中..."];
                }
            }else{//已赞
//                [self loadNoMore:@"已赞"];
            }
        }else{//发送获取当前文章附加信息的请求
            [[ShareHttp getInstance] shareHttpAirthGetArthInfo:self.mView_popup.mModel_class.TabIDStr sid:self.mView_popup.mModel_class.SectionID from:@"0"];
            [self ProgressViewLoad:@"获取信息中..."];
        }
    }else{
        [MobClick event:@"ClassView_PopupWindowClickBtn" label:@"评论"];
        self.mTextF_text.text = @"";
        [self.mTextF_text becomeFirstResponder];
    }
}

//点击发送评论按钮
-(void)clickSendBtn:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    //判断字符串是否为空、是否都是空格
    if([utils isBlankString:self.mTextF_text.text]){
        [MBProgressHUD showError:@"请输入内容" toView:self];
        return;
    }
    if (self.mTextF_text.text.length>1000) {
        [MBProgressHUD showError:@"不能多于1000字" toView:self];
        return;
    }
    self.mView_popup.hidden = YES;
    [[ShareHttp getInstance] shareHttpAirthAddComment:self.mView_popup.mModel_class.TabIDStr content:self.mTextF_text.text refid:@""];
    [self ProgressViewLoad:@"提交中"];
    [self.mTextF_text resignFirstResponder];
}

//文章评论
-(void)AirthAddComment:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    NSString *str = [noti.object objectForKey:@"str"];
    NSString *flag = [noti.object objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        NSString *tableID = [noti.object objectForKey:@"tableID"];
        NSString *comment = [noti.object objectForKey:@"comment"];
        
        commentsListModel *tempModel = [[commentsListModel alloc] init];
        tempModel.UserName = @"我";
        if (self.mTextF_text.text.length==0) {
            tempModel.Commnets = comment;
        }else{
            tempModel.Commnets = self.mTextF_text.text;
        }
        
        if ([str isEqualToString:@"评论成功"]) {
            self.mTextF_text.text = @"";
        }
        if (self.mInt_index == 2) {
            for (int i=0; i<self.mArr_unitTop.count; i++) {
                ClassModel *classModel = [self.mArr_unitTop objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:tableID]) {
                    [classModel.mArr_comment insertObject:tempModel atIndex:0];
                    break;
                }
            }
            for (int i=0; i<self.mArr_unit.count; i++) {
                ClassModel *classModel = [self.mArr_unit objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:tableID]) {
                    [classModel.mArr_comment insertObject:tempModel atIndex:0];
                    break;
                }
            }
        }else if (self.mInt_index == 3){
            for (int i=0; i<self.mArr_classTop.count; i++) {
                ClassModel *classModel = [self.mArr_classTop objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:tableID]) {
                    [classModel.mArr_comment insertObject:tempModel atIndex:0];
                    break;
                }
            }
            for (int i=0; i<self.mArr_class.count; i++) {
                ClassModel *classModel = [self.mArr_class objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:tableID]) {
                    [classModel.mArr_comment insertObject:tempModel atIndex:0];
                    break;
                }
            }
        }else if (self.mInt_index == 1){
            for (int i=0; i<self.mArr_local.count; i++) {
                ClassModel *classModel = [self.mArr_local objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:tableID]) {
                    [classModel.mArr_comment insertObject:tempModel atIndex:0];
                    break;
                }
            }
        }else if (self.mInt_index == 4){
            for (int i=0; i<self.mArr_attention.count; i++) {
                ClassModel *classModel = [self.mArr_attention objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:tableID]) {
                    [classModel.mArr_comment insertObject:tempModel atIndex:0];
                    break;
                }
            }
        }else if (self.mInt_index == 0){
            for (int i=0; i<self.mArr_sum.count; i++) {
                ClassModel *classModel = [self.mArr_sum objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:tableID]) {
                    [classModel.mArr_comment insertObject:tempModel atIndex:0];
                    break;
                }
            }
        }
        [self.mTableV_list reloadData];
    }else{
        [MBProgressHUD showError:str toView:self];
    }
}

//获取文章的附加信息回调
-(void)GetArthInfo:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        GetArthInfoModel *model = [dic objectForKey:@"model"];
        //判断是否需要点赞请求
        NSString *view = [dic objectForKey:@"view"];
        if ([view integerValue] == 0) {
            [self sendLike:model];
        }
        
        if (self.mInt_index == 2) {
            for (int i=0; i<self.mArr_unitTop.count; i++) {
                ClassModel *classModel = [self.mArr_unitTop objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:model.TabIDStr]) {
                    classModel.mModel_info = model;
                    break;
                }
            }
            for (int i=0; i<self.mArr_unit.count; i++) {
                ClassModel *classModel = [self.mArr_unit objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:model.TabIDStr]) {
                    classModel.mModel_info = model;
                    break;
                }
            }
        }else if (self.mInt_index == 3){
            for (int i=0; i<self.mArr_classTop.count; i++) {
                ClassModel *classModel = [self.mArr_classTop objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:model.TabIDStr]) {
                    classModel.mModel_info = model;
                    break;
                }
            }
            for (int i=0; i<self.mArr_class.count; i++) {
                ClassModel *classModel = [self.mArr_class objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:model.TabIDStr]) {
                    classModel.mModel_info = model;
                    break;
                }
            }
        }else if (self.mInt_index == 1){
            for (int i=0; i<self.mArr_local.count; i++) {
                ClassModel *classModel = [self.mArr_local objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:model.TabIDStr]) {
                    classModel.mModel_info = model;
                    break;
                }
            }
        }else if (self.mInt_index == 4){
            for (int i=0; i<self.mArr_attention.count; i++) {
                ClassModel *classModel = [self.mArr_attention objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:model.TabIDStr]) {
                    classModel.mModel_info = model;
                    break;
                }
            }
        }else if (self.mInt_index == 0){
            for (int i=0; i<self.mArr_sum.count; i++) {
                ClassModel *classModel = [self.mArr_sum objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:model.TabIDStr]) {
                    classModel.mModel_info = model;
                    break;
                }
            }
        }
    }else{
        [MBProgressHUD showError:@"超时" toView:self];
    }
}

//收到文章的附加信息后，判断是否需要发送点赞请求
-(void)sendLike:(GetArthInfoModel *)model{
    if (model.Likeflag >=0){//没有点赞，发送点赞请求
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:BUGFROM] isEqual:@"ArthDetailViewController"]) {
            
        }else{
            [[ShareHttp getInstance] shareHttpAirthLikeIt:model.TabIDStr Flag:[NSString stringWithFormat:@"%d",model.Likeflag]];
            [self ProgressViewLoad:@"点赞中..."];
        }
    }else{//已赞
        [MBProgressHUD showError:@"已赞" toView:self];
    }
}

//通知文章详情界面刷新点赞
-(void)AirthLikeIt:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    NSString *flag = [noti.object objectForKey:@"flag"];
    NSString *str = [noti.object objectForKey:@"str"];
    if ([flag integerValue]==0) {
        [MBProgressHUD showSuccess:str toView:self];
        
        //
        NSString *aid = [noti.object objectForKey:@"aid"];
        if (self.mInt_index == 2) {
            for (int i=0; i<self.mArr_unitTop.count; i++) {
                ClassModel *classModel = [self.mArr_unitTop objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:aid]) {
                    classModel.LikeCount = [NSString stringWithFormat:@"%d",[classModel.LikeCount intValue]+1];
                    classModel.mModel_info.Likeflag = -1;
                    break;
                }
            }
            for (int i=0; i<self.mArr_unit.count; i++) {
                ClassModel *classModel = [self.mArr_unit objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:aid]) {
                    classModel.LikeCount = [NSString stringWithFormat:@"%d",[classModel.LikeCount intValue]+1];
                    classModel.mModel_info.Likeflag = -1;
                    break;
                }
            }
        }else if (self.mInt_index == 3){
            for (int i=0; i<self.mArr_classTop.count; i++) {
                ClassModel *classModel = [self.mArr_classTop objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:aid]) {
                    classModel.LikeCount = [NSString stringWithFormat:@"%d",[classModel.LikeCount intValue]+1];
                    classModel.mModel_info.Likeflag = -1;
                    break;
                }
            }
            for (int i=0; i<self.mArr_class.count; i++) {
                ClassModel *classModel = [self.mArr_class objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:aid]) {
                    classModel.LikeCount = [NSString stringWithFormat:@"%d",[classModel.LikeCount intValue]+1];
                    classModel.mModel_info.Likeflag = -1;
                    break;
                }
            }
        }else if (self.mInt_index == 1){
            for (int i=0; i<self.mArr_local.count; i++) {
                ClassModel *classModel = [self.mArr_local objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:aid]) {
                    classModel.LikeCount = [NSString stringWithFormat:@"%d",[classModel.LikeCount intValue]+1];
                    classModel.mModel_info.Likeflag = -1;
                    break;
                }
            }
        }else if (self.mInt_index == 4){
            for (int i=0; i<self.mArr_attention.count; i++) {
                ClassModel *classModel = [self.mArr_attention objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:aid]) {
                    classModel.LikeCount = [NSString stringWithFormat:@"%d",[classModel.LikeCount intValue]+1];
                    classModel.mModel_info.Likeflag = -1;
                    break;
                }
            }
        }else if (self.mInt_index == 0){
            for (int i=0; i<self.mArr_sum.count; i++) {
                ClassModel *classModel = [self.mArr_sum objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:aid]) {
                    classModel.LikeCount = [NSString stringWithFormat:@"%d",[classModel.LikeCount intValue]+1];
                    classModel.mModel_info.Likeflag = -1;
                    break;
                }
            }
        }
        [self.mTableV_list reloadData];
    }else{
        [MBProgressHUD showError:str toView:self];
    }
}

//切换账号时，更新数据
-(void)RegisterView:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    [self clearArray];
//    self.mInt_index = 0;
}

//通知学校界面，切换成功身份成功，清空数组
-(void)changeCurUnit:(NSNotification *)noti{
    NSString *str = noti.object;
    if ([str intValue] ==0||[str intValue] ==2) {//成功
        if (self.mInt_changeUnit ==1) {
            [self clearArray];
            [self.mTableV_list reloadData];
            //重新获取数据
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = self.mInt_index;
            [self btnChange:btn];
        }
    }else{
    }
}

//获取到头像后，更新界面
-(void)TopArthListIndexImg:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    [self.mTableV_list reloadData];
}

//我的班级文章列表
-(void)AllMyClassArthList:(NSNotification *)noti{
    self.finishSymbol++;
    [MBProgressHUD hideHUDForView:self];
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    
    NSDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    NSMutableArray *array = [dic objectForKey:@"array"];

    for (int i=0; i<array.count; i++) {
        ClassModel *model = [array objectAtIndex:i];
        //获取文章评论
        [[ShareHttp getInstance] shareHttpAirthCommentsList:model.TabIDStr Page:@"1" Num:@"5" Flag:@"2"];
    }
    if ([flag intValue] == 2) {//单位动态
        //如果是刷新，将数据清除
        if (self.mInt_flag == 1) {
            [self.mArr_classTop removeAllObjects];
        }
        self.mArr_classTop = array;
        if(self.finishSymbol == 2)
        {
            if(self.mTableV_list.delegate == nil)
            {
                self.mTableV_list.delegate=self;
                self.mTableV_list.dataSource=self;
            }
            else
            {
                [self.mTableV_list reloadData];
                
                
            }
            //self.finishSymbol = 0;
            
        }
    }else{//个人
        //如果是刷新，将数据清除
        if (self.mInt_flag == 1) {
            [self.mArr_class removeAllObjects];
        }
        [self.mArr_class addObjectsFromArray:array];

        if(self.finishSymbol == 2)
        {
            if(self.mTableV_list.delegate == nil)
            {
                self.mTableV_list.delegate=self;
                self.mTableV_list.dataSource=self;
            }
            else
            {
                [self.mTableV_list reloadData];
                
                
            }
            self.finishSymbol = 0;
            
        }

    }
    //[self.mTableV_list reloadData];
}

//通知学校界面，获取到的单位和个人数据,本单位或本班
-(void)UnitArthListIndex:(NSNotification *)noti{
    self.finishSybmol2++;
//    [MBProgressHUD hideHUDForView:self];
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    
    
    NSDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if([ResultCode integerValue]!= 0)
    {
        [MBProgressHUD showError:ResultDesc toView:self];
        return;
        
    }
    NSString *flag = [dic objectForKey:@"flag"];
    NSMutableArray *array = [dic objectForKey:@"array"];
    for (int i=0; i<array.count; i++) {
        ClassModel *model = [array objectAtIndex:i];
        //获取文章评论
        [[ShareHttp getInstance] shareHttpAirthCommentsList:model.TabIDStr Page:@"1" Num:@"5" Flag:@"2"];
    }
    if ([flag intValue] == 2) {
        //如果是刷新，将数据清除
        if (self.mInt_flag == 1) {
            [self.mArr_unitTop removeAllObjects];
        }
        self.mArr_unitTop = array;
        if(self.finishSybmol2 == 2)
        {
            if(self.mTableV_list.delegate == nil)
            {
                self.mTableV_list.delegate=self;
                self.mTableV_list.dataSource=self;
            }
            else
            {
                [self.mTableV_list reloadData];
                
                
            }
            self.finishSybmol2 = 0;
            [MBProgressHUD hideHUDForView:self];

            
        }

    }else{
        //如果是刷新，将数据清除
        if (self.mInt_flag == 1) {
            [self.mArr_unit removeAllObjects];
        }
        [self.mArr_unit addObjectsFromArray:array];
        if(self.finishSybmol2 == 2)
        {
            if(self.mTableV_list.delegate == nil)
            {
                self.mTableV_list.delegate=self;
                self.mTableV_list.dataSource=self;
            }
            else
            {
                [self.mTableV_list reloadData];
                
                
            }
            self.finishSybmol2 = 0;
            [MBProgressHUD hideHUDForView:self];

            
        }
    }


}

//取单位空间发表的最新或推荐文章,本地和全部
-(void)ShowingUnitArthList:(NSNotification *)noti{
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    [MBProgressHUD hideHUDForView:self];
    NSDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if([ResultCode integerValue]!= 0)
    {
        [MBProgressHUD showError:ResultDesc toView:self];
        return;
    }
    NSString *flag = [dic objectForKey:@"flag"];
    NSMutableArray *array = [dic objectForKey:@"array"];
    for (int i=0; i<array.count; i++) {
        ClassModel *model = [array objectAtIndex:i];
        //获取文章评论
        [[ShareHttp getInstance] shareHttpAirthCommentsList:model.TabIDStr Page:@"1" Num:@"5" Flag:@"2"];
    }
    if ([flag intValue] == 2) {//全部
        //如果是刷新，将数据清除
        if (self.mInt_flag == 1) {
            [self.mArr_sum removeAllObjects];
        }
        [self.mArr_sum addObjectsFromArray:array];
    }else{//本地
        //如果是刷新，将数据清除
        if (self.mInt_flag == 1) {
            [self.mArr_local removeAllObjects];
        }
        [self.mArr_local addObjectsFromArray:array];
    }
    [self.mTableV_list reloadData];
}

//通知学校界面，获取到的关注数据
-(void)MyAttUnitArthListIndex:(NSNotification *)noti{
    
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    //如果是刷新，将数据清除
    if (self.mInt_flag == 1) {
        [self.mArr_attention removeAllObjects];
    }
    [MBProgressHUD hideHUDForView:self];
    NSDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if([ResultCode integerValue]!= 0)
    {
        [MBProgressHUD showError:ResultDesc toView:self];
        return;
        
    }
//    NSString *flag = [dic objectForKey:@"flag"];
    NSMutableArray *array = [dic objectForKey:@"array"];
    for (int i=0; i<array.count; i++) {
        ClassModel *model = [array objectAtIndex:i];
        //获取文章评论
        [[ShareHttp getInstance] shareHttpAirthCommentsList:model.TabIDStr Page:@"1" Num:@"5" Flag:@"2"];
    }
    [self.mArr_attention addObjectsFromArray:array];
    [self.mTableV_list reloadData];
//    self.mScrollV_sum.contentSize = CGSizeMake([dm getInstance].width, self.mTableV_list.contentSize.height+42);
//    self.mTableV_list.frame = CGRectMake(0, 42, [dm getInstance].width, self.mTableV_list.contentSize.height);
}

//按钮点击事件
-(void)btnChange:(UIButton *)btn{
    D("utype-===%d,%d",[dm getInstance].uType,[dm getInstance].UID);
    self.mInt_index = (int)btn.tag;
    if ([dm getInstance].UID == 0) {
        
    }else{
        self.mView_popup.hidden = YES;
        
        //点击按钮时，判断是否应该进行数据获取
        if (self.mInt_index == 2&&(self.mArr_unitTop.count==0||self.mArr_unit.count==0)) {
            int a=0;
            if (self.mArr_unitTop.count==0) {
                [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"1" Flag:@"2" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"2"];
                a++;
            }
            if (self.mArr_unit.count==0) {
                [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"5" Flag:@"1" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"1"];
                a++;
            }
            if (a>0) {
                [self ProgressViewLoad:@"加载中..."];
            }
        }else if (self.mInt_index == 3&&(self.mArr_class.count==0||self.mArr_classTop.count==0)){
            int a=0;
            if (self.mArr_classTop.count==0) {
                [[ClassHttp getInstance] classHttpAllMyClassArthList:@"1" Num:@"1" sectionFlag:@"2" RequestFlag:@"2"];//单位
                a++;
            }
            if (self.mArr_class.count==0) {
                [[ClassHttp getInstance] classHttpAllMyClassArthList:@"1" Num:@"5" sectionFlag:@"1" RequestFlag:@"1"];//个人
                a++;
            }
            if (a>0) {
                [self ProgressViewLoad:@"加载中..."];
            }
        }else if (self.mInt_index == 1&&self.mArr_local.count == 0){
            [self tableViewDownReloadData];
            //[self.mTableV_list reloadData];

        }else if (self.mInt_index == 4&&self.mArr_attention.count==0){
            [self tableViewDownReloadData];
            //[self.mTableV_list reloadData];

        }else if (self.mInt_index == 0&&self.mArr_sum.count==0){
            [self tableViewDownReloadData];
            //[self.mTableV_list reloadData];

        }
        if(self.mInt_index == 2)
        {
            [MobClick event:@"ClassView_btnChange" label:@"本单位"];
        }
        else if (self.mInt_index == 3)
        {
            [MobClick event:@"ClassView_btnChange" label:@"本班"];
        }
        else if (self.mInt_index == 1)
        {
            [MobClick event:@"ClassView_btnChange" label:@"本地"];
        }
        else if (self.mInt_index == 4)
        {
            [MobClick event:@"ClassView_btnChange" label:@"关注"];
        }
        else if (self.mInt_index == 0)
        {
            [MobClick event:@"ClassView_btnChange" label:@"全部"];
        }

        D("sldjflksgjlk-====%lu",(unsigned long)self.mArr_attention.count);
        
    }
    [self.mTableV_list reloadData];
    //切换图片
    for (UIButton *tempBtn in self.mView_button.subviews) {
        if ([tempBtn isKindOfClass:[UIButton class]]) {
            if (tempBtn.tag == btn.tag) {
                tempBtn.selected = YES;
            }else{
                tempBtn.selected = NO;
            }
        }
    }
}
//刚进入学校圈，或者下拉刷新时执行
-(void)tableViewDownReloadData{
    self.mView_popup.hidden = YES;
    if ([dm getInstance].UID ==0) {
        if(self.mTableV_list.delegate == nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.mTableV_list.delegate=self;
                self.mTableV_list.dataSource=self;
                [self.mTableV_list reloadData];
                
                
                
            });
            
        }
        else
        {
            [self.mTableV_list reloadData];
            
            
        }
    }else{
            if (self.mInt_index == 2) {
                //flag=1个人，=2单位
                [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"1" Flag:@"2" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"2"];
                [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"5" Flag:@"1" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"1"];
                [self ProgressViewLoad:@"加载中..."];
            }else if (self.mInt_index == 3){
                [[ClassHttp getInstance] classHttpAllMyClassArthList:@"1" Num:@"1" sectionFlag:@"2" RequestFlag:@"2"];//单位
                [[ClassHttp getInstance] classHttpAllMyClassArthList:@"1" Num:@"5" sectionFlag:@"1" RequestFlag:@"1"];//个人
                [self ProgressViewLoad:@"加载中..."];
            }else if (self.mInt_index == 1){
                [[ClassHttp getInstance] classHttpShowingUnitArthList:@"1" Num:@"5" topFlags:@"1" flag:@"local" RequestFlag:@"1"];
                [self ProgressViewLoad:@"加载中..."];
            }else if (self.mInt_index == 4){
                [[ClassHttp getInstance] classHttpMyAttUnitArthListIndex:@"1" Num:@"5" accid:[dm getInstance].jiaoBaoHao];
                [self ProgressViewLoad:@"加载中..."];
            }else if (self.mInt_index == 0){
                [[ClassHttp getInstance] classHttpShowingUnitArthList:@"1" Num:@"5" topFlags:@"1" flag:@"" RequestFlag:@"2"];
                [self ProgressViewLoad:@"加载中..."];
            }
        }
}

//表格开始滑动，
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.mView_popup.hidden = YES;
    self.mView_text.hidden = YES;
    [self.mTextF_text resignFirstResponder];
}

#pragma mark - TableViewdelegate&&TableViewdataSource
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 100)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 50)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor  = [UIColor grayColor];
    [view addSubview:label];
    if(mInt_index == 2)
    {
        if(section == 0)
        {
            if(self.mArr_unitTop.count == 0)
            {
                label.text = @"没有单位动态";

            }
        }
        if(section == 1)
        {
            if(self.mArr_unit.count == 0)
            {
                label.text = @"没有单位分享";

            }
        }
    }
    if(mInt_index == 3)
    {
        if(section == 0)
        {
            if(self.mArr_classTop.count == 0)
            {
                label.text = @"没有班级动态";
                
            }
        }
        if(section == 1)
        {
            if(self.mArr_class.count == 0)
            {
                label.text = @"没有班级分享";
                
            }
        }
        
    }
       return view;


}
    

//每个cell返回的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellHeight:indexPath];
}
//每个section头返回的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.mInt_index == 2||self.mInt_index == 3) {
        return 20;
    }else{
        return 0;
    }
    return 0;
}
//每个section底返回的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(self.mInt_index == 2)
    {
        if(section == 0)
        {
            if(self.mArr_unitTop.count == 0)
            {
                return 50;
            }
        }
        if(section == 1)
        {
            if(self.mArr_unit.count == 0)
            {
                return 50;
            }
        }
    }
    
    if(self.mInt_index == 3)
    {
        if(section == 0)
        {
            if(self.mArr_classTop.count == 0)
            {
                //if(self.finishSymbol == 2)
                {
                    //self.finishSymbol = 0;
                    return 50;

                    
                }
            }
        }
        if(section == 1)
        {
            if(self.mArr_class.count == 0)
            {
                //if(self.finishSymbol == 2)
                {
                    //self.finishSymbol = 0;

                    return 50;
                    
                }
            }
        }
    }
    return 0;
}

//返回section头的uiview
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.mInt_index == 2||self.mInt_index == 3) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 22)];
        view.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:247/255.0 alpha:1];
        UILabel *tempLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [dm getInstance].width-20, 22)];
        if (section ==0) {
            if (self.mInt_index == 2) {
                tempLab.text = @"单位动态";
            }else{
                tempLab.text = @"班级动态";
            }
            UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tempBtn.frame = CGRectMake([dm getInstance].width-60, 0, 50, 22);
//            [tempBtn setBackgroundImage:[UIImage imageNamed:@"classView_more"] forState:UIControlStateNormal];
            [tempBtn setImage:[UIImage imageNamed:@"classView_more"] forState:UIControlStateNormal];
            [tempBtn addTarget:self action:@selector(clickMoreUnit) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:tempBtn];
        }else{
            tempLab.text = @"活动分享";
        }
        tempLab.font = [UIFont systemFontOfSize:12];
        tempLab.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
        [view addSubview:tempLab];
        return view;
    }else {
        return nil;
    }
    
    return nil;
}

//在每个section中，显示多少cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        if (self.mInt_index == 2) {

                [self.label  removeFromSuperview];
            
            

            return self.mArr_unitTop.count;
        }else if (self.mInt_index == 3){

                [self.label  removeFromSuperview];
            
            

            return self.mArr_classTop.count;
        }else if (self.mInt_index == 1){
            if(self.mArr_local.count == 0)
            {
                
                
                self.label.text = @"没有本地信息";
                
                [self addSubview:self.label];
                
            }
            else
            {
                [self.label  removeFromSuperview];
            }

            
            return self.mArr_local.count;
        }else if (self.mInt_index == 4){
            if(self.mArr_attention.count == 0)
            {
                
                
                self.label.text = @"没有关注信息";
                
                [self addSubview:self.label];
                
            }
            else
            {
                [self.label  removeFromSuperview];
            }

            return self.mArr_attention.count;
        }else if (self.mInt_index == 0){
            if(self.mArr_sum.count == 0)
            {
                
                
                self.label.text = @"没有全部信息";
                
                [self addSubview:self.label];
                
            }
            else
            {
                [self.label  removeFromSuperview];
            }

            return self.mArr_sum.count;
        }
    }else{
        if (self.mInt_index == 2) {

            return self.mArr_unit.count;
        }else if (self.mInt_index == 3){
   
            return self.mArr_class.count;
        }else if (self.mInt_index == 1){
            if(self.mArr_local.count == 0)
            {
                
                
                self.label.text = @"没有本地信息";
                
                [self addSubview:self.label];
                
            }
            else
            {
                [self.label  removeFromSuperview];
            }

            return self.mArr_local.count;
        }else if (self.mInt_index == 4){
            if(self.mArr_attention.count == 0)
            {
                
                
                self.label.text = @"没有关注信息";
                
                [self addSubview:self.label];
                
            }
            else
            {
                [self.label  removeFromSuperview];
            }

            return self.mArr_attention.count;
        }else if (self.mInt_index == 0){
            if(self.mArr_sum.count == 0)
            {
                
                
                self.label.text = @"没有全部信息";
                
                [self addSubview:self.label];
                
            }
            else
            {
                [self.label  removeFromSuperview];
            }

            return self.mArr_sum.count;
        }
    }
    

    return 0;
}
//有多少section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.mInt_index == 2||self.mInt_index == 3) {
        return 2;
    }else {
        return 1;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"ClassTableViewCell";

    ClassTableViewCell *cell = (ClassTableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];

    if (cell == nil) {
        cell = [[ClassTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClassTableViewCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell = (ClassTableViewCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        [cell initModel];
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"ClassTableViewCell" bundle:[NSBundle mainBundle]];
        [self.mTableV_list registerNib:n forCellReuseIdentifier:indentifier];
        
    }
    //找到当前应该显示的数组
    NSMutableArray *array = [NSMutableArray array];
    if (indexPath.section == 0) {
        if (self.mInt_index == 2) {
            array = [NSMutableArray arrayWithArray:self.mArr_unitTop];
        }else if (self.mInt_index == 3){
            array = [NSMutableArray arrayWithArray:self.mArr_classTop];
        }else if (self.mInt_index == 1){
            array = [NSMutableArray arrayWithArray:self.mArr_local];
        }else if (self.mInt_index == 4){
            array = [NSMutableArray arrayWithArray:self.mArr_attention];
        }else if (self.mInt_index == 0){
            array = [NSMutableArray arrayWithArray:self.mArr_sum];
        }
    }else{
        if (self.mInt_index == 2) {
            array = [NSMutableArray arrayWithArray:self.mArr_unit];
        }else if (self.mInt_index == 3){
            array = [NSMutableArray arrayWithArray:self.mArr_class];
        }else if (self.mInt_index == 1){
            array = [NSMutableArray arrayWithArray:self.mArr_local];
        }else if (self.mInt_index == 4){
            array = [NSMutableArray arrayWithArray:self.mArr_attention];
        }else if (self.mInt_index == 0){
            array = [NSMutableArray arrayWithArray:self.mArr_sum];
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //显示具体界面
    ClassModel *model = [array objectAtIndex:indexPath.row];
    
    //获取头像
    if ([model.flag intValue] ==1) {//展示
        [cell.mImgV_head sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",UnitIDImg,model.unitId] placeholderImage:[UIImage  imageNamed:@"root_img"]];
    }else{
        [cell.mImgV_head sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,model.JiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];
    }
    //    }
    //    cell.mImgV_head.frame = CGRectMake(10, 15, 42, 42);
    //姓名
    NSString *tempName;
    //判断应该显示姓名，还是单位名
    if ([model.flag intValue] ==1) {//展示
        tempName = model.UnitName;
    }else{
        tempName = model.UserName;
    }
    CGSize nameSize = [[NSString stringWithFormat:@"%@",tempName] sizeWithFont:[UIFont systemFontOfSize:14]];
    cell.mLab_name.frame = CGRectMake(62, 18, nameSize.width, cell.mLab_name.frame.size.height);
    cell.mLab_name.text = tempName;
    //发布单位
    NSString *tempUnit;
    if ([model.flag intValue] ==1) {//展示
        if (self.mInt_index == 2||self.mInt_index == 3) {
            cell.mLab_class.hidden = YES;
        }else{
            tempUnit = [NSString stringWithFormat:@" 动态 "];
            cell.mLab_class.backgroundColor = [UIColor colorWithRed:230/255.0 green:130/255.0 blue:130/255.0 alpha:1];
            cell.mLab_class.textColor = [UIColor whiteColor];
            //将图层的边框设置为圆脚
            cell.mLab_class.layer.cornerRadius = 3;
            cell.mLab_class.layer.masksToBounds = YES;
        }
        CGSize unitSize = [tempUnit sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_class.frame = CGRectMake(cell.mLab_name.frame.origin.x+cell.mLab_name.frame.size.width, 18, unitSize.width, cell.mLab_class.frame.size.height);
    }else{
        if (model.className.length>0) {
            tempUnit = [NSString stringWithFormat:@"(%@)",model.className];
        }else{
            tempUnit = [NSString stringWithFormat:@"(%@)",model.UnitName];
        }
        cell.mLab_class.backgroundColor = [UIColor clearColor];
        cell.mLab_class.textColor = [UIColor grayColor];
        cell.mLab_class.hidden = NO;
        //cell.tableview.frame = CGRectMake(0, cell.mLab_class.frame.origin, <#CGFloat width#>, <#CGFloat height#>)
        cell.mLab_class.frame = CGRectMake(cell.mLab_name.frame.origin.x+cell.mLab_name.frame.size.width, 18, [dm getInstance].width-cell.mLab_name.frame.origin.x-nameSize.width-10, cell.mLab_class.frame.size.height);
    }
    
    
    cell.mLab_class.text = tempUnit;
    
    //判断是否隐藏
    //标题
//    CGSize titleSize = [[NSString stringWithFormat:@"%@",model.Title] sizeWithFont:[UIFont systemFontOfSize:14]];
    cell.mLab_assessContent.frame = CGRectMake(62, cell.mLab_name.frame.origin.y+cell.mLab_name.frame.size.height, [dm getInstance].width-72, cell.mLab_assessContent.frame.size.height);
    cell.mLab_assessContent.text = model.Title;
    //文章logo
    CGSize contentSize;
    cell.mImgV_airPhoto.hidden = YES;
    //详情
    contentSize = [model.Abstracts sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake([dm getInstance].width-72, 99999)];
    if (contentSize.height>26) {
        contentSize = CGSizeMake([dm getInstance].width-82, 30);
        cell.mLab_content.numberOfLines = 2;
        cell.mView_background.hidden = NO;
    }
    if (model.Abstracts.length==0) {
        contentSize = CGSizeMake([dm getInstance].width-82, 0);
        cell.mView_background.hidden = YES;
    }
    cell.mLab_content.frame = CGRectMake(62+5, cell.mLab_assessContent.frame.origin.y+cell.mLab_assessContent.frame.size.height+4, contentSize.width, contentSize.height);
    cell.mLab_content.text = model.Abstracts;
    
    //详情背景色
    cell.mView_background.frame = CGRectMake(62, cell.mLab_content.frame.origin.y-4, [dm getInstance].width-72, contentSize.height+8);
    //是否有文章图片需要显示
    if (model.Thumbnail.count>0) {
        cell.mView_img.hidden = NO;
        //最多显示6个图片
        int a;
        if (model.Thumbnail.count>=3) {
            a=3;
        }else{
            a = (int)model.Thumbnail.count;
        }
        //显示图片的宽度
        int m = ([dm getInstance].width-82)/3;
        //开始塞图片
        BOOL notFirst = NO;
        float y = 5;    float x = 0;
        
        for (int i=0; i<a; i++,x++) {
            if ((i%3)==0 && notFirst) {
                
                y = y+(m+5);
                x = 0;
            }
            notFirst = YES;
            if (i==0) {
                cell.mImgV_0.hidden = NO;
                [cell.mImgV_0 setFrame:CGRectMake(0+(5+m)*x, y, m, m)];
                [cell.mImgV_0 sd_setImageWithURL:[NSURL  URLWithString:[model.Thumbnail objectAtIndex:i]] placeholderImage:[UIImage  imageNamed:@"photo_default"]];
            }else if (i==1){
                cell.mImgV_1.hidden = NO;
                [cell.mImgV_1 setFrame:CGRectMake(0+(5+m)*x, y, m, m)];
                [cell.mImgV_1 sd_setImageWithURL:[NSURL  URLWithString:[model.Thumbnail objectAtIndex:i]] placeholderImage:[UIImage  imageNamed:@"photo_default"]];
            }else if (i==2){
                cell.mImgV_2.hidden = NO;
                [cell.mImgV_2 setFrame:CGRectMake(0+(5+m)*x, y, m, m)];
                [cell.mImgV_2 sd_setImageWithURL:[NSURL  URLWithString:[model.Thumbnail objectAtIndex:i]] placeholderImage:[UIImage  imageNamed:@"photo_default"]];
            }
        }
        cell.mView_img.frame = CGRectMake(62, cell.mView_background.frame.origin.y+cell.mView_background.frame.size.height, [dm getInstance].width-72, m+10);
    }else{
        cell.mView_img.hidden = YES;
        cell.mView_img.frame = cell.mView_background.frame;
    }
    //添加图片点击事件
    cell.tag = indexPath.row;
    cell.mModel_class = model;
    [cell.tableview reloadData];
    cell.delegate = self;
    cell.headImgDelegate = self;
    //添加图片点击事件
    [cell thumbImgClick];
    //添加头像点击事件
    [cell headImgClick];
    
    //时间
    cell.mLab_time.frame = CGRectMake(62, cell.mView_img.frame.origin.y+cell.mView_img.frame.size.height+5, cell.mLab_time.frame.size.width, cell.mLab_time.frame.size.height);
    cell.mLab_time.text = model.RecDate;
    
    //点赞评论按钮
    cell.mBtn_comment.frame = CGRectMake([dm getInstance].width-10-35, cell.mView_img.frame.origin.y+cell.mView_img.frame.size.height, 40, 35);
    [cell.mBtn_comment setImage:[UIImage imageNamed:@"popupWindow_like_comment"] forState:UIControlStateNormal];
    
    //点赞
    CGSize likeSize = [[NSString stringWithFormat:@"%@",model.LikeCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_likeCount.frame = CGRectMake(cell.mBtn_comment.frame.origin.x-10-likeSize.width, cell.mLab_time.frame.origin.y, likeSize.width, cell.mLab_likeCount.frame.size.height);
    cell.mLab_likeCount.text = model.LikeCount;
    cell.mLab_like.frame = CGRectMake(cell.mLab_likeCount.frame.origin.x-cell.mLab_like.frame.size.width, cell.mLab_time.frame.origin.y, cell.mLab_like.frame.size.width, cell.mLab_like.frame.size.height);

    cell.mLab_assess.hidden = YES;
    cell.mLab_assessCount.hidden = YES;
    //点击量
    CGSize clickSize = [[NSString stringWithFormat:@"%@",model.ClickCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_clickCount.frame = CGRectMake(cell.mLab_like.frame.origin.x-likeSize.width-10, cell.mLab_time.frame.origin.y, clickSize.width, cell.mLab_assessCount.frame.size.height);
    cell.mLab_clickCount.text = model.ClickCount;
    cell.mLab_click.frame = CGRectMake(cell.mLab_clickCount.frame.origin.x-cell.mLab_click.frame.size.width, cell.mLab_time.frame.origin.y, cell.mLab_click.frame.size.width, cell.mLab_click.frame.size.height);
    
    float temp = cell.tableview.contentSize.height;
    
    if(model.mArr_comment.count == 0)
    {
        cell.tableview.frame = CGRectZero;
        cell.backImgV.frame = CGRectZero;
        cell.moreBtn.frame = CGRectZero;
        cell.frame = CGRectMake(0, 0, [dm getInstance].width, cell.mLab_time.frame.origin.y+cell.mLab_time.frame.size.height+10);
    }
    else
    {
        if(model.mArr_comment.count<5)
        {
            cell.moreBtn.frame = CGRectZero;
            cell.tableview.frame = CGRectMake(62, cell.mLab_click.frame.origin.y+cell.mLab_click.frame.size.height+5+5, [dm getInstance].width-60-5, temp);
            cell.backImgV.frame = CGRectMake(62,  cell.mLab_click.frame.origin.y+cell.mLab_click.frame.size.height-4+5, [dm getInstance].width-60-5, temp+10);
            UIImage *backImage = [UIImage imageNamed:@"bj.png"];
            // The background should be pinned to the left and not stretch.
            backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(backImage.size.height - 1, 0, 0, 0)];
            cell.backImgV.image = backImage;
            cell.frame = CGRectMake(0, 0, [dm getInstance].width, cell.mLab_time.frame.origin.y+cell.mLab_time.frame.size.height+temp+18+5);

        }
        else{
            cell.tableview.frame = CGRectMake(62, cell.mLab_click.frame.origin.y+cell.mLab_click.frame.size.height+5+5, [dm getInstance].width-60-5, temp);
            cell.backImgV.frame = CGRectMake(62,  cell.mLab_click.frame.origin.y+cell.mLab_click.frame.size.height-4+5, [dm getInstance].width-60-5, temp+9);

            [cell.backImgV setImage:[[UIImage imageNamed:@"bj.png"]stretchableImageWithLeftCapWidth:100 topCapHeight:cell.backImgV.frame.size.height-1]];
            //cell.backImgV.image = backImage;
            cell.moreBtn.frame = CGRectMake(62, cell.backImgV.frame.origin.y+cell.backImgV.frame.size.height, [dm getInstance].width-60-5, 30);
            cell.frame = CGRectMake(0, 0, [dm getInstance].width, cell.mLab_time.frame.origin.y+cell.mLab_time.frame.size.height+temp+9+33);
        }
    }

    cell.tableview.backgroundColor = [UIColor clearColor];
 

    return cell;
}

-(CGFloat)cellHeight:(NSIndexPath *)indexPath{
    CGFloat tempFloat = 0;
    //找到当前应该显示的数组
    NSMutableArray *array = [NSMutableArray array];
    if (indexPath.section == 0) {
        if (self.mInt_index == 2) {
            array = [NSMutableArray arrayWithArray:self.mArr_unitTop];
        }else if (self.mInt_index == 3){
            array = [NSMutableArray arrayWithArray:self.mArr_classTop];
        }else if (self.mInt_index == 1){
            array = [NSMutableArray arrayWithArray:self.mArr_local];
        }else if (self.mInt_index == 4){
            array = [NSMutableArray arrayWithArray:self.mArr_attention];
        }else if (self.mInt_index == 0){
            array = [NSMutableArray arrayWithArray:self.mArr_sum];
        }
    }else{
        if (self.mInt_index == 2) {
            array = [NSMutableArray arrayWithArray:self.mArr_unit];
        }else if (self.mInt_index == 3){
            array = [NSMutableArray arrayWithArray:self.mArr_class];
        }else if (self.mInt_index == 1){
            array = [NSMutableArray arrayWithArray:self.mArr_local];
        }else if (self.mInt_index == 4){
            array = [NSMutableArray arrayWithArray:self.mArr_attention];
        }else if (self.mInt_index == 0){
            array = [NSMutableArray arrayWithArray:self.mArr_sum];
        }
    }
    
    //显示具体界面
    ClassModel *model = [array objectAtIndex:indexPath.row];
    tempFloat = tempFloat +18+21;
    tempFloat = tempFloat +21;
    //文章logo
    CGSize contentSize;
    //详情
    contentSize = [model.Abstracts sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake([dm getInstance].width-72, 99999)];
    if (contentSize.height>26) {
        contentSize = CGSizeMake([dm getInstance].width-82, 30);
    }
    if (model.Abstracts.length==0) {
        contentSize = CGSizeMake([dm getInstance].width-82, 0);
    }
    tempFloat = tempFloat +4+contentSize.height;
    //是否有文章图片需要显示
    if (model.Thumbnail.count>0) {
        //最多显示6个图片
        int a;
        if (model.Thumbnail.count>=3) {
            a=3;
        }else{
            a = (int)model.Thumbnail.count;
        }
        //显示图片的宽度
        int m = ([dm getInstance].width-82)/3;
        //开始塞图片
        BOOL notFirst = NO;
        float y = 5;    float x = 0;
        
        for (int i=0; i<a; i++,x++) {
            if ((i%3)==0 && notFirst) {
                y = y+(m+5);
                x = 0;
            }
        }
        tempFloat = tempFloat+m+10;
    }else{
        
    }
    NSUInteger h = 0;
    for(int i=0;i<model.mArr_comment.count;i++)
    {
        commentsListModel *tempModel = [model.mArr_comment objectAtIndex:i];
        
        NSString *string1 = tempModel.UserName;
        NSString *string2 = tempModel.Commnets;
        string1 = [string1 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        RCLabel *contentLabel = [[RCLabel alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width-65, 100)];

        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.font = [UIFont systemFontOfSize:14];
        NSString *string = [NSString stringWithFormat:@"%@:%@",string1,string2];
        NSMutableAttributedString *titleAttriString = [[NSMutableAttributedString alloc] initWithString:string];
        [titleAttriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:[NSString stringWithFormat:@"%@:",string1]]];
        NSString *name = [NSString stringWithFormat:@"<font size=13 color='#3229CA'>%@：</font> <font size=13 color=black>%@</font>",string1,string2];
        NSMutableDictionary *row4 = [NSMutableDictionary dictionary];
        [row4 setObject:name forKey:@"text"];
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[row4 objectForKey:@"text"]];
        contentLabel.componentsAndPlainText = componentsDS;
        CGSize optimalSize2 = [contentLabel optimumSize];

        
        h = h+optimalSize2.height;
    }
    
    if(model.mArr_comment.count == 0){
        tempFloat = tempFloat+21+10+5;
    }else{
        if(model.mArr_comment.count<5){
            tempFloat = tempFloat+21+h+15+3+10+10;
        }else{
            tempFloat = tempFloat+21+h+15+30+5+5+10+10;
        }
    }
    return tempFloat;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.mView_popup.hidden = YES;
    self.mView_text.hidden = YES;
    [self.mTextF_text resignFirstResponder];
}

//评论的点击
-(void)didSelectedCell{
    self.mView_popup.hidden = YES;
    self.mView_text.hidden = YES;
    [self.mTextF_text resignFirstResponder];
}

//点击内容或者标题时触发cell点击事件
-(void)ClassTableViewCellContentPress:(ClassTableViewCell *)classCell{
    [MobClick event:@"ClassView_didSelectRow" label:@""];

//    NSString *aid = classCell.mModel_class.TabIDStr;
//    if (self.mInt_index == 2 ){
//        for (int i=0; i<self.mArr_unitTop.count; i++) {
//            ClassModel *classModel = [self.mArr_unitTop objectAtIndex:i];
//            if ([classModel.TabIDStr isEqual:aid]) {
//                classModel.ClickCount = [NSString stringWithFormat:@"%d",[classModel.ClickCount intValue]+1];
//                break;
//            }
//        }
//        for (int i=0; i<self.mArr_unit.count; i++) {
//            ClassModel *classModel = [self.mArr_unit objectAtIndex:i];
//            if ([classModel.TabIDStr isEqual:aid]) {
//                classModel.ClickCount = [NSString stringWithFormat:@"%d",[classModel.ClickCount intValue]+1];
//                break;
//            }
//        }
//    }else if (self.mInt_index == 3 ){
//        for (int i=0; i<self.mArr_classTop.count; i++) {
//            ClassModel *classModel = [self.mArr_classTop objectAtIndex:i];
//            if ([classModel.TabIDStr isEqual:aid]) {
//                classModel.ClickCount = [NSString stringWithFormat:@"%d",[classModel.ClickCount intValue]+1];
//                break;
//            }
//        }
//        for (int i=0; i<self.mArr_class.count; i++) {
//            ClassModel *classModel = [self.mArr_class objectAtIndex:i];
//            if ([classModel.TabIDStr isEqual:aid]) {
//                classModel.ClickCount = [NSString stringWithFormat:@"%d",[classModel.ClickCount intValue]+1];
//                break;
//            }
//        }
//    }else if (self.mInt_index == 1 ){
//        for (int i=0; i<self.mArr_local.count; i++) {
//            ClassModel *classModel = [self.mArr_local objectAtIndex:i];
//            if ([classModel.TabIDStr isEqual:aid]) {
//                classModel.ClickCount = [NSString stringWithFormat:@"%d",[classModel.ClickCount intValue]+1];
//                break;
//            }
//        }
//    }else if (self.mInt_index == 4 ){
//        for (int i=0; i<self.mArr_attention.count; i++) {
//            ClassModel *classModel = [self.mArr_attention objectAtIndex:i];
//            if ([classModel.TabIDStr isEqual:aid]) {
//                classModel.ClickCount = [NSString stringWithFormat:@"%d",[classModel.ClickCount intValue]+1];
//                break;
//            }
//        }
//    }else if (self.mInt_index == 0 ){
//        for (int i=0; i<self.mArr_sum.count; i++) {
//            ClassModel *classModel = [self.mArr_sum objectAtIndex:i];
//            if ([classModel.TabIDStr isEqual:aid]) {
//                classModel.ClickCount = [NSString stringWithFormat:@"%d",[classModel.ClickCount intValue]+1];
//                break;
//            }
//        }
//    }
//    [self.mTableV_list reloadData];
    self.mView_popup.hidden = YES;
    self.mView_text.hidden = YES;
    [self.mTextF_text resignFirstResponder];
    //转model
    TopArthListModel *model = [[TopArthListModel alloc] init];
    model.TabIDStr = classCell.mModel_class.TabIDStr;
    model.ClickCount = classCell.mModel_class.ClickCount;
    model.Context = classCell.mModel_class.Context;
    model.JiaoBaoHao = classCell.mModel_class.JiaoBaoHao;
    model.LikeCount = classCell.mModel_class.LikeCount;
    model.RecDate = classCell.mModel_class.RecDate;
    model.Source = classCell.mModel_class.Source;
    model.StarJson = classCell.mModel_class.StarJson;
    model.State = classCell.mModel_class.State;
    model.Title = classCell.mModel_class.Title;
    model.ViewCount = classCell.mModel_class.ViewCount;
    model.SectionID = classCell.mModel_class.SectionID;
    model.UserName = classCell.mModel_class.UserName;
    
    ArthDetailViewController *arth = [[ArthDetailViewController alloc] init];
    arth.Arthmodel = model;
    [utils pushViewController:arth animated:YES];
    D("test");
}

//发表文章按钮
-(void)clickPosting:(UIButton *)btn
{
    UnitSectionMessageModel *model = [[UnitSectionMessageModel alloc] init];
    model.UnitID = [NSString stringWithFormat:@"%d",[dm getInstance].UID];
    model.UnitType = [NSString stringWithFormat:@"%d",[dm getInstance].uType];
    SharePostingViewController *posting = [[SharePostingViewController alloc] init];
    posting.mModel_unit = model;
    posting.mInt_section = 0;
    [utils pushViewController:posting animated:YES];
}

//点击senction中的更多
-(void)clickMoreUnit{
    ClassTopViewController *topView = [[ClassTopViewController alloc] init];
    if (self.mInt_index ==2) {
        topView.mInt_unit_class = 1;
        topView.mStr_navName = @"单位动态";
    }else{
        topView.mInt_unit_class = 2;
        topView.mStr_navName = @"班级动态";
    }
    [MobClick event:@"ClassView_MoreUnit" label:@""];
    [utils pushViewController:topView animated:YES];
}

-(void)ProgressViewLoad:(NSString *)title{
    self.mView_popup.hidden = YES;
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    [MBProgressHUD showMessage:title toView:self];
}
//检查当前网络是否可用
-(BOOL)checkNetWork{
    if([Reachability isEnableNetwork]==NO){
        [self.mTableV_list headerEndRefreshing];
        [self.mTableV_list footerEndRefreshing];
        [MBProgressHUD showError:NETWORKENABLE toView:self];
        return YES;
    }else{
        return NO;
    }
}

-(void)noMore{
    sleep(1);
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    //标注为刷新
    self.mInt_flag = 1;
    if ([dm getInstance].UID ==0) {
        [self.mTableV_list headerEndRefreshing];
        [self.mTableV_list footerEndRefreshing];
        [self.mTableV_list reloadData];
    }else{
        
        //刚进入学校圈，或者下拉刷新时执行
        [self tableViewDownReloadData];
    }
}
- (void)footerRereshing{
    //不是刷新
    self.mInt_flag = 0;
    if ([dm getInstance].UID ==0) {
        [self.mTableV_list headerEndRefreshing];
        [self.mTableV_list footerEndRefreshing];
        [self.mTableV_list reloadData];
    }else{
        
        if (self.mInt_index == 2) {
            if (self.mArr_unit.count>=5&&self.mArr_unit.count%5==0) {
                //检查当前网络是否可用
                if ([self checkNetWork]) {
                    return;
                }
                int a = (int)self.mArr_unit.count/5+1;
                [[ClassHttp getInstance] classHttpUnitArthListIndex:[NSString stringWithFormat:@"%d",a] Num:@"5" Flag:@"1" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"1"];
                [self ProgressViewLoad:@"加载中..."];
            } else {
                [self loadNoMore:@"没有更多了"];
            }
        }else if (self.mInt_index == 3){
            if (self.mArr_class.count>=5&&self.mArr_class.count%5==0) {
                //检查当前网络是否可用
                if ([self checkNetWork]) {
                    return;
                }
                int a = (int)self.mArr_class.count/5+1;
                [[ClassHttp getInstance] classHttpAllMyClassArthList:[NSString stringWithFormat:@"%d",a] Num:@"5" sectionFlag:@"1" RequestFlag:@"1"];//个人
                [self ProgressViewLoad:@"加载中..."];
            } else {
                [self loadNoMore:@"没有更多了"];
            }
        }else if (self.mInt_index == 1){
            if (self.mArr_local.count>=5&&self.mArr_local.count%5==0) {
                //检查当前网络是否可用
                if ([self checkNetWork]) {
                    return;
                }
                int a = (int)self.mArr_local.count/5+1;
                [[ClassHttp getInstance] classHttpShowingUnitArthList:[NSString stringWithFormat:@"%d",a] Num:@"5" topFlags:@"1" flag:@"local" RequestFlag:@"1"];
                [self ProgressViewLoad:@"加载中..."];
            } else {
                [self loadNoMore:@"没有更多了"];
            }
        }else if (self.mInt_index == 4){
            if (self.mArr_attention.count>=5&&self.mArr_attention.count%5==0) {
                //检查当前网络是否可用
                if ([self checkNetWork]) {
                    return;
                }
                int a = (int)self.mArr_attention.count/5+1;
                [[ClassHttp getInstance] classHttpMyAttUnitArthListIndex:[NSString stringWithFormat:@"%d",a] Num:@"5" accid:[dm getInstance].jiaoBaoHao];
                [self ProgressViewLoad:@"加载中..."];
            } else {
                [self loadNoMore:@"没有更多了"];
            }
        }else if (self.mInt_index == 0){
            if (self.mArr_sum.count>=5&&self.mArr_sum.count%5==0) {
                //检查当前网络是否可用
                if ([self checkNetWork]) {
                    return;
                }
                int a = (int)self.mArr_sum.count/5+1;
                [[ClassHttp getInstance] classHttpShowingUnitArthList:[NSString stringWithFormat:@"%d",a] Num:@"5" topFlags:@"1" flag:@"" RequestFlag:@"2"];
                [self ProgressViewLoad:@"加载中..."];
            } else {
                [self loadNoMore:@"没有更多了"];
            }
        }
    }
}

-(void)loadNoMore:(NSString *)title{
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    [MBProgressHUD showSuccess:title toView:self];
}


//点击点赞评论按钮
-(void)ClassTableViewCellCommentBtn:(ClassTableViewCell *)topArthListCell Btn:(UIButton *)btn{
    if (self.mView_popup.hidden == YES) {
        self.mView_popup.mModel_class = topArthListCell.mModel_class;
        //得到当前点击的button相对于整个view的坐标
        CGRect parentRect = [btn convertRect:btn.bounds toView:self];
        self.mView_popup.hidden = NO;
        self.mView_popup.frame = CGRectMake(parentRect.origin.x-120, parentRect.origin.y, self.mView_popup.frame.size.width, self.mView_popup.frame.size.height);
        if (topArthListCell.mModel_class.mModel_info.TabID >0) {//获取到
            if (topArthListCell.mModel_class.mModel_info.Likeflag >=0){//没有点赞，发送点赞请求
                [self.mView_popup.mBtn_like setTitle:@"点赞" forState:UIControlStateNormal];
            }else{//已赞
                [self.mView_popup.mBtn_like setTitle:@"已赞" forState:UIControlStateNormal];
            }
        }else{
            [self.mView_popup.mBtn_like setTitle:@"点赞" forState:UIControlStateNormal];
        }
    }else{
        self.mView_popup.hidden = YES;
    }
}

//向cell中添加图片点击手势
- (void) ClassTableViewCellTapPress0:(ClassTableViewCell *) topArthListCell ImgV:(UIImageView *)img{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray array];
//    for (int i = 0; i < [topArthListCell.mModel_class.Thumbnail count]; i++) {
//        // 替换为中等尺寸图片
//        NSString * getImageStrUrl = [NSString stringWithFormat:@"%@", [topArthListCell.mModel_class.Thumbnail objectAtIndex:i]];
//        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.url = [NSURL URLWithString: getImageStrUrl]; // 图片路径
//        UIImageView * imageView = (UIImageView *)[self viewWithTag: i+10000];
//        photo.srcImageView = imageView;
//        [photos addObject:photo];
//    }
//    
//    // 2.显示相册
//    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
//    browser.photos = photos; // 设置所有的图片
//    [browser show];
    for (int i = 0; i < [topArthListCell.mModel_class.Thumbnail count]; i++) {
        // 替换为中等尺寸图片
        NSString * getImageStrUrl = [NSString stringWithFormat:@"%@", [topArthListCell.mModel_class.Thumbnail objectAtIndex:i]];
        D("getImageStrUrl-====%@",getImageStrUrl);
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:getImageStrUrl]]];
    }
    self.photos = photos;
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
    [browser setCurrentPhotoIndex:0];
    
    double delayInSeconds = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
    });
    [utils pushViewController:browser animated:YES];
}

- (void) ClassTableViewCellTapPress1:(ClassTableViewCell *) topArthListCell ImgV:(UIImageView *)img{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray array];
//    for (int i = 0; i < [topArthListCell.mModel_class.Thumbnail count]; i++) {
//        // 替换为中等尺寸图片
//        NSString * getImageStrUrl = [NSString stringWithFormat:@"%@", [topArthListCell.mModel_class.Thumbnail objectAtIndex:i]];
//        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.url = [NSURL URLWithString: getImageStrUrl]; // 图片路径
//        UIImageView * imageView = (UIImageView *)[self viewWithTag: i+10000];
//        photo.srcImageView = imageView;
//        [photos addObject:photo];
//    }
//    
//    // 2.显示相册
//    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//    browser.currentPhotoIndex = 1; // 弹出相册时显示的第一张图片是？
//    browser.photos = photos; // 设置所有的图片
//    [browser show];
    for (int i = 0; i < [topArthListCell.mModel_class.Thumbnail count]; i++) {
        // 替换为中等尺寸图片
        NSString * getImageStrUrl = [NSString stringWithFormat:@"%@", [topArthListCell.mModel_class.Thumbnail objectAtIndex:i]];
        D("getImageStrUrl-====%@",getImageStrUrl);
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:getImageStrUrl]]];
    }
    self.photos = photos;
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
    [browser setCurrentPhotoIndex:1];
    
    double delayInSeconds = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
    });
    [utils pushViewController:browser animated:YES];
//    self.navigationController.title = @"";
//    [self.navigationController pushViewController:browser animated:YES];
}


- (void) ClassTableViewCellTapPress2:(ClassTableViewCell *) topArthListCell ImgV:(UIImageView *)img{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray array];
//    for (int i = 0; i < [topArthListCell.mModel_class.Thumbnail count]; i++) {
//        // 替换为中等尺寸图片
//        NSString * getImageStrUrl = [NSString stringWithFormat:@"%@", [topArthListCell.mModel_class.Thumbnail objectAtIndex:i]];
//        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.url = [NSURL URLWithString: getImageStrUrl]; // 图片路径
//        UIImageView * imageView = (UIImageView *)[self viewWithTag: i+10000];
//        photo.srcImageView = imageView;
//        [photos addObject:photo];
//    }
//    
//    
//    // 2.显示相册
//    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//    browser.currentPhotoIndex = 2; // 弹出相册时显示的第一张图片是？
//    browser.photos = photos; // 设置所有的图片
//    [browser show];
    for (int i = 0; i < [topArthListCell.mModel_class.Thumbnail count]; i++) {
        // 替换为中等尺寸图片
        NSString * getImageStrUrl = [NSString stringWithFormat:@"%@", [topArthListCell.mModel_class.Thumbnail objectAtIndex:i]];
        D("getImageStrUrl-====%@",getImageStrUrl);
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:getImageStrUrl]]];
    }
    self.photos = photos;
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
    [browser setCurrentPhotoIndex:2];
    
    double delayInSeconds = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
    });
    [utils pushViewController:browser animated:YES];
}
-(void)ClassTableViewCellHeadImgTapPress:(ClassTableViewCell *)topArthListCell{
    ClassModel *ClassModel = topArthListCell.mModel_class;
    if ([ClassModel.flag intValue] ==1) {//展示
        UnitSectionMessageModel *model = [[UnitSectionMessageModel alloc] init];
        model.UnitID = ClassModel.unitId;
        model.UnitID2 = ClassModel.unitId2;
        if (ClassModel.className.length>0) {
            model.UnitName = ClassModel.className;
        }else{
            model.UnitName = ClassModel.UnitName;
        }
        
        model.UnitType = ClassModel.UnitType;
        UnitSpaceViewController *space = [[UnitSpaceViewController alloc] init];
        space.mModel_unit = model;
        [utils pushViewController:space animated:YES];
    }else{//分享
        //生成个人信息
        UserInfoByUnitIDModel *userModel = [[UserInfoByUnitIDModel alloc] init];
        userModel.UserID = ClassModel.JiaoBaoHao;
        userModel.UserName = ClassModel.UserName;
        userModel.AccID = ClassModel.JiaoBaoHao;
        
        PersonalSpaceViewController *personal = [[PersonalSpaceViewController alloc] init];
        personal.mModel_personal = userModel;
        [utils pushViewController:personal animated:YES];
    }
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
//    [self dismissViewControllerAnimated:YES completion:nil];
    [utils popViewControllerAnimated:YES];
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
                         self.mView_text.hidden = NO;
                         self.mView_text.frame = CGRectMake(0, [dm getInstance].height-keyboardSize.height-51*2-10, [dm getInstance].width, 51);
                     }
                     completion:^(BOOL finished){
                         ;
                     }];
}
- (void) keyboardWasHidden:(NSNotification *) notif{
    self.mView_text.hidden = YES;
    NSDictionary *userInfo = [notif userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.mView_text.frame = CGRectMake(0, [dm getInstance].height, [dm getInstance].width, 51);
                     }
                     completion:^(BOOL finished){
                         ;
                     }];
}

//键盘点击DO
#pragma mark - UITextView Delegate Methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        self.mView_text.hidden = YES;
        [textField resignFirstResponder];
        //若其有输入内容，则发送
        if (self.mTextF_text.text.length>0) {
            [self clickSendBtn:nil];
        }
        return NO;
    }
    return YES;
}

//当切换账号时，将此界面的所有数组清空
-(void)clearArray{
    [self.mArr_attention removeAllObjects];
    [self.mArr_attentionTop removeAllObjects];
    [self.mArr_class removeAllObjects];
    [self.mArr_classTop removeAllObjects];
    [self.mArr_local removeAllObjects];
    [self.mArr_localTop removeAllObjects];
    [self.mArr_sum removeAllObjects];
    [self.mArr_sumTop removeAllObjects];
    [self.mArr_unit removeAllObjects];
    [self.mArr_unitTop removeAllObjects];
}


@end

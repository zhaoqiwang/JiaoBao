//
//  ArthDetailViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-11-21.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "ArthDetailViewController.h"
#import "Reachability.h"
#import "MobClick.h"
#import "IQKeyboardManager.h"

@interface ArthDetailViewController ()

@end

@implementation ArthDetailViewController
@synthesize mNav_navgationBar,mWebV_js,Arthmodel,mImgV_click,mImgV_like,mImgV_View,mLab_click,mLab_like,mLab_name,mLab_time,mLab_title,mLab_View,mScrollV_view,mModel,mInt_from,mStr_tableID,mStr_title,mModel_notice,mBtn_send,mTextF_text,mView_text,mArr_feeback,mBtn_more,mInt_page,mTableV_detail,mModel_commentList,mModel_arthInfo;

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:UMMESSAGE];
    [MobClick endLogPageView:UMPAGE];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:UMMESSAGE];
    [MobClick beginLogPageView:UMPAGE];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    //通知文章详情界面刷新
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ArthDetai" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ArthDetai:) name:@"ArthDetai" object:nil];
    //通知文章详情界面刷新点赞
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AirthLikeIt" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AirthLikeIt:) name:@"AirthLikeIt" object:nil];
    //文章评论
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AirthAddComment" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AirthAddComment:) name:@"AirthAddComment" object:nil];
    //将获取到的评论列表传到界面
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AirthCommentsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AirthCommentsList:) name:@"AirthCommentsList" object:nil];
    //将踩、顶回复返回界面
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AirthAddScore" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AirthAddScore:) name:@"AirthAddScore" object:nil];
    //评论列表头像
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"exchangeGetFaceImg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TopArthListIndexImg:) name:@"exchangeGetFaceImg" object:nil];
    //键盘事件
    [IQKeyboardManager sharedManager].enable = NO;//控制整个功能是否启用
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    //获取文章的附加信息
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetArthInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetArthInfo:) name:@"GetArthInfo" object:nil];
}

-(void)dealloc{
    mWebV_js.delegate = nil;
    [mWebV_js loadHTMLString:@"" baseURL:nil];
    [mWebV_js stopLoading];
    [mWebV_js removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //区分来自分享和展示1还是内务2,然后发不同的请求
    if (self.mInt_from == 2) {
        self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_title];
    }else{
        self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.Arthmodel.Title];
    }
    self.mModel_commentList = [[CommentsListObjModel alloc] init];
    self.mModel_arthInfo = [[GetArthInfoModel alloc] init];
    //添加导航条
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
//    self.mScrollV_view.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    
    [self sendRequest];
    
    //设置webview属性
    self.mWebV_js.scalesPageToFit = NO;
    [self.mWebV_js.scrollView setScrollEnabled:NO];
    
    //添加点击
    self.mImgV_like.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLikeImg)];
    [self.mImgV_like addGestureRecognizer:tap];
    
    self.mScrollV_view.frame = CGRectMake(0, 44+[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height-51);
    self.mTableV_detail.frame = CGRectMake(0, 0, 0, 0);
    //输入View坐标
    self.mView_text.frame = CGRectMake(0, [dm getInstance].height-51, [dm getInstance].width, 51);
    //输入框
    self.mTextF_text.frame = CGRectMake(15, 10, [dm getInstance].width-15-70, 51-20);
    //发送按钮
    self.mBtn_send.frame = CGRectMake([dm getInstance].width-65, 0, 60, 51);
    [self.mBtn_send addTarget:self action:@selector(clickSendBtn) forControlEvents:UIControlEventTouchUpInside];
}

-(void)sendRequest{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    //区分来自分享和展示1还是内务2,然后发不同的请求
    if (self.mInt_from == 2) {
        [[ShareHttp getInstance] NoticeHttpGetShowNoticeDetailWith:self.mStr_tableID];
        self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_title];
    }else{
        //获取文章详情
        [[ShareHttp getInstance] shareHttpGetShowArthDetailWith:self.Arthmodel.TabIDStr SectionID:self.Arthmodel.SectionID];
        //获取文章附加信息
        [[ShareHttp getInstance] shareHttpAirthGetArthInfo:self.Arthmodel.TabIDStr sid:self.Arthmodel.SectionID];
        self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.Arthmodel.Title];
    }
    D("model.tableID==%@,sectionID-===%@",self.Arthmodel.TabIDStr,self.Arthmodel.SectionID);
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
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

//获取文章的附加信息回调
-(void)GetArthInfo:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSString *flag = [noti.object objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        GetArthInfoModel *model = [noti.object objectForKey:@"model"];
        self.mModel_arthInfo = model;
        //判断文章是否有评论
        if (self.mModel_arthInfo.FeeBackCount>0) {
            //获取文章评论
            [[ShareHttp getInstance] shareHttpAirthCommentsList:self.Arthmodel.TabIDStr Page:@"1" Num:@"20" Flag:@""];
        }
        [self setArthInfo];
    }else{
        [MBProgressHUD showError:@"超时" toView:self.view];
    }
}

//点击发送按钮
-(void)clickSendBtn{

    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    
    D("点击发送按钮");
    if (self.mTextF_text.text.length==0) {
        [MBProgressHUD showError:@"请输入内容" toView:self.view];
        return;
    }
    [MobClick event:@"ArthDetail_clickSendBtn" label:@""];
    NSArray *array = [self.mTextF_text.text componentsSeparatedByString:@":"];
    int a=0;
    if (array.count>0) {
        NSString *tempStr = [array objectAtIndex:0];
        for (int i=0; i<self.mModel_commentList.commentsList.count; i++) {
            commentsListModel *model = [self.mModel_commentList.commentsList objectAtIndex:i];
            NSString *modelStr = [NSString stringWithFormat:@"回复%@",model.Number];
            if ([modelStr isEqual:tempStr]) {
                NSString *text = [self.mTextF_text.text substringFromIndex:3+model.Number.length];
                //判断回复几楼的，内容是否为空
                if (text.length==0) {
                    [MBProgressHUD showError:@"请输入内容" toView:self.view];
                    break;
                    return;
                }
                a++;
                [[ShareHttp getInstance] shareHttpAirthAddComment:self.Arthmodel.TabIDStr content:text refid:model.TabIDStr];
                [self progressViewShow:@"提交中"];
                [self.mTextF_text resignFirstResponder];
            }
        }
    }
    if (array.count==1&&a==0) {
        [[ShareHttp getInstance] shareHttpAirthAddComment:self.Arthmodel.TabIDStr content:self.mTextF_text.text refid:@""];
        [self progressViewShow:@"提交中"];
        [self.mTextF_text resignFirstResponder];
    }
}

//点赞按钮
-(void)tapLikeImg{
    //检查当前网络是否可用
    if ([self checkNetWork]){
        return;
    }
    [MobClick event:@"ArthDetail_tapLikeImg" label:@""];
    if (self.mModel_arthInfo.Likeflag >=0){
        [[ShareHttp getInstance] shareHttpAirthLikeIt:self.mModel.TabIDStr Flag:[NSString stringWithFormat:@"%d",self.mModel_arthInfo.Likeflag]];
        [self progressViewShow:@"提交中"];
    }
}

//将踩、顶回复返回界面
-(void)AirthAddScore:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *uid = [dic objectForKey:@"uid"];
    NSString *tp = [dic objectForKey:@"tp"];
    NSString *name = [dic objectForKey:@"name"];
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        [MBProgressHUD showSuccess:name toView:self.view];
        //循环当前显示数组
        for (int i=0; i<self.mModel_commentList.commentsList.count; i++) {
            commentsListModel *model = [self.mModel_commentList.commentsList objectAtIndex:i];
            if ([model.TabIDStr isEqual:uid]&&[tp intValue] ==0) {
                model.CaiCount = [NSString stringWithFormat:@"%d",[model.CaiCount intValue]+1];
            }else if ([model.TabIDStr isEqual:uid]&&[tp intValue] ==1){
                model.LikeCount = [NSString stringWithFormat:@"%d",[model.LikeCount intValue]+1];
            }
        }
        //循环引用数组
        for (int i=0; i<self.mModel_commentList.refcomments.count; i++) {
            refcommentsModel *model = [self.mModel_commentList.refcomments objectAtIndex:i];
            if ([model.TabIDStr isEqual:uid]&&[tp intValue] ==0) {
                model.CaiCount = [NSString stringWithFormat:@"%d",[model.CaiCount intValue]+1];
            }else if ([model.TabIDStr isEqual:uid]&&[tp intValue] ==1){
                model.LikeCount = [NSString stringWithFormat:@"%d",[model.LikeCount intValue]+1];
            }
        }
        [self.mTableV_detail reloadData];
    }else{
        [MBProgressHUD showError:name toView:self.view];
    }
}

//通知文章详情界面刷新点赞
-(void)AirthLikeIt:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSString *flag = [noti.object objectForKey:@"flag"];
    NSString *str = [noti.object objectForKey:@"str"];
    if ([flag integerValue]==0) {
        [MBProgressHUD showSuccess:str toView:self.view];
        self.mModel_arthInfo.LikeCount = self.mModel_arthInfo.LikeCount+1;
        self.mModel_arthInfo.Likeflag = -1;
        self.mModel.Likeflag = @"1";
        //点赞个数
        self.mLab_like.text = [NSString stringWithFormat:@"%d",self.mModel_arthInfo.LikeCount];
        //赞图标
        self.mImgV_like.image = [UIImage imageNamed:[NSString stringWithFormat:@"share_likeBig_1"]];
    }else{
        [MBProgressHUD showError:str toView:self.view];
    }
}

//文章评论
-(void)AirthAddComment:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSString *flag = [noti.object objectForKey:@"flag"];
    NSString *str = [noti.object objectForKey:@"str"];
    if ([flag integerValue]==0) {
        if ([str isEqualToString:@"评论成功"]) {
            self.mTextF_text.text = @"";
        }
        //获取文章评论
        [[ShareHttp getInstance] shareHttpAirthCommentsList:self.Arthmodel.TabIDStr Page:@"1" Num:@"20" Flag:@""];
        [self progressViewShow:@"评论成功，刷新列表中"];
        [self.mModel_commentList.commentsList removeAllObjects];
        [self.mModel_commentList.refcomments removeAllObjects];
    }else{
        [MBProgressHUD showError:str toView:self.view];
    }
}

//获取到头像后，更新界面
-(void)TopArthListIndexImg:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    //刷新
    [self.mTableV_detail reloadData];
}

//将获取到的评论列表传到界面
-(void)AirthCommentsList:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        CommentsListObjModel *model = [dic objectForKey:@"model"];
        if (self.mModel_commentList.commentsList.count==0) {
            self.mModel_commentList = model;
        }else{
            //添加数组
            [self.mModel_commentList.commentsList addObjectsFromArray:model.commentsList];
            //将引用去重
            for (int i=0; i<model.refcomments.count; i++) {
                int a=0;
                refcommentsModel *tempRef = [model.refcomments objectAtIndex:i];
                for (int m=0; m<self.mModel_commentList.refcomments.count; m++) {
                    refcommentsModel *tempRef2 = [self.mModel_commentList.refcomments objectAtIndex:m];
                    if ([tempRef.TabIDStr isEqual:tempRef2.TabIDStr]) {
                        a++;
                    }
                }
                if (a==0) {
                    [self.mModel_commentList.refcomments addObject:tempRef];
                }
            }
        }
        
        [self.mTableV_detail reloadData];
        //设置布局
        [self setFrame];
    }else{
        [MBProgressHUD showError:@"超时" toView:self.view];
    }
}

//设置界面布局
-(void)setFrame{
//    self.mTableV_detail.frame = CGRectMake(0, self.mImgV_click.frame.origin.y+self.mImgV_click.frame.size.height+10, [dm getInstance].width, [self tableViewHeight]);
    self.mTableV_detail.frame = CGRectMake(0, self.mImgV_click.frame.origin.y+self.mImgV_click.frame.size.height+10, [dm getInstance].width, self.mTableV_detail.contentSize.height);
    int a = (int)self.mModel_commentList.commentsList.count;
    if (a>0&&(a%20)==0) {
        self.mBtn_more.hidden = NO;
        self.mBtn_more.frame = CGRectMake(0, self.mTableV_detail.frame.origin.y+self.mTableV_detail.frame.size.height, [dm getInstance].width, 44);
    }else{
        self.mBtn_more.hidden = YES;
        self.mBtn_more.frame = self.mTableV_detail.frame;
    }
    self.mScrollV_view.contentSize = CGSizeMake([dm getInstance].width, self.mBtn_more.frame.origin.y+self.mBtn_more.frame.size.height);
}

//更多按钮点击
-(IBAction)mBtn_more:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    int a = (int)self.mModel_commentList.commentsList.count;
    int b = a/20+1;
    //获取文章评论
    [[ShareHttp getInstance] shareHttpAirthCommentsList:self.Arthmodel.TabIDStr Page:[NSString stringWithFormat:@"%d",b] Num:@"20" Flag:@""];
    [self progressViewShow:@"获取中"];
}

//计算表格的总高度
//-(int)tableViewHeight{
//    int a=0;
//    for (int i=0; i<self.mModel_commentList.commentsList.count; i++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection: 0];
//        UITableViewCell *cell= [self tableView:self.mTableV_detail cellForRowAtIndexPath:indexPath];
//        a = a + cell.frame.size.height;
//    }
//    
//    return a;
//}

//文章详情通知
-(void)ArthDetai:(NSNotification *)noti{
//    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        if (self.mInt_from == 2) {
            self.mModel_notice = [dic objectForKey:@"model"];
            NSString *str = [self.mModel_notice.NoticMsg stringByReplacingOccurrencesOfString:@"nowrap" withString:@"no wrap"];
            for (int i=320; i<1000; i++) {
                str = [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"width: %dpx ",i] withString:@" "];
                str = [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"_width=\"%dpx\"",i] withString:@" "];
            }
            str = [str stringByReplacingOccurrencesOfString:@"top: -" withString:@"top: +"];
            str = [str stringByReplacingOccurrencesOfString:@"top:-" withString:@"top:+"];
            str = [str stringByReplacingOccurrencesOfString:@"data-src" withString:@"src"];
            str = [str stringByReplacingOccurrencesOfString:@"width=\"auto\" _width=\"auto\"" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"width: auto" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"width:auto" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"\\n" withString:@"<br/>"];
            str = [str stringByReplacingOccurrencesOfString:@"width=" withString:@""];
//            str = [str stringByReplacingOccurrencesOfString:@"<img" withString:@"<img width=\"310\"; height\"200\"; "];
            //标题
            CGSize numSize = [[NSString stringWithFormat:@"%@",self.mModel_notice.Subject] sizeWithFont:[UIFont systemFontOfSize:14]];
            self.mLab_title.frame = CGRectMake(0, 5, [dm getInstance].width, numSize.height);
            self.mLab_title.text = self.mModel_notice.Subject;
            //作者
            CGSize nameSize = [[NSString stringWithFormat:@"作者:%@",self.mModel_notice.UserName] sizeWithFont:[UIFont systemFontOfSize:13]];
            self.mLab_name.frame = CGRectMake(5, self.mLab_title.frame.origin.y+self.mLab_title.frame.size.height+5, nameSize.width, nameSize.height);
            self.mLab_name.text = [NSString stringWithFormat:@"作者:%@",self.mModel_notice.UserName];
            //时间
            CGSize timeSize = [self.mModel_notice.Recdate sizeWithFont:[UIFont systemFontOfSize:13]];
            self.mLab_time.frame = CGRectMake(self.mLab_name.frame.size.width+15, self.mLab_name.frame.origin.y, timeSize.width, timeSize.height);
            self.mLab_time.text = self.mModel_notice.Recdate;
            //内容
//            self.mWebV_js.frame = CGRectMake(0, self.mLab_name.frame.origin.y+self.mLab_name.frame.size.height+5, [dm getInstance].width, self.mScrollV_view.frame.size.height-self.mLab_name.frame.origin.y-self.mLab_name.frame.size.height-5);
//            NSString *tempHtml = [NSString stringWithFormat:@"<meta name=\"viewport\" content=\"width=%d,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no\" />%@",[dm getInstance].width,str];
//            tempHtml = [NSString stringWithFormat:@"<div style=width=300px>%@",tempHtml];
            str = [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<img"] withString:@"<img class=\"pic\""];
            NSString *tempHtml = [NSString stringWithFormat:@"<meta name=\"viewport\" style=width:%dpx, content=\"width=%d,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no\" /><style>.pic{max-width:%dpx; max-height: auto; width: expression(this.width >%d && this.height < this.width ? %d: true); height: expression(this.height > auto ? auto: true);}</style>%@",[dm getInstance].width,[dm getInstance].width,[dm getInstance].width,[dm getInstance].width,[dm getInstance].width,str];
            NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
            D("detail.url-====%@",tempHtml);
            [self.mWebV_js loadHTMLString:tempHtml baseURL:baseURL];
        }else{
            self.mModel = [dic objectForKey:@"model"];
            //        NSString *str = self.mModel.Context;
            NSString *str = [self.mModel.Context stringByReplacingOccurrencesOfString:@"nowrap" withString:@"no wrap"];
            for (int i=320; i<1000; i++) {
                str = [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"width: %d",i] withString:@" "];
                str = [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"_width=\"%dpx\"",i] withString:@" "];
            }
            str = [str stringByReplacingOccurrencesOfString:@"top: -" withString:@"top: +"];
            str = [str stringByReplacingOccurrencesOfString:@"top:-" withString:@"top:+"];
            str = [str stringByReplacingOccurrencesOfString:@"data-src" withString:@"src"];
            str = [str stringByReplacingOccurrencesOfString:@"width=\"auto\" _width=\"auto\"" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"width: auto" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"width:auto" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"\\n" withString:@"<br/>"];
            str = [str stringByReplacingOccurrencesOfString:@"width=" withString:@""];
//            str = [str stringByReplacingOccurrencesOfString:@"<img" withString:@"<img width=\"310\"; height\"200\"; "];
            
            //标题
            CGSize numSize = [[NSString stringWithFormat:@"%@",self.mModel.Title] sizeWithFont:[UIFont systemFontOfSize:14]];
            self.mLab_title.frame = CGRectMake(0, 5, [dm getInstance].width, numSize.height);
            self.mLab_title.text = self.mModel.Title;
            //作者
            CGSize nameSize = [[NSString stringWithFormat:@"作者:%@",self.mModel.UserName] sizeWithFont:[UIFont systemFontOfSize:13]];
            self.mLab_name.frame = CGRectMake(5, self.mLab_title.frame.origin.y+self.mLab_title.frame.size.height+5, nameSize.width, nameSize.height);
            self.mLab_name.text = [NSString stringWithFormat:@"作者:%@",self.mModel.UserName];
            //时间
            CGSize timeSize = [self.mModel.RecDate sizeWithFont:[UIFont systemFontOfSize:13]];
            self.mLab_time.frame = CGRectMake(self.mLab_name.frame.size.width+15, self.mLab_name.frame.origin.y, timeSize.width, timeSize.height);
            self.mLab_time.text = self.mModel.RecDate;
//            NSString *tempHtml = [NSString stringWithFormat:@"<meta name=\"viewport\" content=\"width=%d,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no\" />%@",[dm getInstance].width,str];
//            tempHtml = [NSString stringWithFormat:@"<div style=width=300px>%@",tempHtml];
            str = [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<img"] withString:@"<img class=\"pic\""];
            NSString *tempHtml = [NSString stringWithFormat:@"<meta name=\"viewport\" style=width:%dpx, content=\"width=%d,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no\" /><style>.pic{max-width:%dpx; max-height: auto; width: expression(this.width >%d && this.height < this.width ? %d: true); height: expression(this.height > auto ? auto: true);}</style>%@",[dm getInstance].width,[dm getInstance].width,[dm getInstance].width,[dm getInstance].width,[dm getInstance].width,str];
            //内容
//            self.mWebV_js.frame = CGRectMake(0, self.mLab_name.frame.origin.y+self.mLab_name.frame.size.height+5, [dm getInstance].width, self.mScrollV_view.frame.size.height-self.mLab_name.frame.origin.y-self.mLab_name.frame.size.height-5);
            NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
            D("url-====%@",tempHtml);
            [self.mWebV_js loadHTMLString:tempHtml baseURL:baseURL];
        }
    }else{
        [MBProgressHUD showError:@"获取文章详情超时" toView:self.view];
    }
}

//获取宽度已经适配于webView的html。这里的原始html也可以通过js从webView里获取
//- (NSString *)htmlAdjustWithPageWidth:(CGFloat )pageWidth
//                                 html:(NSString *)html
//                              webView:(UIWebView *)webView
//{
//    NSMutableString *str = [NSMutableString stringWithString:html];
//    //计算要缩放的比例
//    CGFloat initialScale = webView.frame.size.width/pageWidth;
//    D("initialScale-===%f,%f,%f",initialScale,pageWidth,webView.frame.size.width);
//    //将</head>替换为meta+head
//    NSString *stringForReplace = [NSString stringWithFormat:@"<meta name=\"viewport\" content=\" initial-scale=%f, minimum-scale=0.1, maximum-scale=2.0, user-scalable=yes\"></head>",initialScale];
//    
//    NSRange range =  NSMakeRange(0, str.length);
//    //替换
//    [str replaceOccurrencesOfString:@"</head>" withString:stringForReplace options:NSLiteralSearch range:range];
//    D("str-==%@",str);
//    return str;
//}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%d, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", [dm getInstance].width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    [MBProgressHUD hideHUDForView:self.view];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
    CGFloat webViewWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetWidth"]floatValue];
    D("webViewHeight-====%f,%f,%f",webViewHeight,self.mWebV_js.scrollView.frame.size.height,webViewWidth);
    D("webview.frame-===%@",NSStringFromCGSize(webView.scrollView.contentSize));
    if (self.mInt_from == 2) {
        //内容
//        self.mWebV_js.frame = CGRectMake(0, self.mLab_name.frame.origin.y+self.mLab_name.frame.size.height+5, [dm getInstance].width, webView.scrollView.contentSize.height);
        self.mWebV_js.frame = CGRectMake(0, self.mLab_name.frame.origin.y+self.mLab_name.frame.size.height+5, [dm getInstance].width, webViewHeight+10);
        self.mScrollV_view.contentSize = CGSizeMake([dm getInstance].width, self.mWebV_js.frame.origin.y+self.mWebV_js.frame.size.height);
        self.mLab_click.hidden = YES;
        self.mLab_like.hidden = YES;
        self.mLab_View.hidden = YES;
        self.mImgV_click.hidden = YES;
        self.mImgV_like.hidden = YES;
        self.mImgV_View.hidden = YES;
    }else{
        //内容
//        self.mWebV_js.frame = CGRectMake(0, self.mLab_name.frame.origin.y+self.mLab_name.frame.size.height+5, [dm getInstance].width, webView.scrollView.contentSize.height);
        self.mWebV_js.frame = CGRectMake(0, self.mLab_name.frame.origin.y+self.mLab_name.frame.size.height+5, [dm getInstance].width, webViewHeight+10);
        [self setArthInfo];
        //设置布局
        [self setFrame];
    }
}

//文章信息刷新
-(void)setArthInfo{
    //赞个数
    CGSize likeSize = [[NSString stringWithFormat:@"%d",self.mModel_arthInfo.LikeCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    self.mLab_like.frame = CGRectMake([dm getInstance].width-10-likeSize.width, self.mWebV_js.frame.origin.y+self.mWebV_js.frame.size.height+5, likeSize.width, 30);
    self.mLab_like.text = [NSString stringWithFormat:@"%d",self.mModel_arthInfo.LikeCount];
    //赞图标
    NSString *imgName;
    if (self.mModel_arthInfo.Likeflag >= 0) {
        imgName = @"share_likeBig_0";
    }else{
        imgName = @"share_likeBig_1";
    }
    UIImage *likeImg = [UIImage imageNamed:imgName];
    self.mImgV_like.frame = CGRectMake(self.mLab_like.frame.origin.x-30, self.mWebV_js.frame.origin.y+self.mWebV_js.frame.size.height+5, 30, 30);
    self.mImgV_like.image = likeImg;
    
    //阅读人数
    CGSize lookSize = [[NSString stringWithFormat:@"%d",self.mModel_arthInfo.ViewCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    self.mLab_View.frame = CGRectMake(self.mImgV_like.frame.origin.x-lookSize.width-5, self.mWebV_js.frame.origin.y+self.mWebV_js.frame.size.height+5, lookSize.width, 30);
    self.mLab_View.text = [NSString stringWithFormat:@"%d",self.mModel_arthInfo.ViewCount];
    //阅读图标
    UIImage *lookImg = [UIImage imageNamed:@"share_lookBig"];
    self.mImgV_View.frame = CGRectMake(self.mLab_View.frame.origin.x-30, self.mWebV_js.frame.origin.y+self.mWebV_js.frame.size.height+5, 30, 30);
    self.mImgV_View.image = lookImg;
    //点击人数
    CGSize clickSize = [[NSString stringWithFormat:@"%d",self.mModel_arthInfo.ClickCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    self.mLab_click.frame = CGRectMake(self.mImgV_View.frame.origin.x-clickSize.width-5, self.mWebV_js.frame.origin.y+self.mWebV_js.frame.size.height+5, clickSize.width, 30);
    self.mLab_click.text = [NSString stringWithFormat:@"%d",self.mModel_arthInfo.ClickCount];
    //点击图标
    UIImage *clickImg = [UIImage imageNamed:@"share_clickBig"];
    self.mImgV_click.frame = CGRectMake(self.mLab_click.frame.origin.x-30, self.mWebV_js.frame.origin.y+self.mWebV_js.frame.size.height+5, 30, 30);
    self.mImgV_click.image = clickImg;
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mModel_commentList.commentsList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"AirthCommentsListCell";
    AirthCommentsListCell *cell = (AirthCommentsListCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[AirthCommentsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AirthCommentsListCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell = (AirthCommentsListCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"AirthCommentsListCell" bundle:[NSBundle mainBundle]];
        [self.mTableV_detail registerNib:n forCellReuseIdentifier:indentifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.tag = indexPath.row;
    commentsListModel *model = [self.mModel_commentList.commentsList objectAtIndex:indexPath.row];
    //第几楼
    cell.mLab_Number.frame = CGRectMake(10, 10, 50, 15);
    cell.mLab_Number.text = model.Number;
    //头像

    [cell.mImg_head sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,model.JiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];
    //人名、单位名
    NSString *tempName = [NSString stringWithFormat:@"%@@%@",model.UserName,model.UnitShortname];
    CGSize sizeName = [tempName sizeWithFont:[UIFont systemFontOfSize:12]];
    cell.mLab_UnitShortname.frame = CGRectMake(70, 10, sizeName.width, 15);
    cell.mLab_UnitShortname.text = tempName;
    //时间
    CGSize sizeTime = [model.RecDate sizeWithFont:[UIFont systemFontOfSize:12]];
    cell.mLab_time.frame = CGRectMake([dm getInstance].width-10-sizeTime.width, 10, sizeTime.width, 15);
    cell.mLab_time.text = model.RecDate;
    
    if (model.RefID.count>0) {
        cell.mView_RefID.hidden = NO;
        int m=0;
        for (int i=0; i<model.RefID.count; i++) {
            NSString *tempTab = [model.RefID objectAtIndex:i];
            for (int a=0; a<self.mModel_commentList.refcomments.count; a++) {
                refcommentsModel *refModel = [self.mModel_commentList.refcomments objectAtIndex:a];
                if ([tempTab intValue] == [refModel.TabID intValue]) {
                    UIView *tempView = [[UIView alloc] init];
                    UILabel *tempLab = [[UILabel alloc] init];
                    UIButton *tempBtnLike = [UIButton buttonWithType:UIButtonTypeCustom];
                    UIButton *tempBtnCai = [UIButton buttonWithType:UIButtonTypeCustom];
                    //显示内容
                    NSString *tempTitle = [NSString stringWithFormat:@"%@@%@:%@",refModel.UserName,refModel.UnitShortname,refModel.Commnets];
                    CGSize sizeTitle = [tempTitle sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake([dm getInstance].width-90, 99999)];
                    tempLab.frame = CGRectMake(10, 5, sizeTitle.width, sizeTitle.height);
                    tempLab.text = tempTitle;
                    tempLab.font = [UIFont systemFontOfSize:12];
                    tempLab.numberOfLines = 99999;
                    [tempView addSubview:tempLab];
                    //踩
                    NSString *tempCaiCount = [NSString stringWithFormat:@"踩(%@)",refModel.CaiCount];
                    CGSize sizeCai = [tempCaiCount sizeWithFont:[UIFont systemFontOfSize:12]];
                    tempBtnCai.frame = CGRectMake([dm getInstance].width-100-sizeCai.width, tempLab.frame.origin.y+tempLab.frame.size.height+10, sizeCai.width+15, 20);
                    [tempBtnCai setTitle:tempCaiCount forState:UIControlStateNormal];
                    tempBtnCai.titleLabel.font = [UIFont systemFontOfSize:12];
                    [tempBtnCai setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    tempBtnCai.restorationIdentifier = refModel.TabIDStr;
                    //边框
                    [tempBtnCai.layer setMasksToBounds:YES];
                    [tempBtnCai.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
                    [tempBtnCai.layer setBorderWidth:1.0]; //边框宽度
                    CGColorRef colorref = [UIColor blueColor].CGColor;
                    [tempBtnCai.layer setBorderColor:colorref];//边框颜色
                    [tempBtnCai addTarget:self action:@selector(tempViewBtnCai:) forControlEvents:UIControlEventTouchUpInside];
                    [tempView addSubview:tempBtnCai];
                    //顶
                    NSString *tempLikeCount = [NSString stringWithFormat:@"顶(%@)",refModel.LikeCount];
                    CGSize sizeLike = [tempLikeCount sizeWithFont:[UIFont systemFontOfSize:12]];
                    tempBtnLike.frame = CGRectMake(tempBtnCai.frame.origin.x-25-sizeLike.width, tempBtnCai.frame.origin.y, sizeLike.width+15, 20);
                    [tempBtnLike setTitle:tempLikeCount forState:UIControlStateNormal];
                    tempBtnLike.titleLabel.font = [UIFont systemFontOfSize:12];
                    [tempBtnLike setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    tempBtnLike.restorationIdentifier = refModel.TabIDStr;
                    //边框
                    [tempBtnLike.layer setMasksToBounds:YES];
                    [tempBtnLike.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
                    [tempBtnLike.layer setBorderWidth:1.0]; //边框宽度
                    [tempBtnLike.layer setBorderColor:colorref];//边框颜色
                    [tempBtnLike addTarget:self action:@selector(tempViewBtnLike:) forControlEvents:UIControlEventTouchUpInside];
                    [tempView addSubview:tempBtnLike];
                    //设置坐标
                    tempView.frame = CGRectMake(0, m, [dm getInstance].width-80, tempBtnLike.frame.origin.y+tempBtnLike.frame.size.height);
                    tempView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
                    m = m+tempView.frame.size.height;
                    [cell.mView_RefID addSubview:tempView];
                    cell.mView_RefID.frame = CGRectMake(70, 35, [dm getInstance].width-90, tempView.frame.origin.y+tempView.frame.size.height);
                }
            }
        }
    }else{
        cell.mView_RefID.hidden = YES;
        cell.mView_RefID.frame = cell.mLab_time.frame;
    }
    
    //内容
    CGSize sizeContent = [model.Commnets sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake([dm getInstance].width-90, 99999)];
    cell.mLab_Commnets.frame = CGRectMake(70, cell.mView_RefID.frame.origin.y+cell.mView_RefID.frame.size.height+10, sizeContent.width, sizeContent.height);
    cell.mLab_Commnets.text = model.Commnets;
    cell.mLab_Commnets.numberOfLines = 99999;
    //回复按钮
    CGSize sizeReply = [@"回复" sizeWithFont:[UIFont systemFontOfSize:12]];
    cell.mBtn_reply.frame = CGRectMake([dm getInstance].width-30-sizeReply.width, cell.mLab_Commnets.frame.origin.y+cell.mLab_Commnets.frame.size.height+10, sizeReply.width+20, 30);
    //踩按钮
    NSString *tempCai = [NSString stringWithFormat:@"踩(%@)",model.CaiCount];
    CGSize sizeCai = [tempCai sizeWithFont:[UIFont systemFontOfSize:12]];
    cell.mBtn_CaiCount.frame = CGRectMake(cell.mBtn_reply.frame.origin.x-30-sizeCai.width, cell.mBtn_reply.frame.origin.y, sizeCai.width+20, 30);
    [cell.mBtn_CaiCount setTitle:tempCai forState:UIControlStateNormal];
    //顶按钮
    NSString *tempLike = [NSString stringWithFormat:@"顶(%@)",model.LikeCount];
    CGSize sizeLike = [tempLike sizeWithFont:[UIFont systemFontOfSize:12]];
    cell.mBtn_LikeCount.frame = CGRectMake(cell.mBtn_CaiCount.frame.origin.x-30-sizeLike.width, cell.mBtn_CaiCount.frame.origin.y, sizeLike.width+20, 30);
    [cell.mBtn_LikeCount setTitle:tempLike forState:UIControlStateNormal];
    
    
    //给头像添加点击事件
    cell.delegate = self;
    [cell headImgClick];
    
    int a=0;
    float b = cell.mBtn_LikeCount.frame.origin.y+cell.mBtn_LikeCount.frame.size.height+10;
    float c = cell.mImg_head.frame.origin.y+cell.mImg_head.frame.size.height+10;
    if (b>c) {
        a=b;
    }else{
        a=c;
    }
    cell.frame = CGRectMake(0, 0, [dm getInstance].width, a);
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    UITableViewCell *cell= [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        return cell.frame.size.height;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//引用中的踩
-(void)tempViewBtnCai:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    NSString *temp = btn.restorationIdentifier;
    [[ShareHttp getInstance] shareHttpAirthAddScore:temp tp:@"0"];
    [self progressViewShow:@"提交中"];
}
//引用中的顶
-(void)tempViewBtnLike:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSString *temp = btn.restorationIdentifier;
    [[ShareHttp getInstance] shareHttpAirthAddScore:temp tp:@"1"];
    [self progressViewShow:@"提交中"];
}

//向cell中添加头像点击手势
- (void) AirthCommentsListCellHeadTapHeadPress:(AirthCommentsListCell *) airthCommentsListCell{
    [MobClick event:@"ArthDetail_cell_headImg" label:@""];
    commentsListModel *model = [self.mModel_commentList.commentsList objectAtIndex:airthCommentsListCell.tag];
    //先生成个人信息
    UserInfoByUnitIDModel *userModel = [[UserInfoByUnitIDModel alloc] init];
    userModel.UserName = model.UserName;
    userModel.AccID = model.JiaoBaoHao;
    PersonalSpaceViewController *personView = [[PersonalSpaceViewController alloc] init];
    personView.mModel_personal = userModel;
    [utils pushViewController:personView animated:YES];
}

//向cell中添加按钮事件
//回复
- (void) mBtn_reply:(AirthCommentsListCell *) airthCommentsListCell{
    [MobClick event:@"ArthDetail_Cell_reply" label:@""];
    commentsListModel *model = [self.mModel_commentList.commentsList objectAtIndex:airthCommentsListCell.tag];
    NSString *str = [NSString stringWithFormat:@"回复%@:",model.Number];
    self.mTextF_text.text = str;
    [self.mTextF_text becomeFirstResponder];
}
//顶
- (void) mBtn_LikeCount:(AirthCommentsListCell *) airthCommentsListCell{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    [MobClick event:@"ArthDetail_Cell_Like" label:@""];
    commentsListModel *model = [self.mModel_commentList.commentsList objectAtIndex:airthCommentsListCell.tag];
    [[ShareHttp getInstance] shareHttpAirthAddScore:model.TabIDStr tp:@"1"];
    [self progressViewShow:@"提交中"];
}
//踩
- (void) mBtn_CaiCount:(AirthCommentsListCell *) airthCommentsListCell{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
     [MobClick event:@"ArthDetail_Cell_Cai" label:@""];
    commentsListModel *model = [self.mModel_commentList.commentsList objectAtIndex:airthCommentsListCell.tag];
    [[ShareHttp getInstance] shareHttpAirthAddScore:model.TabIDStr tp:@"0"];
    [self progressViewShow:@"提交中"];
}

-(void)progressViewShow:(NSString *)str{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD showMessage:str toView:self.view];
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
                         self.mScrollV_view.frame = CGRectMake(0, 44+[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height-51-keyboardSize.height);
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
                         self.mScrollV_view.frame = CGRectMake(0, 44+[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height-51);
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
            [self clickSendBtn];
        }
        return NO;
    }
    return YES;
}

//导航条返回按钮回调
-(void)myNavigationGoback{
    [utils popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
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

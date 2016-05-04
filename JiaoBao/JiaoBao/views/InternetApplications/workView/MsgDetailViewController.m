//
//  MsgDetailViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-10-28.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "MsgDetailViewController.h"
#import "Reachability.h"
#import "MobClick.h"
#import "UIImageView+WebCache.h"

@interface MsgDetailViewController ()

@end

@implementation MsgDetailViewController
@synthesize mNav_navgationBar,mScrollV_view,mImgV_head,mLab_name,mTextV_content,mLab_time,mBtn_detail,mTableV_detail,mTextF_text,mBtn_send,mModel_tree2,mModel_unReadMsg,mArr_feeback,mInt_detail,mBtn_more,mView_text,mBtn_trun,mInt_page,mInt_file,mInt_more,mArr_photos,mProgressV;

//发送请求
-(void)sendQuest{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    self.mInt_page = 1;
    [[LoginSendHttp getInstance] msgDetailwithUID:self.mModel_tree2.mStr_TabIDStr page:self.mInt_page feeBack:self.mModel_tree2.mStr_MsgTabIDStr ReadFlag:@""];
    
    [MBProgressHUD showMessage:@"" toView:self.view];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [MobClick endLogPageView:UMMESSAGE];
    [MobClick endLogPageView:UMPAGE];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    [MobClick beginLogPageView:UMMESSAGE];
    [MobClick beginLogPageView:UMPAGE];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"信息详情"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    self.mInt_detail = 0;
    
    //scrollview添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTap:)];
    tap.delegate = self;//设置代理，防止手势和按钮的点击事件冲突
    [self.mScrollV_view addGestureRecognizer:tap];
    
    //详情列表
    self.mTableV_detail.frame = CGRectMake(self.mLab_time.frame.origin.x, self.mLab_time.frame.origin.y+20, self.mTextV_content.frame.size.width, 0);

    self.mProgressV = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.mProgressV];
    self.mProgressV.delegate = self;
    
    self.mTextF_text.delegate = self;
    [self.mTextF_text addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //发送请求
    [self sendQuest];
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

//通知信息详情界面回复是否成功
-(void)addFeeBack:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSDictionary *dic = noti.object;
    NSString *str = [dic objectForKey:@"msg"];
    NSString *flag = [dic objectForKey:@"flag"];
    [MBProgressHUD showSuccess:str toView:self.view];
    if ([flag isEqual:@"1"]) {//成功
        MsgDetail_FeebackList *model = [[MsgDetail_FeebackList alloc] init];
        model.FeeBackMsg = self.mTextF_text.text;
        model.UserName = [dm getInstance].TrueName;
        [self.mArr_feeback insertObject:model atIndex:0];
        self.mTextF_text.text = @"";
        [self.mTextF_text resignFirstResponder];
        [self setFrame];
    } else {//失败
        [MBProgressHUD showError:str toView:self.view];
    }
}

//通知信息详情界面，更新下载文件的进度条
-(void)loadingProgress:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSString *str = noti.object;
    float temp = [str intValue];
    self.mProgressV.progress = temp;
    if (temp>=100) {
        [self.mProgressV hide:YES];
    }
}

//通知界面刷新信息详情
-(void)MsgDetail:(NSNotification *)noti{
    //若是回复我的详情，则重新获取待处理消息数量
    [[LoginSendHttp getInstance] getUnreadMessages1];
    [[LoginSendHttp getInstance] getUnreadMessages2];
    [MBProgressHUD hideHUDForView:self.view];
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
            self.mInt_more = 0;
        }else{
            self.mInt_more = 1;
        }
        
        self.mModel_unReadMsg = [dic valueForKey:@"model"];
        if(tempArr.count)
            //定位
            [self setFrame];
    }else{
        [MBProgressHUD showError:@"" toView:self.view];
    }
}
-(void)setFrame{
    self.mScrollV_view.frame = CGRectMake(0, 44, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height-51+[dm getInstance].statusBar);
    D("self.mScrollV_view.frame-==  %@",NSStringFromCGRect(self.mScrollV_view.frame));

    [self.mImgV_head sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,self.mModel_unReadMsg.JiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];
    self.mImgV_head.frame = CGRectMake(9, 9, 38, 38);
    
    //姓名
    self.mLab_name.text = self.mModel_unReadMsg.UserName;
    self.mLab_name.frame = CGRectMake(58, 9, 220, 20);
    
    //转发按钮,先判断是否管理员
    if ([[dm getInstance].userInfo.isAdmin intValue] >0) {
        if (self.mModel_unReadMsg.arrayTrunToList.count>0) {
            MsgDetail_TrunToList *model = [self.mModel_unReadMsg.arrayTrunToList objectAtIndex:0];
            NSString *str;
            for (int i=0; i<[dm getInstance].identity.count; i++) {
                Identity_model *idenModel = [[dm getInstance].identity objectAtIndex:i];
                if (i==0||i==1) {
                    NSMutableArray *array ;
                    array = [NSMutableArray arrayWithArray:idenModel.UserUnits];
                    if (array.count>0) {
                        Identity_UserUnits_model *userUnitsModel = [array objectAtIndex:0];
                        if ([userUnitsModel.UnitID isEqual:model.UnitID]) {
                            str = userUnitsModel.UnitName;
                            break;
                        }
                    }
                }else if(i==2||i==3){
                    NSMutableArray *array;
                    array = [NSMutableArray arrayWithArray:idenModel.UserClasses];
                    if (array.count>0) {
                        Identity_UserClasses_model *userUnitsModel = [array objectAtIndex:0];
                        if ([userUnitsModel.ClassID isEqual:model.UnitID]) {
                            str = userUnitsModel.ClassName;
                            break;
                        }
                    }
                }
            }
            //拼接
            if ([model.Who isEqual:@"tomem"]) {
                str = [NSString stringWithFormat:@"转发给%@人员",str];
            }else if ([model.Who isEqual:@"togen"]) {
                str = [NSString stringWithFormat:@"转发给%@家长",str];
            }else if ([model.Who isEqual:@"sostu"]) {
                str = [NSString stringWithFormat:@"转发给%@学生",str];
            }
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14]];
            self.mBtn_trun.frame = CGRectMake([dm getInstance].width-23-size.width, self.mLab_name.frame.origin.y, size.width, size.height);
            [self.mBtn_trun setTitle:str forState:UIControlStateNormal];
            [self.mBtn_trun addTarget:self action:@selector(clickTrunBtn:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            self.mBtn_trun.hidden = YES;
        }
    }else{
        self.mBtn_trun.hidden = YES;
    }
    
    
    //内容详情
    int width = [dm getInstance].width-58-23;
    NSString *desContent = self.mModel_unReadMsg.MsgContent;//获取文本内容
    CGSize size = [desContent sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(width, 2000) lineBreakMode:NSLineBreakByWordWrapping];
    self.mTextV_content.frame=CGRectMake(58, self.mLab_name.frame.origin.y+self.mLab_name.frame.size.height, width, size.height+40);//重设UITextView的frame
    D("self.mtextv.frame-==== %@,%@,%@",NSStringFromCGRect(self.mImgV_head.frame),NSStringFromCGRect(self.mLab_name.frame),NSStringFromCGRect(self.mTextV_content.frame));
    self.mTextV_content.text=desContent;
    
    //是否有附件
    CGRect rect = self.mTextV_content.frame;
    for (int i=0; i<self.mModel_unReadMsg.arrayAttList.count; i++) {
        MsgDetail_AttList *model = [self.mModel_unReadMsg.arrayAttList objectAtIndex:i];
        NSString *attStr = [NSString stringWithFormat:@"附件:%@(%@)",model.OrgFilename,model.FileSize];
        CGSize size = [attStr sizeWithFont:[UIFont systemFontOfSize:11]];
        if (size.width>self.mTextV_content.frame.size.width) {
            size.width = self.mTextV_content.frame.size.width;
        }
        rect = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height+2, size.width, size.height);
        UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tempBtn.frame = rect;
        tempBtn.titleLabel.font = [UIFont systemFontOfSize: 11];
        [tempBtn setTitle:attStr forState:UIControlStateNormal];
        [tempBtn setTitleColor:[UIColor colorWithRed:17/255.0 green:107/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
        tempBtn.tag = i+1;
        [tempBtn addTarget:self action:@selector(clickAttListBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.mScrollV_view addSubview:tempBtn];
        
        D("detail.attListModel -== %@,%@,%@",model.dlurl,model.OrgFilename,model.FileSize);
    }
    
    //时间
    self.mLab_time.frame =  CGRectMake(rect.origin.x, rect.origin.y+rect.size.height, 170, 20);
    self.mLab_time.text = self.mModel_unReadMsg.RecDate;
    D("self.mLab_time.frame-=  %@",NSStringFromCGRect(self.mLab_time.frame));
    
    //接收人员详情按钮
    self.mBtn_detail.frame = CGRectMake([dm getInstance].width-23-80, self.mLab_time.frame.origin.y, 80, 20);
    [self.mBtn_detail setTitle:@"接收人员详情" forState:UIControlStateNormal];
    [self.mBtn_detail addTarget:self action:@selector(clickDetailBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //详情列表
    self.mTableV_detail.frame = CGRectMake(self.mLab_time.frame.origin.x, self.mLab_time.frame.origin.y+20, self.mTextV_content.frame.size.width, [self tableViewCount]);
    [self.mTableV_detail reloadData];
    
    //查看更多按钮
    self.mBtn_more.frame = CGRectMake(self.mTableV_detail.frame.origin.x, self.mTableV_detail.frame.origin.y+self.mTableV_detail.frame.size.height, self.mTableV_detail.frame.size.width, 40);
    [self.mBtn_more addTarget:self action:@selector(clickMore:) forControlEvents:UIControlEventTouchUpInside];
    if (self.mInt_more == 0) {
        self.mBtn_more.hidden = NO;
        //计算scrollview的内容大小
        self.mScrollV_view.contentSize = CGSizeMake([dm getInstance].width, self.mBtn_more.frame.origin.y+self.mBtn_more.frame.size.height+10);
    }else{
        self.mBtn_more.hidden = YES;
        //计算scrollview的内容大小
        self.mScrollV_view.contentSize = CGSizeMake([dm getInstance].width, self.mTableV_detail.frame.origin.y+self.mTableV_detail.frame.size.height+10);
    }
    
    //输入View坐标
    self.mView_text.frame = CGRectMake(0, [dm getInstance].height-51, [dm getInstance].width, 51);
    //输入框
    self.mTextF_text.frame = CGRectMake(15, 10, [dm getInstance].width-15-70, 51-20);
    //发送按钮
    self.mBtn_send.frame = CGRectMake([dm getInstance].width-65, 0, 60, 51);
    [self.mBtn_send addTarget:self action:@selector(clickSendBtn:) forControlEvents:UIControlEventTouchUpInside];
}
//导航条返回按钮回调
-(void)myNavigationGoback{
    [utils popViewControllerAnimated:YES];
}

//点击接收人员详情按钮
-(void)clickDetailBtn:(UIButton *)btn{
    D("点击接收人员详情按钮");
    if (self.mInt_detail == 0) {
        self.mInt_detail = 1;
        [self.mBtn_detail setTitle:@"回复详情" forState:UIControlStateNormal];
        //详情列表
        self.mTableV_detail.frame = CGRectMake(self.mLab_time.frame.origin.x, self.mLab_time.frame.origin.y+20, self.mTextV_content.frame.size.width, [self tableViewCount]);
        //查看更多按钮
        self.mBtn_more.hidden = YES;
        //计算scrollview的内容大小
        self.mScrollV_view.contentSize = CGSizeMake([dm getInstance].width, self.mTableV_detail.frame.origin.y+self.mTableV_detail.frame.size.height+10);
    } else {
        self.mInt_detail = 0;
        [self.mBtn_detail setTitle:@"接收人员详情" forState:UIControlStateNormal];
        //详情列表
        self.mTableV_detail.frame = CGRectMake(self.mLab_time.frame.origin.x, self.mLab_time.frame.origin.y+20, self.mTextV_content.frame.size.width, [self tableViewCount]);
        //查看更多按钮
        self.mBtn_more.frame = CGRectMake(self.mTableV_detail.frame.origin.x, self.mTableV_detail.frame.origin.y+self.mTableV_detail.frame.size.height, self.mTableV_detail.frame.size.width, 40);
        if (self.mInt_more == 0) {
            self.mBtn_more.hidden = NO;
            //计算scrollview的内容大小
            self.mScrollV_view.contentSize = CGSizeMake([dm getInstance].width, self.mBtn_more.frame.origin.y+self.mBtn_more.frame.size.height+10);
        }else{
            self.mBtn_more.hidden = YES;
            //计算scrollview的内容大小
            self.mScrollV_view.contentSize = CGSizeMake([dm getInstance].width, self.mTableV_detail.frame.origin.y+self.mTableV_detail.frame.size.height+10);
        }
    }
    
    [self.mTableV_detail reloadData];
}

//点击查看更多按钮
-(void)clickMore:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    D("点击查看更多按钮");
    if (self.mArr_feeback.count>=20) {
        self.mInt_page = (int)self.mArr_feeback.count/20+1;
        D("self.mint.page-====%lu %d",(unsigned long)self.mArr_feeback.count,self.mInt_page);
        [[LoginSendHttp getInstance] msgDetailwithUID:self.mModel_tree2.mStr_TabIDStr page:self.mInt_page feeBack:@"" ReadFlag:@""];
        
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
    if ([utils isBlankString:self.mTextF_text.text]) {
        [MBProgressHUD showError:@"请输入内容" toView:self.view];
        return;
    }
    
    [[LoginSendHttp getInstance] addFeeBackWithUID:self.mModel_unReadMsg.TabIDStr content:self.mTextF_text.text];
    [MBProgressHUD showMessage:@"发送中..." toView:self.view];
}

//点击转发按钮
-(void)clickTrunBtn:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    D("点击转发按钮");
    ForwardViewController *forward = [[ForwardViewController alloc] init];
    //forward.mStr_navName = @"转发";
    forward.mInt_forwardFlag = 1;
    forward.mInt_forwardAll = 1;
    forward.mInt_flag = 1;
    forward.mInt_all = 1;
//    forward.mInt_where = 1;
//    forward.mStr_forwardContent = self.mModel_unReadMsg.MsgContent;
//    forward.mStr_forwardTableID = self.mModel_unReadMsg.TabIDStr;
    [utils pushViewController:forward animated:YES];
}

//点击附件按钮下载文件按钮
-(void)clickAttListBtn:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    D("点击附件按钮下载文件按钮.tag-=  %ld",(long)btn.tag);
    MsgDetail_AttList *model = [self.mModel_unReadMsg.arrayAttList objectAtIndex:btn.tag-1];
    self.mInt_file = (int)btn.tag;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //文件名
    NSString *fileName = [NSString stringWithFormat:@"%@%@",model.dlurl,model.OrgFilename];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
    //判断文件夹是否存在
    if(![fileManager fileExistsAtPath:tempPath]) {//如果不存在
        [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *imgPath=[tempPath stringByAppendingPathComponent:fileName];
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
                [self.mArr_photos addObject:[MWPhoto photoWithFilePath:getImageStrPath]];
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
            MsgDetail_AttList *model = [self.mModel_unReadMsg.arrayAttList objectAtIndex:self.mInt_file-1];
            [[LoginSendHttp getInstance] msgDetailDownLoadFileWithURL:model.dlurl fileName:model.OrgFilename vc:self];
            [self.mProgressV show:YES];
            self.mProgressV.mode = MBProgressHUDModeDeterminateHorizontalBar;
            self.mProgressV.progress = 0;
            //[MBProgressHUD showMessage:@"下载中..." toView:self.view];
        }
    }
}
-(void)setProgress:(float)newProgress{
    [self.mProgressV setProgress:newProgress];
    self.mProgressV.labelText = [NSString stringWithFormat:@"已经下载：%0.f%%",newProgress*100];

    if (newProgress>=1) {
        [self.mProgressV hide:YES];
    }

}
- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength
{
    
}


//单击手势
-(void)pressTap:(UITapGestureRecognizer *)tap{
    [self.mTextF_text resignFirstResponder];
}

//循环计算tableV的全部高度
-(int)tableViewCount{
    int a = 0;
    if (self.mInt_detail == 0) {
        for (int i=0; i<self.mArr_feeback.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection: 0];
            UITableViewCell *cell= [self tableView:self.mTableV_detail cellForRowAtIndexPath:indexPath];
            a = a + cell.frame.size.height;
            D("tableviewcount-===%d",a);
//            19,38,72,121,140,159 , 216,1,207,423.000000,257.000000,36.000000  198,2,27,423.000000,239.000000,36.000000
        }
    } else {
        for (int i=0; i<self.mModel_unReadMsg.arrayReaderList.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection: 0];
            UITableViewCell *cell= [self tableView:self.mTableV_detail cellForRowAtIndexPath:indexPath];
            a = a + cell.frame.size.height;
        }
    }
    
    D("a=== %d",a);
    return a;
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.mInt_detail == 0) {
        D("table.count-=========%lu",(unsigned long)self.mArr_feeback.count);
        return self.mArr_feeback.count;
    }else if (self.mInt_detail == 1){
        return self.mModel_unReadMsg.arrayReaderList.count;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"MsgDetail_Cell";
    MsgDetail_Cell *cell = (MsgDetail_Cell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[MsgDetail_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MsgDetail_Cell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell = (MsgDetail_Cell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        //添加图片点击事件
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"MsgDetail_Cell" bundle:[NSBundle mainBundle]];
        [self.mTableV_detail registerNib:n forCellReuseIdentifier:indentifier];
    }
    if (self.mInt_detail == 0) {
        MsgDetail_FeebackList *model = [self.mArr_feeback objectAtIndex:indexPath.row];
        //名字
        cell.mLab_name.text = model.UserName;
        CGSize nameSize = [model.UserName sizeWithFont:[UIFont systemFontOfSize:12]];
        cell.mLab_name.frame = CGRectMake(5, 2, nameSize.width, nameSize.height);
        //内容
        cell.mLab_content.text = model.FeeBackMsg;
        D("content-===%@",model.FeeBackMsg);
        CGSize contentSize = [model.FeeBackMsg sizeWithFont:[UIFont systemFontOfSize:12]];
        int a = self.mTableV_detail.frame.size.width-5-cell.mLab_name.frame.size.width;
        if (contentSize.width>a) {
            int b = contentSize.width/a;
            int c = (int)(contentSize.width) % a;
            int d;
            if (c>0) {
                d = b + 1;
            }else{
                d = b;
            }
//            textSize = [detailModel.msg sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(280, 99999)];
            cell.mLab_content.numberOfLines = d;
            cell.mLab_content.frame = CGRectMake(cell.mLab_name.frame.origin.x+nameSize.width, 2, a, contentSize.height*d);
            
        }else{
            cell.mLab_content.frame = CGRectMake(cell.mLab_name.frame.origin.x+nameSize.width, 2, contentSize.width, contentSize.height);
        }
        
        //计算cell高度
        cell.frame = CGRectMake(0, 0, self.mTableV_detail.frame.size.width, cell.mLab_content.frame.size.height+4);
    } else {
        MsgDetail_ReaderList *model = [self.mModel_unReadMsg.arrayReaderList objectAtIndex:indexPath.row];
        cell.mLab_name.hidden = YES;
        if ([model.MCState isEqual:@"0"]) {
            cell.mLab_content.text = [NSString stringWithFormat:@"%@(未查看)",model.TrueName];
        } else {
            cell.mLab_content.text = [NSString stringWithFormat:@"%@(已查看)",model.TrueName];
        }
        CGSize contentSize = [cell.mLab_content.text sizeWithFont:[UIFont systemFontOfSize:12]];
        cell.mLab_content.frame = CGRectMake(5, 2, contentSize.width, contentSize.height);
        //计算cell高度
        cell.frame = CGRectMake(0, 0, self.mTableV_detail.frame.size.width, cell.mLab_content.frame.size.height+4);
    }
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    UITableViewCell *cell= [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        return cell.frame.size.height;
    }
    return 0;
}

//如果输入超过规定的字数100，就不再让输入
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // Any new character added is passed in as the "text" parameter
    //输入删除时
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([string isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textField resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    if(textField.text.length>999)
    {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 999) {
            return NO;
        }
    }
    return TRUE;
}
//如果输入超过规定的字数100，就不再让输入
- (void)textFieldDidChange:(UITextField *)textField{
    if (textField == self.mTextF_text) {
        if(textField.text.length>999)
        {
            textField.text = [textField.text substringToIndex:1000];
        }
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
                         self.mScrollV_view.frame = CGRectMake(0, 44, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height-51-keyboardSize.height+[dm getInstance].statusBar);
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
                         self.mScrollV_view.frame = CGRectMake(0, 44, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height-51+[dm getInstance].statusBar);
                         self.mView_text.frame = CGRectMake(0, [dm getInstance].height-51, [dm getInstance].width, 51);
                     }
                     completion:^(BOOL finished){
                         ;
                     }];
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

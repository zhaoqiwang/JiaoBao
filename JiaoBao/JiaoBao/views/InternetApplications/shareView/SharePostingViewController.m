//
//  SharePostingViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-11-24.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "SharePostingViewController.h"
#import "Reachability.h"
#import "TableViewWithBlock.h"
#import "SelectionCell.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "MobClick.h"

@interface SharePostingViewController ()
@property (nonatomic,strong)TableViewWithBlock *mTableV_type;//下拉选择框
@property(nonatomic,assign)BOOL isOpen;//是否下拉的标志

@end

@implementation SharePostingViewController
@synthesize mNav_navgationBar,mTextV_content,mBtn_send,mBtn_selectPic,mTextF_title,mInt_index,mArr_pic,mModel_unit,mInt_section,mBtn_send2,mTableV_type,mStr_unitID,mStr_uType,mLab_dongtai,mLab_fabu,mArr_dynamic,mLab_hidden,pullArr,pullDownBtn;

-(id)init{
    self.mArr_dynamic = [NSMutableArray array];
    return self;
}
-(void)dealloc
{
    
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //音频
    [self audio];
    //上传图片
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UploadImg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UploadImg:) name:@"UploadImg" object:nil];
    //通知界面发表文章成功
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SavePublishArticle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SavePublishArticle:) name:@"SavePublishArticle" object:nil];
    //获取到的关联班级
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetmyUserClass" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetmyUserClass:) name:@"GetmyUserClass" object:nil];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:245/255.0 alpha:1];
    self.isOpen = NO;
    self.view.tag = 5;
    self.mLab_hidden.frame = self.view.frame;
    
    self.pullArr = [NSMutableArray array];
    if (self.mInt_section == 0) {//分享
        self.mStr_unitID = @"";
        //如果是老师身份，请求关联班级
        if ([dm getInstance].uType == 2) {
            [[LoginSendHttp getInstance] login_GetmyUserClass:[NSString stringWithFormat:@"%d",[dm getInstance].UID] Accid:[dm getInstance].jiaoBaoHao];
            [MBProgressHUD showMessage:@"加载关联班级中..." toView:self.view];
        }
        
        for (int i=0; i<[dm getInstance].identity.count; i++) {
            Identity_model *idenModel = [[dm getInstance].identity objectAtIndex:i];
            if ([idenModel.RoleIdentity intValue]==1||[idenModel.RoleIdentity intValue]==2) {
                for (int a=0; a<idenModel.UserUnits.count; a++) {
                    Identity_UserUnits_model *userUnitsModel = [idenModel.UserUnits objectAtIndex:a];
                    NSString *str = [NSString stringWithFormat:@"%@-%@",idenModel.RoleIdName,userUnitsModel.UnitName];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setValue:idenModel.RoleIdentity forKey:@"type"];
                    [dic setValue:userUnitsModel.UnitID forKey:@"unitID"];
                    [dic setValue:str forKey:@"name"];
                    [self.pullArr addObject:dic];
                    if ([self.mStr_unitID intValue] == 0) {
                        self.mStr_unitID = userUnitsModel.UnitID;
                        self.mStr_uType = idenModel.RoleIdentity;
                    }
                }
            }
            if ([idenModel.RoleIdentity intValue]==3||[idenModel.RoleIdentity intValue]==4) {
                for (int a=0; a<idenModel.UserClasses.count; a++) {
                    Identity_UserClasses_model *userUnitsModel = [idenModel.UserClasses objectAtIndex:a];
                    NSString *str = [NSString stringWithFormat:@"%@-%@",idenModel.RoleIdName,userUnitsModel.ClassName];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setValue:idenModel.RoleIdentity forKey:@"type"];
                    [dic setValue:userUnitsModel.ClassID forKey:@"unitID"];
                    [dic setValue:str forKey:@"name"];
                    [self.pullArr addObject:dic];
                    if ([self.mStr_unitID intValue] == 0) {
                        self.mStr_unitID = userUnitsModel.ClassID;
                        self.mStr_uType = idenModel.RoleIdentity;
                    }
                }
            }
        }
        if (self.pullArr.count>0) {
            NSString *name = [[self.pullArr objectAtIndex:0] objectForKey:@"name"];
            [self.pullDownBtn setTitle:name forState:UIControlStateNormal];
        }
    }else{//动态
        for (int i=0; i<self.mArr_dynamic.count; i++) {
            ReleaseNewsUnitsModel *model = [self.mArr_dynamic objectAtIndex:i];
            if (i==0) {
                [self.pullDownBtn setTitle:model.UnitName forState:UIControlStateNormal];
                self.mStr_uType = model.UnitType;
                self.mStr_unitID = model.UnitId;
            }
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:model.UnitType forKey:@"type"];
            [dic setValue:model.UnitId forKey:@"unitID"];
            [dic setValue:model.UnitName forKey:@"name"];
            [self.pullArr addObject:dic];
        }
    }
    
    self.mTableV_type.tag = 2;
    if(self.isOpen == NO)
    {
        self.mTableV_type = [[TableViewWithBlock alloc]initWithFrame:CGRectZero];
    }
    else
    {
    self.mTableV_type = [[TableViewWithBlock alloc]initWithFrame:CGRectMake(self.pullDownBtn.frame.origin.x, self.pullDownBtn.frame.origin.y+self.secondVIew.frame.origin.y+self.pullDownBtn.frame.size.height, self.pullDownBtn.frame.size.width, self.pullDownBtn.frame.size.height*3)];
    }
    [self.mTableV_type initTableViewDataSourceAndDelegate:^NSInteger(UITableView *tableView, NSInteger section) {
        return self.pullArr.count;
        
    } setCellForIndexPathBlock:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
                SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
                if (!cell) {
                    cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                }
        NSString *name = [[self.pullArr objectAtIndex:indexPath.row] objectForKey:@"name"];
         [cell.lb setText:[NSString stringWithFormat:@"%@",name]];
                return cell;
    } setDidSelectRowBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
        NSString *name = [[self.pullArr objectAtIndex:indexPath.row] objectForKey:@"name"];
        [self.pullDownBtn setTitle:name forState:UIControlStateNormal];
        self.mStr_unitID = [[self.pullArr objectAtIndex:indexPath.row] objectForKey:@"unitID"];
        self.mStr_uType = [[self.pullArr objectAtIndex:indexPath.row] objectForKey:@"type"];
        self.mTableV_type.frame = CGRectZero;
        self.isOpen = NO;
//        self.mInt_section = (int)indexPath.row;
        [self.mTextF_title resignFirstResponder];
        [self.mTextV_content resignFirstResponder];
    }];
    [self.view addSubview:self.mTableV_type];
    [self.mTableV_type.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.mTableV_type.layer setBorderWidth:1];
    [self.pullDownBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.pullDownBtn.layer setBorderWidth:1];
    
    [self.cameraBtn.layer setCornerRadius:6];
    [self.albumBtn.layer setCornerRadius:6];
    [self.videoBtn.layer setCornerRadius:6];
    [self.voiceBtn.layer setCornerRadius:6];
    [self.mBtn_send.layer setCornerRadius:6];
    [self.pullDownBtn.layer setCornerRadius:3];
    
    // Do any additional setup after loading the view from its nib.
    
    self.mArr_pic = [NSMutableArray array];
    
    //添加导航条
    if (self.mInt_section == 0) {//分享
        self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"发表分享"];
    }else if (self.mInt_section == 1){//展示
        self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"发布单位动态"];
    }
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    //标题
    //self.mTextF_title.frame = CGRectMake(10, self.mNav_navgationBar.frame.size.height+10, [dm getInstance].width-20, self.mTextF_title.frame.size.height);
    self.mTextF_title.delegate = self;
    self.mTextF_title.returnKeyType = UIReturnKeyDone;//return键的类型
    //内容
    //self.mTextV_content.frame = CGRectMake(10, self.mTextF_title.frame.origin.y+self.mTextF_title.frame.size.height+15, [dm getInstance].width-20, 80);
    //添加边框
    self. mTextV_content.layer.borderWidth = .5;
    self.mTextV_content.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    //将图层的边框设置为圆脚
    self.mTextV_content.layer.cornerRadius = 8;
    self.mTextV_content.layer.masksToBounds = YES;
    self.mTextV_content.delegate = self;
    self.mTextV_content.returnKeyType = UIReturnKeyDone;//return键的类型
    //发表按钮
    //self.mBtn_send.frame = CGRectMake(10, self.mBtn_send.frame.origin.y, [dm getInstance].width-20, self.mBtn_send.frame.size.height);
    [self.mBtn_send addTarget:self action:@selector(clickPosting:) forControlEvents:UIControlEventTouchUpInside];
    self.mBtn_send2.hidden = YES;
    //选择图片按钮
    //self.mBtn_selectPic.frame = CGRectMake([dm getInstance].width-self.mBtn_selectPic.frame.size.width-10, self.mTextV_content.frame.origin.y+self.mTextV_content.frame.size.height+10, self.mBtn_selectPic.frame.size.width, self.mBtn_selectPic.frame.size.height);
    [self.mBtn_selectPic addTarget:self action:@selector(clickSelectPic:) forControlEvents:UIControlEventTouchUpInside];
    //添加边框
    self.mBtn_selectPic.layer.borderWidth = .5;
    self.mBtn_selectPic.layer.borderColor = [[UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1] CGColor];
    //将图层的边框设置为圆脚
    self.mBtn_selectPic.layer.cornerRadius = 8;
    self.mBtn_selectPic.layer.masksToBounds = YES;
    
    if (self.mInt_section == 0) {//分享
        self.mLab_fabu.text = @"发布到";
        self.mLab_dongtai.text = @"分享空间";
    }else if (self.mInt_section == 1){//展示
        self.mLab_fabu.text = @"发表";
        self.mLab_dongtai.text = @"动态";
    }
    
    //添加单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTap:)];
    tap.delegate = self;//设置代理，防止手势和按钮的点击事件冲突
    self.mLab_hidden.userInteractionEnabled = YES;
    [self.mLab_hidden addGestureRecognizer:tap];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(([dm getInstance].width-80)/2, 70, 80, 100);
    [self.view addSubview:self.imageView];
    [self.imageView setHidden:YES];
}

-(void)pressTap:(UITapGestureRecognizer *)tap{
    [self.mTextF_title resignFirstResponder];
    [self.mTextV_content resignFirstResponder];
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

//获取到的关联班级
-(void)GetmyUserClass:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag intValue] ==0) {//成功
        NSMutableArray *array = [dic objectForKey:@"array"];
        for (int i=0; i<array.count; i++) {
            GetmyUserClassModel *model = [array objectAtIndex:i];
            NSString *str = [NSString stringWithFormat:@"%@-%@",model.GradeName,model.ClassName];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@"3" forKey:@"type"];
            [dic setValue:model.ClassID forKey:@"unitID"];
            [dic setValue:str forKey:@"name"];
            D("dlkfgnd;lkgmne-===%@",str);
            [self.pullArr addObject:dic];
        }
        [self.mTableV_type reloadData];
    }else{
        [MBProgressHUD showError:@"获取失败" toView:self.view];
    }
}

//上传图片回调
-(void)UploadImg:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        self.imageCount--;
        UploadImgModel *model = [dic objectForKey:@"model"];
        [self.mArr_pic addObject:model];
        if(self.imageCount == 0)
        {
            //self.mTextV_content.text = @"";
            [MBProgressHUD showSuccess:@"上传成功" toView:self.view];
            NSArray *arr = [self.mArr_pic sortedArrayUsingComparator:^NSComparisonResult(UploadImgModel *p1, UploadImgModel *p2){
                NSString *sub_p1 = [p1.originalName stringByReplacingOccurrencesOfString:@"[图片" withString:@""];
                NSString *su_p11 = [sub_p1 stringByReplacingOccurrencesOfString:@"]" withString:@""];
                int p1_int = [su_p11 intValue];
                NSNumber *p1_num = [NSNumber numberWithInt:p1_int ];
                
                NSString *sub_p2 = [p2.originalName stringByReplacingOccurrencesOfString:@"[图片" withString:@""];
                NSString *su_p22 = [sub_p2 stringByReplacingOccurrencesOfString:@"]" withString:@""];
                int p2_int = [su_p22 intValue];
                NSNumber *p2_num = [NSNumber numberWithInt:p2_int ];
                
                return [p1_num compare:p2_num];
            }];
            self.mArr_pic =[NSMutableArray arrayWithArray:arr];
            for(int i=self.tfContentTag;i<self.mArr_pic.count;i++)
            {
                UploadImgModel *model1 = [self.mArr_pic objectAtIndex:i];
                self.mTextV_content.text = [NSString stringWithFormat:@"%@%@",self.mTextV_content.text,model1.originalName];

            }

        }
        self._placeholdLabel.hidden = YES;
    }else{
        [MBProgressHUD showError:@"失败" toView:self.view];
    }
}

-(void)SavePublishArticle:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    self.mInt_index = 0;
    [self.mArr_pic removeAllObjects];
    NSString *str = noti.object;
    [MBProgressHUD showSuccess:str toView:self.view];
    self.mTextF_title.text = @"";
    self.mTextV_content.text = @"";
    self.mInt_index = 0;
    self.mArr_pic = [[NSMutableArray alloc]initWithCapacity:0];
}

//点击发送按钮
-(void)clickPosting:(UIButton *)btn{
//    self.mInt_section = 0;
    [self clickPosting3];
}
-(void)clickPosting1:(UIButton *)btn{
    self.mInt_section = 1;
    [self clickPosting3];
}

-(void)clickPosting3{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    D("self.textv.content-===%@",self.mTextV_content.text);
    if (self.mTextF_title.text.length==0) {
        [MBProgressHUD showError:@"请输入标题" toView:self.view];
        return;
    }else if ([utils isBlankString:self.mTextV_content.text]){
        [MBProgressHUD showError:@"请输入内容" toView:self.view];
        return;
    }
    NSString *content = self.mTextV_content.text;
    for (int i=0; i<self.mArr_pic.count; i++) {
        UploadImgModel *model = [self.mArr_pic objectAtIndex:i];
        NSString *temp = model.originalName;
        content = [content stringByReplacingOccurrencesOfString:temp withString:model.url];
    }
    content = [NSString stringWithFormat:@"<p>%@</p>",content];
    D("content--------%@",content);
    
    if (self.mInt_section == 0) {//分享
        D("self.mStr_unitID = %@",self.mStr_unitID);
        [[ShareHttp getInstance] shareHttpSavePublishArticleWith:self.mTextF_title.text Content:content uType:self.mStr_uType UnitID:self.mStr_unitID SectionFlag:@"1"];
    }else if (self.mInt_section == 1){//展示
        [[ShareHttp getInstance] shareHttpSavePublishArticleWith:self.mTextF_title.text Content:content uType:self.mStr_uType UnitID:self.mStr_unitID SectionFlag:@"2"];
    }
    
    [MBProgressHUD showMessage:@"" toView:self.view];
}




#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.imageCount = 1;
    D("info_count = %ld",(unsigned long)info.count);
    [picker dismissViewControllerAnimated:YES completion:^{
        
        

    }];
    [MBProgressHUD showMessage:@"正在上传" toView:self.view];

    UIImage* image=[info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image=[info objectForKey:UIImagePickerControllerOriginalImage];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSData *imageData = UIImageJPEGRepresentation(image,0);
    NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"[图片%d].png",self.mInt_index]];
    D("图片路径是：%@",imgPath);


    BOOL yesNo=[[NSFileManager defaultManager] fileExistsAtPath:imgPath];
    if (!yesNo) {//不存在，则直接写入后通知界面刷新
        BOOL result = [imageData writeToFile:imgPath atomically:YES];
        for (;;) {
            if (result) {
                NSString *name = [NSString stringWithFormat:@"[图片%d]",self.mInt_index];
                
                [[ShareHttp getInstance] shareHttpUploadSectionImgWith:imgPath Name:name];
//                self.mTextV_content.text = [NSString stringWithFormat:@"%@%@",self.mTextV_content.text,name];
                break;
            }
        }
    }else {
        //存在
        BOOL blDele= [fileManager removeItemAtPath:imgPath error:nil];//先删除
        if (blDele) {//删除成功后，写入，通知界面
            BOOL result = [imageData writeToFile:imgPath atomically:YES];
            for (;;) {
                if (result) {
                    NSString *name = [NSString stringWithFormat:@"[图片%d]",self.mInt_index];
                    
                    [[ShareHttp getInstance] shareHttpUploadSectionImgWith:imgPath Name:name];
//                    self.mTextV_content.text = [NSString stringWithFormat:@"%@%@",self.mTextV_content.text,name];
                    break;
                }
            }
        }
    }

    self.mInt_index ++;
    //[self.mProgressV hide:YES];
}


-(void)imagePickerMutilSelectorDidGetImages:(NSArray *)imageArray
{
//    importItems=[[NSMutableArrayalloc] initWithArray:imageArray copyItems:YES];
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    
//    return YES;
//}

//导航条返回按钮回调
-(void)myNavigationGoback{
//    [self.timer invalidate];
//    self.timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];

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

- (IBAction)pullAction:(id)sender {
    if(self.isOpen == YES)
    {
        self.mTableV_type.frame = CGRectZero;
    }
    else
    {
        self.mTableV_type.frame = CGRectMake(self.pullDownBtn.frame.origin.x, self.pullDownBtn.frame.origin.y+self.pullDownBtn.frame.size.height+320, self.pullDownBtn.frame.size.width, self.pullDownBtn.frame.size.height*3);
    }
    self.isOpen = !self.isOpen;
    [self.mTextF_title resignFirstResponder];
    [self.mTextV_content resignFirstResponder];
}
#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    self.imageCount = info.count;
    [MBProgressHUD showMessage:@"正在上传图片" toView:self.view];

    [self dismissViewControllerAnimated:YES completion:^{
        //发送选中图片上传请求
        if (info.count>0) {
            D("info.count-===%lu",(unsigned long)info.count);
        }
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
        //判断文件夹是否存在
        if(![fileManager fileExistsAtPath:tempPath]) {//如果不存在
            [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        for (NSDictionary *dict in info) {
            if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
                if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                    UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                    
                    
                    
                    NSData *imageData = UIImageJPEGRepresentation(image,0);
                    
                    // NSLog(@"%lu",(unsigned long)imageData.length);
                    
                    NSString *imgPath=[tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"[图片%d].png",self.mInt_index]];
                    
                    //NSString *imgPath=[tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",timeSp]];
                    //[self.mArr_pic addObject:[NSString stringWithFormat:@"%@.png",timeSp]];
                    D("图片路径是：%@",imgPath);
                    
                    BOOL yesNo=[[NSFileManager defaultManager] fileExistsAtPath:imgPath];
                    if (!yesNo) {//不存在，则直接写入后通知界面刷新
                        BOOL result = [imageData writeToFile:imgPath atomically:YES];
                        for (;;) {
                            if (result) {
                                NSString *name = [NSString stringWithFormat:@"[图片%d]",self.mInt_index];
                                
                                [[ShareHttp getInstance] shareHttpUploadSectionImgWith:imgPath Name:name];
//                                self.mTextV_content.text = [NSString stringWithFormat:@"%@%@",self.mTextV_content.text,name];
                                self.mInt_index ++;
                                break;
                            }
                        }
                    }else {
                        //存在
                        BOOL blDele= [fileManager removeItemAtPath:imgPath error:nil];//先删除
                        if (blDele) {//删除成功后，写入，通知界面
                            BOOL result = [imageData writeToFile:imgPath atomically:YES];
                            for (;;) {
                                if (result) {
                                    NSString *name = [NSString stringWithFormat:@"[图片%d]",self.mInt_index];
                                    
                                    [[ShareHttp getInstance] shareHttpUploadSectionImgWith:imgPath Name:name];
//                                    self.mTextV_content.text = [NSString stringWithFormat:@"%@%@",self.mTextV_content.text,name];
                                    self.mInt_index ++;
                                    
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


}];
       // [self.mProgressV hide:YES];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)cameraBtnAction:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = NO;
        imagePickerController.sourceType = sourceType;
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        }
        self.tfContentTag = self.mArr_pic.count;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
    else
    {
        
    }
    
}

- (IBAction)albumBtnAction:(id)sender {
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 1; //Set the maximum number of images to select to 10
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    self.tfContentTag= self.mArr_pic.count;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}

- (IBAction)videoBtnAction:(id)sender{
    VideoRecorderViewController *video = [[VideoRecorderViewController alloc] init];
    video.delegate = self;
    [utils pushViewController:video animated:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {  // 这个方法是UITextFieldDelegate协议里面的
    if (theTextField == self.mTextF_title) {
        [theTextField resignFirstResponder]; //这句代码可以隐藏 键盘
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (![text isEqualToString:@""]){
        self._placeholdLabel.hidden = YES;
    }
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        self._placeholdLabel.hidden = NO;
    }

    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

//视频返回
-(void)VideoRecorderSelectFile:(AccessoryModel *)model{
    [MBProgressHUD showMessage:@"正在上传" toView:self.view];
    [[ShareHttp getInstance] shareHttpUploadSectionImgWith:model.pathStr Name:@""];
}

- (void)btnVoiceDown:(id)sender
{
    [self.imageView setHidden:NO];
    //创建录音文件，准备录音
    if ([self.recorder prepareToRecord]) {
        //开始
        [self.recorder record];
    }
    
    //设置定时检测
    timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
}
- (void)btnVoiceUp:(id)sender
{
    [self.imageView setHidden:YES];
    double cTime = self.recorder.currentTime;
    if (cTime > 2) {//如果录制时间<2 不发送
        D("发出去");
    }else {
        //删除记录的文件
        [self.recorder deleteRecording];
        //删除存储的
    }
    [self.recorder stop];
    [timer invalidate];
}
- (void)btnVoiceDragUp:(id)sender
{
    [self.imageView setHidden:YES];
    //删除录制文件
    [self.recorder deleteRecording];
    [self.recorder stop];
    [timer invalidate];
    
    D("取消发送");
}
- (void)audio
{
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    mStr_path = [self audioRecordingPath];
    NSURL *url = [NSURL fileURLWithPath:mStr_path];
    //    urlPlay = url;
    
    NSError *error;
    //初始化
    self.recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    //开启音量检测
    self.recorder.meteringEnabled = YES;
    self.recorder.delegate = self;
}

- (void)detectionVoice
{
    [self.recorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    
    double lowPassResults = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
    //    NSLog(@"111111----===%lf",lowPassResults);
    //最大50  0
    //图片 小-》大
    if (0<lowPassResults<=0.06) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_01"]];
    }else if (0.06<lowPassResults<=0.13) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_02"]];
    }else if (0.13<lowPassResults<=0.20) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_03"]];
    }else if (0.20<lowPassResults<=0.27) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_04"]];
    }else if (0.27<lowPassResults<=0.34) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_05"]];
    }else if (0.34<lowPassResults<=0.41) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_06"]];
    }else if (0.41<lowPassResults<=0.48) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_07"]];
    }else if (0.48<lowPassResults<=0.55) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_08"]];
    }else if (0.55<lowPassResults<=0.62) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_09"]];
    }else if (0.62<lowPassResults<=0.69) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_10"]];
    }else if (0.69<lowPassResults<=0.76) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_11"]];
    }else if (0.76<lowPassResults<=0.83) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_12"]];
    }else if (0.83<lowPassResults<=0.9) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_13"]];
    }else {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_14"]];
    }
}

- (void) updateImage
{
    [self.imageView setImage:[UIImage imageNamed:@"record_animate_01"]];
}
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder
                           successfully:(BOOL)flag{
    if (flag){
        D("Successfully stopped the audio recording process.");
        [MBProgressHUD showMessage:@"正在上传" toView:self.view];
        /* Let's try to retrieve the data for the recorded file */
        //        NSError *playbackError = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *readingError = nil;
        NSData *fileData =[NSData dataWithContentsOfFile:mStr_path
                                                 options:NSDataReadingMapped
                                                   error:&readingError];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        NSString *path = [self audioRecordingPath000];
        path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.aac",timeSp]];
        
        BOOL yesNo=[[NSFileManager defaultManager] fileExistsAtPath:path];
        
        if (!yesNo) {//不存在，则直接写入后通知界面刷新
            BOOL result = [fileData writeToFile:path atomically:YES];
            for (;;) {
                if (result) {
                    NSString *name = [NSString stringWithFormat:@"%@.aac",timeSp];
                    [[ShareHttp getInstance] shareHttpUploadSectionImgWith:path Name:name];
                    break;
                }
            }
        }else {//存在
            BOOL blDele= [fileManager removeItemAtPath:path error:nil];//先删除
            if (blDele) {//删除成功后，写入，通知界面
                BOOL result = [fileData writeToFile:path atomically:YES];
                for (;;) {
                    if (result) {
                        NSString *name = [NSString stringWithFormat:@"%@.aac",timeSp];
                        [[ShareHttp getInstance] shareHttpUploadSectionImgWith:path Name:name];
                        break;
                    }
                }
            }
        }
        //添加显示附件
//        [self addAccessoryPhoto];
    } else {
        D("Stopping the audio recording failed.");
    }
    /* Here we don't need the audio recorder anymore */
    //    self.recorder = nil;
}

-(NSString *)audioRecordingPath{
    NSString *result = nil;
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    //    mStr_time = timeSp;
    NSString *tempPath = [self audioRecordingPath000];
    result = [tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.aac",timeSp]];
    return result;
}

-(NSString *)audioRecordingPath000{
    NSString *result = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
    //判断文件夹是否存在
    if(![fileManager fileExistsAtPath:tempPath]) {//如果不存在
        [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    result = tempPath;
    return result;
}

@end

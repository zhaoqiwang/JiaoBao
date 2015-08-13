//
//  KnowledgeAddAnswerViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/8/11.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "KnowledgeAddAnswerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "IQKeyboardManager.h"

@interface KnowledgeAddAnswerViewController ()

@end

@implementation KnowledgeAddAnswerViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //问题详情
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"QuestionDetail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QuestionDetail:) name:@"QuestionDetail" object:nil];
    //提交答案
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddAnswer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddAnswer:) name:@"AddAnswer" object:nil];
    //上传图片
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UploadImg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UploadImg:) name:@"UploadImg" object:nil];
    
    self.mArr_pic = [NSMutableArray array];
    //输入框弹出键盘问题
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;//控制整个功能是否启用
    manager.shouldResignOnTouchOutside = YES;//控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES;//控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:[NSString stringWithFormat:@"%@",self.mModel_question.Title]];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    //
    self.mScrollV_view.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height);
    [self.view addSubview:self.mScrollV_view];
    
    //标题话题等显示
    static NSString *indentifier = @"KnowledgeTableViewCell";
    if (self.mView_titlecell == nil) {
        self.mView_titlecell = [[KnowledgeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KnowledgeTableViewCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            self.mView_titlecell = (KnowledgeTableViewCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
    }
    //先隐藏
    self.mView_titlecell.hidden = YES;
    [self.mScrollV_view addSubview:self.mView_titlecell];
    
    //
    //添加边框
    self.mTextV_answer.layer.borderWidth = .5;
    self.mTextV_answer.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    //将图层的边框设置为圆脚
    self.mTextV_answer.layer.cornerRadius = 5;
    self.mTextV_answer.layer.masksToBounds = YES;
    //添加边框
    self.mTextV_content.layer.borderWidth = .5;
    self.mTextV_content.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    //将图层的边框设置为圆脚
    self.mTextV_content.layer.cornerRadius = 5;
    self.mTextV_content.layer.masksToBounds = YES;
    
    [[KnowledgeHttp getInstance] QuestionDetailWithQId:self.mModel_question.TabID];
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
}

//提交答案
-(void)AddAnswer:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *code = [dic objectForKey:@"code"];
    if ([code integerValue]==0) {
        self.mTextV_content.text = @"";
        self.mTextV_answer.text = @"";
        self.mLab_answer.hidden = NO;
        self.mLab_content.hidden = NO;
    }
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    [MBProgressHUD showSuccess:ResultDesc toView:self.view];
}

//问题详情
-(void)QuestionDetail:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *code = [dic objectForKey:@"code"];
    if ([code integerValue] ==0) {
        self.mModel_questionDetail = [dic objectForKey:@"model"];
        [self addDetailCell:self.mModel_questionDetail];
    }
}

-(void)addDetailCell:(QuestionDetailModel *)model{
    self.mView_titlecell.hidden = NO;
    //标题
    self.mView_titlecell.mLab_title.frame = CGRectMake(9, 10, [dm getInstance].width-9*2, 16);
    self.mView_titlecell.mLab_title.text = model.Title;
    self.mView_titlecell.mLab_title.hidden = NO;
    //详情
    self.mView_titlecell.mBtn_detail.hidden = YES;
    //话题
    self.mView_titlecell.mLab_Category0.frame = CGRectMake(30, self.mView_titlecell.mLab_title.frame.origin.y+16+5, self.mView_titlecell.mLab_Category0.frame.size.width, 21);
    CGSize CategorySize = [[NSString stringWithFormat:@"%@",self.mModel_question.CategorySuject] sizeWithFont:[UIFont systemFontOfSize:10]];
    self.mView_titlecell.mLab_Category1.frame = CGRectMake(30+self.mView_titlecell.mLab_Category0.frame.size.width+2, self.mView_titlecell.mLab_Category0.frame.origin.y, CategorySize.width, 21);
    self.mView_titlecell.mLab_Category1.text = self.mModel_question.CategorySuject;
    self.mView_titlecell.mLab_Category1.hidden = NO;
    self.mView_titlecell.mLab_Category0.hidden = NO;
    //访问
    CGSize ViewSize = [[NSString stringWithFormat:@"%@",model.ViewCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    self.mView_titlecell.mLab_ViewCount.frame = CGRectMake([dm getInstance].width-9-ViewSize.width, self.mView_titlecell.mLab_Category0.frame.origin.y, ViewSize.width, 21);
    self.mView_titlecell.mLab_ViewCount.text = model.ViewCount;
    self.mView_titlecell.mLab_ViewCount.hidden = NO;
    self.mView_titlecell.mLab_View.frame = CGRectMake(self.mView_titlecell.mLab_ViewCount.frame.origin.x-2-self.mView_titlecell.mLab_View.frame.size.width, self.mView_titlecell.mLab_Category0.frame.origin.y, self.mView_titlecell.mLab_View.frame.size.width, 21);
    self.mView_titlecell.mLab_View.hidden = NO;
    //回答
    CGSize AnswersSize = [[NSString stringWithFormat:@"%@",model.AnswersCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    self.mView_titlecell.mLab_AnswersCount.frame = CGRectMake(self.mView_titlecell.mLab_View.frame.origin.x-5-AnswersSize.width, self.mView_titlecell.mLab_Category0.frame.origin.y, AnswersSize.width, 21);
    self.mView_titlecell.mLab_AnswersCount.text = model.AnswersCount;
    self.mView_titlecell.mLab_AnswersCount.hidden = NO;
    self.mView_titlecell.mLab_Answers.frame = CGRectMake(self.mView_titlecell.mLab_AnswersCount.frame.origin.x-2-self.mView_titlecell.mLab_Answers.frame.size.width, self.mView_titlecell.mLab_Category0.frame.origin.y, self.mView_titlecell.mLab_Answers.frame.size.width, 21);
    self.mView_titlecell.mLab_Answers.hidden = NO;
    //关注
    CGSize AttSize = [[NSString stringWithFormat:@"%@",self.mModel_question.AttCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    self.mView_titlecell.mLab_AttCount.frame = CGRectMake(self.mView_titlecell.mLab_Answers.frame.origin.x-5-AttSize.width, self.mView_titlecell.mLab_Category0.frame.origin.y, AttSize.width, 21);
    self.mView_titlecell.mLab_AttCount.text = self.mModel_question.AttCount;
    self.mView_titlecell.mLab_AttCount.hidden = NO;
    self.mView_titlecell.mLab_Att.frame = CGRectMake(self.mView_titlecell.mLab_AttCount.frame.origin.x-2-self.mView_titlecell.mLab_Att.frame.size.width, self.mView_titlecell.mLab_Category0.frame.origin.y, self.mView_titlecell.mLab_Att.frame.size.width, 21);
    self.mView_titlecell.mLab_Att.hidden = NO;
    //赞
    self.mView_titlecell.mLab_LikeCount.hidden = YES;
    //头像
    self.mView_titlecell.mImgV_head.hidden = YES;
    //姓名
    self.mView_titlecell.mLab_IdFlag.hidden = YES;
    //回答标题
    self.mView_titlecell.mLab_ATitle.hidden = YES;
    //背景色
    self.mView_titlecell.mView_background.hidden = NO;
    self.mView_titlecell.mView_background.frame = CGRectMake(0, 0, [dm getInstance].width, self.mView_titlecell.mLab_Category0.frame.origin.y+self.mView_titlecell.mLab_Category0.frame.size.height+10);
    //回答内容
    self.mView_titlecell.mLab_Abstracts.hidden = NO;
    NSString *string2 = model.KnContent;
    string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\r" withString:@""];
    NSString *name2 = [NSString stringWithFormat:@"<font size=14 color='red'>详情 : </font> <font>%@</font>", string2];
    NSString *string = [NSString stringWithFormat:@"详情 : %@",string2];
    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-18, 1000)];
    self.mView_titlecell.mLab_Abstracts.frame = CGRectMake(9, self.mView_titlecell.mView_background.frame.origin.y+self.mView_titlecell.mView_background.frame.size.height+10, [dm getInstance].width-18, size.height);
    NSMutableDictionary *row2 = [NSMutableDictionary dictionary];
    [row2 setObject:name2 forKey:@"text"];
    RTLabelComponentsStructure *componentsDS2 = [RCLabel extractTextStyle:[row2 objectForKey:@"text"]];
    self.mView_titlecell.mLab_Abstracts.componentsAndPlainText = componentsDS2;
    //图片
    [self.mView_titlecell.mCollectionV_pic reloadData];
    self.mView_titlecell.mCollectionV_pic.hidden = NO;
    if (model.Thumbnail.count>0) {
        self.mView_titlecell.mCollectionV_pic.frame = CGRectMake(9, self.mView_titlecell.mLab_Abstracts.frame.origin.y+self.mView_titlecell.mLab_Abstracts.frame.size.height+5, [dm getInstance].width-65, ([dm getInstance].width-65-30)/3);
    }else{
        self.mView_titlecell.mCollectionV_pic.frame = self.mView_titlecell.mLab_Abstracts.frame;
    }
    //时间
    self.mView_titlecell.mLab_RecDate.hidden = YES;
    //评论
    self.mView_titlecell.mLab_commentCount.hidden = YES;
    self.mView_titlecell.mLab_comment.hidden = YES;
    //分割线
    self.mView_titlecell.mLab_line.hidden = NO;
    self.mView_titlecell.mLab_line.frame = CGRectMake(0, self.mView_titlecell.mCollectionV_pic.frame.origin.y+self.mView_titlecell.mCollectionV_pic.frame.size.height+5, [dm getInstance].width, .5);
    self.mView_titlecell.mLab_line2.hidden = YES;
    self.mView_titlecell.frame = CGRectMake(0, 0, [dm getInstance].width, self.mView_titlecell.mLab_line.frame.origin.y+1);
    
    //回答
    self.mTextV_answer.frame = CGRectMake(9, self.mView_titlecell.frame.origin.y+self.mView_titlecell.frame.size.height+10, [dm getInstance].width-18, 60);
    //内容描述
    self.mTextV_content.frame = CGRectMake(9, self.mTextV_answer.frame.origin.y+self.mTextV_answer.frame.size.height+10, [dm getInstance].width-27-40, 60);
    //照片按钮
    self.mBtn_photo.frame = CGRectMake([dm getInstance].width-49, self.mTextV_content.frame.origin.y, 40, 40);
    //提交按钮
    self.mBtn_submit.frame = CGRectMake(([dm getInstance].width-70*2-30)/2, self.mTextV_content.frame.origin.y+self.mTextV_content.frame.size.height+10, 70, self.mBtn_submit.frame.size.height);
    self.mBtn_anSubmit.frame = CGRectMake(self.mBtn_submit.frame.origin.x+100, self.mBtn_submit.frame.origin.y, 70, self.mBtn_submit.frame.size.height);
    //提示信息坐标
    [self placeTextFrame];
    self.mScrollV_view.contentSize = CGSizeMake([dm getInstance].width, self.mBtn_submit.frame.origin.y+self.mBtn_submit.frame.size.height+20);
}

-(void)placeTextFrame{
    self.mLab_answer.frame = CGRectMake(12, self.mTextV_answer.frame.origin.y+3, self.mLab_answer.frame.size.width, self.mLab_answer.frame.size.height);
    self.mLab_content.frame = CGRectMake(12, self.mTextV_content.frame.origin.y+3, self.mLab_content.frame.size.width, self.mLab_content.frame.size.height);
}

-(IBAction)mBtn_submit:(id)sender{
    [self submitAnswer:0];
}
-(IBAction)mBtn_anSubmit:(id)sender{
    [self submitAnswer:1];
}
-(IBAction)mBtn_photo:(id)sender{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册选择", nil];
    }else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    [sheet showInView:self.view];
}

//提交答案
-(void)submitAnswer:(int)flag{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if (self.mTextV_answer.text.length==0) {
        [MBProgressHUD showError:@"请输入答案标题" toView:self.view];
        return;
    }
    if (self.mTextV_content.text.length ==0) {
        [MBProgressHUD showError:@"请输入答案内容" toView:self.view];
        return;
    }
    NSString *name = @"";
    if (flag ==0) {
        name = [dm getInstance].NickName;
    }
    NSString *content = self.mTextV_content.text;
    for (int i=0; i<self.mArr_pic.count; i++) {
        UploadImgModel *model = [self.mArr_pic objectAtIndex:i];
        NSString *temp = model.originalName;
        content = [content stringByReplacingOccurrencesOfString:temp withString:model.url];
    }
    content = [NSString stringWithFormat:@"<p>%@</p>",content];
    [[KnowledgeHttp getInstance] AddAnswerWithQId:self.mModel_question.TabID Title:self.mTextV_answer.text AContent:content UserName:name];
    [MBProgressHUD showMessage:@"提交中..." toView:self.view];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    D("dijgldgj-====%@,%@",textView.text,text);
    if ([self.mTextV_answer.text isEqualToString:@""]) {
        self.mLab_answer.hidden = NO;
    }else{
        self.mLab_answer.hidden = YES;
    }
    if ([self.mTextV_content.text isEqualToString:@""]) {
        self.mLab_content.hidden = NO;
    }else{
        self.mLab_content.hidden = YES;
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

#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    return;
                case 1: //相机
                {
                    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                    imagePickerController.delegate = self;
                    imagePickerController.allowsEditing = NO;
                    imagePickerController.sourceType = sourceType;
                    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
                        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                    }
//                    self.tfContentTag = self.mArr_pic.count;
                    [self presentViewController:imagePickerController animated:YES completion:^{}];
                }
                    break;
                case 2: //相册
                {
                    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
                    
                    elcPicker.maximumImagesCount = 10; //Set the maximum number of images to select to 10
                    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
                    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
                    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
                    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image and movie types
                    
                    elcPicker.imagePickerDelegate = self;
//                    self.tfContentTag= self.mArr_pic.count;
                    
                    [self presentViewController:elcPicker animated:YES completion:nil];
                }
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                return;
            } else {
                ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
                
                elcPicker.maximumImagesCount = 10; //Set the maximum number of images to select to 10
                elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
                elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
                elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
                elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image and movie types
                
                elcPicker.imagePickerDelegate = self;
//                self.tfContentTag= self.mArr_pic.count;
                
                [self presentViewController:elcPicker animated:YES completion:nil];
            }
            
        }
        
        
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
        self.mLab_content.hidden = YES;
    }else{
        [MBProgressHUD showError:@"失败" toView:self.view];
    }
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
                    break;
                }
            }
        }
    }
    
    self.mInt_index ++;
    //[self.mProgressV hide:YES];
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

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
    
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

//导航条返回按钮回调
-(void)myNavigationGoback{
    [IQKeyboardManager sharedManager].enable = NO;//控制整个功能是否启用
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

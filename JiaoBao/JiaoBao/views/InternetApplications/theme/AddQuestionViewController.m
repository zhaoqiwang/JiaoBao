//
//  AddQuestionViewController.m
//  JiaoBao
//
//  Created by songyanming on 15/8/11.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "AddQuestionViewController.h"
#import "KnowledgeHttp.h"
#import "TableViewWithBlock.h"
#import "ProviceModel.h"
#import "AllCategoryModel.h"
#import "CategoryViewController.h"
#import "IQKeyboardManager.h"
#import "ShareHttp.h"


@interface AddQuestionViewController ()
@property(nonatomic,strong)TableViewWithBlock *mTableV_name;
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,strong)NSArray *provinceArr;
@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,strong)UITextField *selectedTF;
@property(nonatomic,strong)ProviceModel *proviceModel;
@end

@implementation AddQuestionViewController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//获取省份
-(void)knowledgeHttpGetProvice:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *dic = [sender object];
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if([ResultCode integerValue] != 0)
    {
        [MBProgressHUD showError:ResultDesc];
        return;
    }
    else
    {
        NSArray *arr = [dic objectForKey:@"array"];
        self.dataArr = arr;
        self.provinceArr = arr;
        
    }
    self.mTableV_name = [[TableViewWithBlock alloc]initWithFrame:CGRectMake(self.provinceTF.frame.origin.x, self.provinceTF.frame.origin.y+30, 166, 0)] ;
    [self.mTableV_name initTableViewDataSourceAndDelegate:^NSInteger(UITableView *tableView,NSInteger section){
        return self.dataArr.count;
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectionCell"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        ProviceModel *model = [self.dataArr objectAtIndex:indexPath.row];
        cell.textLabel.text = model.CnName ;
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        [UIView animateWithDuration:0.3 animations:^{
            self.mTableV_name.frame =  CGRectMake(self.selectedTF.frame.origin.x, self.selectedTF.frame.origin.y+30, 166, 0);
            
            
        } completion:^(BOOL finished){
            ProviceModel *model = [self.dataArr objectAtIndex:indexPath.row];
            self.selectedTF.text = model.CnName;
            self.proviceModel = model;
        }];
        if([self.selectedTF isEqual:self.provinceTF])
        {
            self.regionTF.text = @"";
            self.countyTF.text = @"";
        }
        if([self.selectedTF isEqual:self.regionTF])
        {
            self.countyTF.text = @"";

        }
        self.isOpen = NO;
        
        
    }];
    
    [self.mTableV_name.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.mTableV_name.layer setBorderWidth:2];
    [self.mainScrollView addSubview:self.mTableV_name];

    
    

}

//获取地区或区县
-(void)knowledgeHttpGetCity:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *dic = [sender object];
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if([ResultCode integerValue] != 0)
    {
        [MBProgressHUD showError:ResultDesc];
        return;
    }
    else
    {
        NSArray *arr = [dic objectForKey:@"array"];
        self.dataArr = arr;
        
    }
    [self.mTableV_name reloadData];


}
//获取分类
-(void)GetAllCategory:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view];
    NSDictionary *dic = [sender object];
    self.mArr_AllCategory =[dic objectForKey:@"array"] ;
    CategoryViewController *detailVC = [[CategoryViewController alloc]initWithNibName:@"CategoryViewController" bundle:nil];
    detailVC.mArr_selectCategory = [[NSMutableArray alloc]initWithCapacity:0];

    detailVC.modalPresentationStyle = UIModalPresentationFullScreen;
    detailVC.categoryTF = self.categoryTF;
    detailVC.categoryId = self.categoryId;
    detailVC.classStr = [NSString stringWithUTF8String:object_getClassName(self)];
    detailVC.mArr_AllCategory = self.mArr_AllCategory;
    [self.navigationController presentViewController:detailVC animated:YES completion:^{
        //detailVC.view.superview.frame = CGRectMake(10, 44+30, [dm getInstance].width-20, [dm getInstance].height-84);

        
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //[IQKeyboardManager sharedManager].enable = NO;//控制整个功能是否启用
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.mainScrollView.contentSize = self.mainScrollView.frame.size;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //输入框弹出键盘问题
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;//控制整个功能是否启用
    manager.shouldResignOnTouchOutside = YES;//控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES;//控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = YES;//控制是否显示键盘上的工具条

    //上传图片
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UploadImg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UploadImg:) name:@"UploadImg" object:nil];
    self.mArr_pic = [NSMutableArray array];

    self.selectedTF = self.provinceTF;
    self.categoryId = [NSMutableString stringWithString:@"1"];
    if([self.provinceTF.text isEqualToString:@""])
    {
        D("provinceTF_text = %@",self.provinceTF.text);

    }
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"添加问题"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    [[KnowledgeHttp getInstance]knowledgeHttpGetProvice];
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"knowledgeHttpGetProvice" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(knowledgeHttpGetProvice:) name:@"knowledgeHttpGetProvice" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"knowledgeHttpGetCity" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(knowledgeHttpGetCity:) name:@"knowledgeHttpGetCity" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetAllCategory" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetAllCategory:) name:@"GetAllCategory" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"NewQuestionWithCategoryId" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(NewQuestionWithCategoryId:) name:@"NewQuestionWithCategoryId" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetAccIdbyNickname" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetAccIdbyNickname:) name:@"GetAccIdbyNickname" object:nil];
    
    self.mText_title.layer.borderWidth = .5;
    self.mText_title.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    //将图层的边框设置为圆脚
    self.mText_title.layer.cornerRadius = 5;
    self.mText_title.layer.masksToBounds = YES;
    
    self.mTextV_content.layer.borderWidth = .5;
    self.mTextV_content.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    //将图层的边框设置为圆脚
    self.mTextV_content.layer.cornerRadius = 5;
    self.mTextV_content.layer.masksToBounds = YES;
    
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc] initWithString:@"标题" attributes:nil];
    NSTextAttachment *textAttach = [[NSTextAttachment alloc]init];
    textAttach.image = [UIImage imageNamed:@"buttonView3"];
    textAttach.bounds=CGRectMake(3, 0, 10, 10);
    NSAttributedString *strA = [NSAttributedString attributedStringWithAttachment:textAttach];
    [str insertAttributedString:strA atIndex:2];

    self.ttitleLabel.attributedText = str;
    
    NSMutableAttributedString *str1=[[NSMutableAttributedString alloc] initWithString:@"问题描述" attributes:nil];
    
    [str1 insertAttributedString:strA atIndex:4];
    self.contentLabel.attributedText = str1;
    
    NSMutableAttributedString *str2=[[NSMutableAttributedString alloc] initWithString:@"问题分类" attributes:nil];
    
    [str2 insertAttributedString:strA atIndex:4];
    self.categoryLabel.attributedText = str2;

}
//通过昵称获取教宝号
-(void)GetAccIdbyNickname:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *dic = [sender object];
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if([ResultCode integerValue] != 0)
    {
        [MBProgressHUD showError:ResultDesc];
        return;
    }
    else
    {
        NSArray *arr = [dic objectForKey:@"array"];
        NSString *str = [arr componentsJoinedByString:@","];
        NSString *content = self.mTextV_content.text;
        for (int i=0; i<self.mArr_pic.count; i++) {
            UploadImgModel *model = [self.mArr_pic objectAtIndex:i];
            NSString *temp = model.originalName;
            content = [content stringByReplacingOccurrencesOfString:temp withString:model.url];
        }
        content = [NSString stringWithFormat:@"<p>%@</p>",content];
        [[KnowledgeHttp getInstance]NewQuestionWithCategoryId:self.categoryId Title:self.mText_title.text KnContent:content TagsList:@"" QFlag:@"" AreaCode:self.AreaCode atAccIds:str];
        
    }
}
//发布问题回调
-(void)NewQuestionWithCategoryId:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *dic = [sender object];
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if([ResultCode integerValue] != 0)
    {
        [MBProgressHUD showError:ResultDesc];
        return;
    }
    else
    {
        [MBProgressHUD showSuccess:@"发布问题成功"];
    }
}
//点击省份
- (IBAction)provinceBtnAction:(id)sender {
    self.selectedTF = self.provinceTF;
    self.dataArr = self.provinceArr;
    [self.mTableV_name reloadData];

    if(self.isOpen == NO)
    {
           [UIView animateWithDuration:0.3 animations:^{
              int h = self.mainScrollView.frame.size.height-self.provinceTF.frame.size.height-self.provinceTF.frame.origin.y;
               if(44*self.dataArr.count>h)
               {
                           self.mTableV_name.frame =  CGRectMake(self.provinceTF.frame.origin.x, self.provinceTF.frame.origin.y+30, 166, h);
               }
               else
               {
                    self.mTableV_name.frame =  CGRectMake(self.provinceTF.frame.origin.x, self.provinceTF.frame.origin.y+30, 166, 44*self.dataArr.count);
               }

    } completion:^(BOOL finished){
    }];

    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.mTableV_name.frame =  CGRectMake(self.provinceTF.frame.origin.x, self.provinceTF.frame.origin.y+30, 166, 0);
            
            
        } completion:^(BOOL finished){
        }];
    }
    self.isOpen = !self.isOpen;

    //self.mainScrollView.contentSize = self.mainScrollView.frame.size;
    
}
//点击地区
- (IBAction)regionBtnAction:(id)sender {
    if([self.provinceTF.text isEqualToString:@""])
    {
        return;
    }
    self.selectedTF = self.regionTF;
    self.countyTF.text = @"";
    [[KnowledgeHttp getInstance]knowledgeHttpGetCity:self.proviceModel.CityCode level:@"1"];
    if(self.isOpen == NO)
    {
        [UIView animateWithDuration:0.3 animations:^{
            int h = self.mainScrollView.frame.size.height-self.selectedTF.frame.size.height-self.selectedTF.frame.origin.y;

                self.mTableV_name.frame =  CGRectMake(self.selectedTF.frame.origin.x, self.selectedTF.frame.origin.y+30, 166, h);
            

            //self.mTableV_name.frame =  CGRectMake(self.selectedTF.frame.origin.x, self.selectedTF.frame.origin.y+30, 166, 44*5);
            
        }];
        
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.mTableV_name.frame =  CGRectMake(self.regionTF.frame.origin.x, self.regionTF.frame.origin.y+30, 166, 0);
            
            
        } completion:^(BOOL finished){
        }];
    }
    self.isOpen = !self.isOpen;
}
//点击区县
- (IBAction)countyBtnAction:(id)sender {
    if([self.provinceTF.text isEqualToString:@""]||[self.regionTF.text isEqualToString:@""])
    {
        return;
    }
    self.selectedTF = self.countyTF;
    [[KnowledgeHttp getInstance]knowledgeHttpGetCity:self.proviceModel.CityCode level:@"2"];
    if(self.isOpen == NO)
    {
        [UIView animateWithDuration:0.3 animations:^{
            int h = self.mainScrollView.frame.size.height-self.selectedTF.frame.size.height-self.selectedTF.frame.origin.y;
            D("mainScrollView_height = %f selectedTF_height = %f  selectedTF_y = %f",self.mainScrollView.frame.size.height,self.selectedTF.frame.size.height,self.selectedTF.frame.origin.y);

                self.mTableV_name.frame =  CGRectMake(self.selectedTF.frame.origin.x, self.selectedTF.frame.origin.y+30, 166, h);

           // self.mTableV_name.frame =  CGRectMake(self.selectedTF.frame.origin.x, self.selectedTF.frame.origin.y+30, 166, 44*5);
            
        }];
        
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.mTableV_name.frame =  CGRectMake(self.countyTF.frame.origin.x, self.countyTF.frame.origin.y+30, 166, 0);
            
            
        } completion:^(BOOL finished){
        }];
    }
    self.isOpen = !self.isOpen;
}
//点击分类
- (IBAction)categaryBtnAction:(id)sender {
    [[KnowledgeHttp getInstance]GetAllCategory];
    [MBProgressHUD showMessage:@"" toView:self.view];


}
//点击拍照
-(IBAction)mBtn_photo:(id)sender{

    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册选择", nil];
    }else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    [sheet showInView:self.view];
    self.tfContentTag = self.mArr_pic.count;
}

//点击发布问题
- (IBAction)addQuestionAction:(id)sender {
    
    if([self.categoryTF.text isEqualToString: @""])
    {
        [MBProgressHUD showError:@"请添写标题"];
        return;
    }
    if([self.knContentTF.text isEqualToString: @""])
    {
        [MBProgressHUD showError:@"请添写问题描述"];
        return;
    }
    if([self.knContentTF.text isEqualToString: @""])
    {
        [MBProgressHUD showError:@"请选择问题描述"];
        return;
    }
    if(self.proviceModel == nil)
    {
        self.AreaCode = @"";
    }
    else
    {
        self.AreaCode = self.proviceModel.CityCode;
    }
//    NSString *content = self.mTextV_content.text;
//    for (int i=0; i<self.mArr_pic.count; i++) {
//        UploadImgModel *model = [self.mArr_pic objectAtIndex:i];
//        NSString *temp = model.originalName;
//        content = [content stringByReplacingOccurrencesOfString:temp withString:model.url];
//    }
//    content = [NSString stringWithFormat:@"<p>%@</p>",content];
//    D("content--------%@",content);
    
    NSArray *arr = [self.atAccIdsTF.text componentsSeparatedByString:@","];
    
    [[KnowledgeHttp getInstance]GetAccIdbyNickname:arr];
    

    //[MBProgressHUD showMessage:@""];
    
}

-(void)myNavigationGoback{
    
    [utils popViewControllerAnimated:YES];
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
                    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
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
//                NSMutableAttributedString *str=[[NSMutableAttributedString alloc] initWithString:@"" attributes:nil];
//                NSTextAttachment *textAttach = [[NSTextAttachment alloc]init];
//                textAttach.image = [UIImage imageNamed:@"buttonView3"];
//                textAttach.bounds=CGRectMake(3, 0, 10, 10);
//                NSAttributedString *strA = [NSAttributedString attributedStringWithAttachment:textAttach];
//                [str insertAttributedString:strA atIndex:2];
//                self.ttitleLabel.attributedText = str;

                UploadImgModel *model1 = [self.mArr_pic objectAtIndex:i];
                self.mTextV_content.text = [NSString stringWithFormat:@"%@%@",self.mTextV_content.text,model1.originalName];
                
            }
            
        }
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

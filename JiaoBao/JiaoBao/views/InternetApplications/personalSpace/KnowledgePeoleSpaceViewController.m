//
//  KnowledgePeoleSpaceViewController.m
//  JiaoBao
//
//  Created by songyanming on 15/9/16.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "KnowledgePeoleSpaceViewController.h"
#import "KpeopleSpaceCell.h"
#import "MyNavigationBar.h"
#import "HeadCell.h"
#import "define_constant.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "dm.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "utils.h"
#import "MBProgressHUD+AD.h"
#import "RegisterHttp.h"
#import "KnowledgeHttp.h"
#import "AttentionCategoryVCViewController.h"
#import "AtMeQIndexViewController.h"
#import "MyQuestionViewController.h"
#import "MyAnswerViewController.h"
#import "MyAttQViewController.h"
#import "PointsModel.h"
#import "MyCommentViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface KnowledgePeoleSpaceViewController ()<MyNavigationDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)NSArray *questionArr;
@property(nonatomic,strong)NSArray *categoryArr;
@property(nonatomic,strong)NSArray *datasource;
@property(nonatomic,strong)MyNavigationBar *mNav_navgationBar;
@property(nonatomic,strong)UIImagePickerController *picker;
@property(nonatomic,strong)HeadCell *HeadCell;
@property (nonatomic,strong) NSData *tempData;




@end

@implementation KnowledgePeoleSpaceViewController
-(void)changeFaceImg:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSNotification *note = sender;
    NSDictionary *dic = note.object;
    NSArray *keyArr =[dic allKeys];
    NSString *str = [keyArr objectAtIndex:0];
    NSString *ResultDesc = [dic objectForKey:str];
    if([str integerValue]==0)
    {
        [MBProgressHUD showSuccess:@"修改头像成功" toView:self.view];
        [[SDImageCache sharedImageCache] removeImageForKey:[NSString stringWithFormat:@"%@%@",AccIDImg,[dm getInstance].jiaoBaoHao] withCompletion:nil];
        [self.HeadCell.mImgV_head sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,[dm getInstance].jiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];
    }
    else
    {
        [MBProgressHUD showSuccess:ResultDesc toView:self.view];
        
    }
    

    
}
-(void)GetMyattCate:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSNotification *note = sender;

    NSString *code = [note.object objectForKey:@"ResultCode"];
    if([code integerValue]==0)
    {
        NSArray *arr = [note.object objectForKey:@"array"];
        self.categoryArr = arr;
        if(arr.count>0)
        {
            self.HeadCell.mLab_categoryCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)arr.count];

        }
        else
        {
            self.HeadCell.mLab_categoryCount.text = @"0";
        }
    }
    else
    {
        NSString *ResultDesc = [note.object objectForKey:@"ResultDesc"];

        [MBProgressHUD showError:ResultDesc toView:self.view];
        
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [[KnowledgeHttp getInstance]GetMyattCate];
//    [MBProgressHUD showMessage:@"" toView:self.view];
}
-(void)GetMyPointsDayWithAccId:(NSNotification*)sender
{
    PointsModel *model = [sender object];
    if (model.Point) {
        int dayPoint = [model.Point intValue]+[model.DelPoint intValue];
        self.HeadCell.dayPointsLabel.text = [NSString stringWithFormat:@"%d",dayPoint];
    }
    [[KnowledgeHttp getInstance]GetMyPointsMonthWithAccId:[dm getInstance].jiaoBaoHao dateTime:@""];

}

-(void)GetMyPointsMonthWithAccId:(NSNotification*)sender
{
    PointsModel *model = [sender object];
    if (model.Point) {
        int monthPoint = [model.Point intValue]+[self.HeadCell.dayPointsLabel.text intValue];
        self.HeadCell.monthPointsLabel.text = [NSString stringWithFormat:@"%d",monthPoint];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [[KnowledgeHttp getInstance]GetMyPointsDayWithAccId:[dm getInstance].jiaoBaoHao dateTime:@""];
    //获取日积分
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetMyPointsDayWithAccId" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetMyPointsDayWithAccId:) name:@"GetMyPointsDayWithAccId" object:nil];
    //获取月积分
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetMyPointsMonthWithAccId" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetMyPointsMonthWithAccId:) name:@"GetMyPointsMonthWithAccId" object:nil];
    //改变头像
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changeFaceImg" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeFaceImg:) name:@"changeFaceImg" object:nil];
    //获取我关注的话题数组
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetMyattCate" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetMyattCate:) name:@"GetMyattCate" object:nil];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"求知个人中心"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
//    self.questionArr = [NSArray arrayWithObjects:@"我答过得问题",@"我提出的问题",@"邀请我回答的问题",@"我关注的问题", nil];
//    self.categoryArr = [NSArray arrayWithObjects:@"", nil];
    self.datasource = [NSArray arrayWithObjects:@"我答过的问题",@"我提出的问题",@"邀请我回答的问题",@"我关注的问题",@"我做出的评论", nil];
    self.HeadCell = [[HeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HeadCell"];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HeadCell" owner:self options:nil];
    if ([nib count]>0) {
        self.HeadCell = (HeadCell *)[nib objectAtIndex:0];
        //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
    }
        [self.HeadCell.mImgV_head sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,[dm getInstance].jiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];
    self.HeadCell.mLab_trueName.text = [dm getInstance].TrueName;
    self.HeadCell.mLab_nickName.text = [dm getInstance].NickName;
    [self.HeadCell.imgBtn addTarget:self action:@selector(imgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.HeadCell.categoryBtn addTarget:self action:@selector(categoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.HeadCell.personBtn addTarget:self action:@selector(personBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.HeadCell.meBtn addTarget:self action:@selector(meBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    UIView *headView = [[UIView alloc]initWithFrame:self.HeadCell.frame];
    headView.backgroundColor = [UIColor clearColor];
    [headView addSubview:self.HeadCell];
    self.tableView.tableHeaderView = headView;
    // Do any additional setup after loading the view from its nib.
}

-(void)imgBtnAction:(id)sender
{
    UIActionSheet *  action = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照",nil];
    action.tag = 1;
    [action showInView:self.view];
}
-(void)personBtnAction:(id)sender{
    [MBProgressHUD showError:@"该功能暂未开放" toView:self.view];
}
-(void)meBtnAction:(id)sender{
    [MBProgressHUD showError:@"该功能暂未开放" toView:self.view];
}
-(void)categoryBtnAction:(id)sender
{
    AttentionCategoryVCViewController *detail = [[AttentionCategoryVCViewController alloc]init];
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [self.categoryArr count]; i++){
        if ([categoryArray containsObject:[self.categoryArr objectAtIndex:i]] == NO){
            [categoryArray addObject:[self.categoryArr objectAtIndex:i]];
        }
        
    }
    detail.categoryArr = categoryArray;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1) {//单位
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                    
                case 1: //相机
                {
                    NSString *mediaType = AVMediaTypeVideo;
                    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                    if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
                        [MBProgressHUD showError:@"请开启摄像头功能" toView:self.view];
                        return;
                    }
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
                case 0: //相册
                {
                    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
                    if(author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
                        [MBProgressHUD showError:@"您暂时没有访问相册的权限" toView:self.view];
                        return;
                    }
                    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
                    
                    elcPicker.maximumImagesCount = 1; //Set the maximum number of images to select to 10
                    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
                    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
                    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
                    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image and movie types
                    
                    elcPicker.imagePickerDelegate = self;
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
                
                elcPicker.maximumImagesCount = 1; //Set the maximum number of images to select to 10
                elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
                elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
                elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
                elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image and movie types
                elcPicker.imagePickerDelegate = self;
                
                [self presentViewController:elcPicker animated:YES completion:nil];
            }
            
        }
        
        
    }
    
}

-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType{
    NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediatypes count]>0) {
        NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
        self.picker=[[UIImagePickerController alloc] init];
        self.picker.mediaTypes=mediatypes;
        self.picker.delegate=self;
        //        picker.allowsEditing=YES;
        self.picker.sourceType=sourceType;
        
        
        if([[[UIDevice
              currentDevice] systemVersion] floatValue]>=8.0) {
            
            self.picker.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            
        }
        NSString *requiredmediatype=(NSString *)kUTTypeImage;
        NSArray *arrmediatypes=[NSArray arrayWithObject:requiredmediatype];
        [self.picker setMediaTypes:arrmediatypes];

        [utils pushViewController1:self.picker animated:YES];
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误信息!" message:@"当前设备不支持拍摄功能" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma 拍照模块
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    NSString *lastChosenMediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if([lastChosenMediaType isEqual:(NSString *) kUTTypeImage])
    {
        UIImage *chosenImage=[info objectForKey:UIImagePickerControllerOriginalImage];
        chosenImage = [self fixOrientation:chosenImage];

        NSData *imageData = UIImageJPEGRepresentation(chosenImage,0);
        self.tempData  = [[NSData alloc] initWithData:imageData];
        if(imageData.length>10000000){
            [MBProgressHUD showError:@"图片大小不能超过10M"];
            return;
        }
        [[RegisterHttp getInstance]registerHttpUpDateFaceImg:imageData];
        [MBProgressHUD showMessage:@"正在修改" toView:self.view];
    }
    
    
    
    if([lastChosenMediaType isEqual:(NSString *) kUTTypeMovie])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示信息!" message:@"系统只支持图片格式" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        
    }
    
}
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    if(info.count>0)
    {
        [MBProgressHUD showMessage:@"正在修改" toView:self.view];
        
    }
    [self dismissViewControllerAnimated:YES completion:^{
        for (NSDictionary *dict in info) {
            if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
                if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                    UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];

                        image = [self fixOrientation:image];
                    
                    NSData *imageData = UIImageJPEGRepresentation(image,1);
                    [[RegisterHttp getInstance]registerHttpUpDateFaceImg:imageData];
                }
            }
        }
    }
     
     
     ];
}
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma - mark tableview代理方法

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [self.datasource objectAtIndex:section];
    return self.datasource.count;

    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 54;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"KpeopleSpaceCell";
    KpeopleSpaceCell *cell = (KpeopleSpaceCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KpeopleSpaceCell" owner:self options:nil] lastObject];
    }

    cell.textLabel.text = [self.datasource objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    @"我答过得问题",@"我提出的问题",@"邀请我回答的问题",@"我关注的问题"
    if (indexPath.row==0) {
        MyAnswerViewController *view = [[MyAnswerViewController alloc] init];
        [utils pushViewController:view animated:YES];
    }else if (indexPath.row==1){
        MyQuestionViewController *view = [[MyQuestionViewController alloc] init];
        [utils pushViewController:view animated:YES];
    }else if (indexPath.row==2){
        AtMeQIndexViewController *view = [[AtMeQIndexViewController alloc] init];
        [utils pushViewController:view animated:YES];
    }else if (indexPath.row==3){
        MyAttQViewController *view = [[MyAttQViewController alloc] init];
        [utils pushViewController:view animated:YES];
    }else if(indexPath.row == 4){
        MyCommentViewController *view = [[MyCommentViewController alloc] init];
        [utils pushViewController:view animated:YES];
    }
}

//导航条返回按钮回调
-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}



@end

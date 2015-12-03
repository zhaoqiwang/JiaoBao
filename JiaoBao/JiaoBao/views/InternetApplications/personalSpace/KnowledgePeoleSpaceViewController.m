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
        [[SDImageCache sharedImageCache] removeImageForKey:[NSString stringWithFormat:@"%@%@",AccIDImg,[dm getInstance].jiaoBaoHao]];
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
    [MBProgressHUD showMessage:@"" toView:self.view];
}
-(void)GetMyPointsDayWithAccId:(NSNotification*)sender
{
    PointsModel *model = [sender object];
    if (model.Point) {
        self.HeadCell.dayPointsLabel.text = model.Point;
    }
}

-(void)GetMyPointsMonthWithAccId:(NSNotification*)sender
{
    PointsModel *model = [sender object];
    if (model.Point) {
        self.HeadCell.monthPointsLabel.text = model.Point;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //[[KnowledgeHttp getInstance]GetMyCommsWithNumPerPage:@"10" pageNum:@"0"];
    [[KnowledgeHttp getInstance]GetMyPointsDayWithAccId:[dm getInstance].jiaoBaoHao dateTime:@""];
    [[KnowledgeHttp getInstance]GetMyPointsMonthWithAccId:[dm getInstance].jiaoBaoHao dateTime:@""];
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
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"个人中心"];
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

    UIView *headView = [[UIView alloc]initWithFrame:self.HeadCell.frame];
    headView.backgroundColor = [UIColor clearColor];
    [headView addSubview:self.HeadCell];
    self.tableView.tableHeaderView = headView;
    // Do any additional setup after loading the view from its nib.
}

-(void)imgBtnAction:(id)sender
{
    UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照",nil];
    action.tag = 1;
    [action showInView:self.view];
}
-(void)categoryBtnAction:(id)sender
{
    AttentionCategoryVCViewController *detail = [[AttentionCategoryVCViewController alloc]init];
    detail.categoryArr = self.categoryArr;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1) {//单位
        if (buttonIndex == 0){//相册添加
            [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];

        }else if (buttonIndex == 1){//拍照添加
            [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
        }
    }
}

-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType{
    NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
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
    NSString *lastChosenMediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if([lastChosenMediaType isEqual:(NSString *) kUTTypeImage])
    {
        UIImage *chosenImage=[info objectForKey:UIImagePickerControllerOriginalImage];
        
        NSData *imageData = UIImageJPEGRepresentation(chosenImage,0);
        self.tempData  = [[NSData alloc] initWithData:imageData];
        [[RegisterHttp getInstance]registerHttpUpDateFaceImg:imageData];
        [MBProgressHUD showMessage:@"正在修改" toView:self.view];
    }
    
    
    
    if([lastChosenMediaType isEqual:(NSString *) kUTTypeMovie])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示信息!" message:@"系统只支持图片格式" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        
    }
    
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
    }
}

//导航条返回按钮回调
-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}




@end

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

@interface SharePostingViewController ()
@property (nonatomic,strong)TableViewWithBlock *mTableV_type;//下拉选择框
@property(nonatomic,assign)BOOL isOpen;//是否下拉的标志

@end

@implementation SharePostingViewController
@synthesize mNav_navgationBar,mProgressV,mTextV_content,mBtn_send,mBtn_selectPic,mTextF_title,mInt_index,mArr_pic,mModel_unit,mInt_section;


-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    //上传图片
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UploadImg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UploadImg:) name:@"UploadImg" object:nil];
    //通知界面发表文章成功
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SavePublishArticle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SavePublishArticle:) name:@"SavePublishArticle" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isOpen = NO;
    NSArray *pullArr = [NSArray arrayWithObjects:@"分享",@"展示", nil];
    if(self.isOpen == NO)
    {
        self.mTableV_type = [[TableViewWithBlock alloc]initWithFrame:CGRectZero];
    }
    else
    {
    self.mTableV_type = [[TableViewWithBlock alloc]initWithFrame:CGRectMake(self.pullDownBtn.frame.origin.x, self.pullDownBtn.frame.origin.y+self.pullDownBtn.frame.size.height, self.pullDownBtn.frame.size.width, self.pullDownBtn.frame.size.height*2)];
    }
   [ self.mTableV_type initTableViewDataSourceAndDelegate:^NSInteger(UITableView *tableView, NSInteger section) {
        return pullArr.count;
        
    } setCellForIndexPathBlock:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
                SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
                if (!cell) {
                    cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                }
                [cell.lb setText:[NSString stringWithFormat:@"%@",[pullArr objectAtIndex:indexPath.row]]];
                return cell;
    } setDidSelectRowBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
        [self.pullDownBtn setTitle:[pullArr objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        self.mTableV_type.frame = CGRectZero;
        self.isOpen = NO;
        self.mInt_section = indexPath.row;
        
    }];
    [self.view addSubview:self.mTableV_type];
    [self.mTableV_type.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.mTableV_type.layer setBorderWidth:2];
    [self.pullDownBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.pullDownBtn.layer setBorderWidth:2];
    
//    self.mTableV_type = [[TableViewWithBlock alloc]initTableViewDataSourceAndDelegate:^NSInteger(UITableView *tableView, NSInteger section) {
//        return pullArr.count;
//    } setCellForIndexPathBlock:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
//        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
//        if (!cell) {
//            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
//            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
//        }
//        [cell.lb setText:[NSString stringWithFormat:@"%@",[pullArr objectAtIndex:indexPath.row]]];
//        return cell;
//
//    } setDidSelectRowBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
//        
//    }];
    // Do any additional setup after loading the view from its nib.
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    
    self.mArr_pic = [NSMutableArray array];
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"发表文章"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    //标题
    self.mTextF_title.frame = CGRectMake(10, self.mNav_navgationBar.frame.size.height+10, [dm getInstance].width-20, self.mTextF_title.frame.size.height);
    //内容
    self.mTextV_content.frame = CGRectMake(10, self.mTextF_title.frame.origin.y+self.mTextF_title.frame.size.height+10, [dm getInstance].width-20, 50);
    //添加边框
    self.mTextV_content.layer.borderWidth = .5;
    self.mTextV_content.layer.borderColor = [[UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1] CGColor];
    //将图层的边框设置为圆脚
    self.mTextV_content.layer.cornerRadius = 8;
    self.mTextV_content.layer.masksToBounds = YES;
    //发表按钮
    self.mBtn_send.frame = CGRectMake([dm getInstance].width-self.mBtn_send.frame.size.width-10, self.mTextV_content.frame.origin.y+self.mTextV_content.frame.size.height+10, self.mBtn_send.frame.size.width, self.mBtn_send.frame.size.height);
    [self.mBtn_send addTarget:self action:@selector(clickPosting:) forControlEvents:UIControlEventTouchUpInside];
    //选择图片按钮
    self.mBtn_selectPic.frame = CGRectMake([dm getInstance].width-self.mBtn_send.frame.size.width-self.mBtn_selectPic.frame.size.width-20, self.mTextV_content.frame.origin.y+self.mTextV_content.frame.size.height+10, self.mBtn_selectPic.frame.size.width, self.mBtn_selectPic.frame.size.height);
    [self.mBtn_selectPic addTarget:self action:@selector(clickSelectPic:) forControlEvents:UIControlEventTouchUpInside];
    
    self.mProgressV = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.mProgressV];
    self.mProgressV.delegate = self;
//    self.mProgressV.userInteractionEnabled = NO;
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

//上传图片回调
-(void)UploadImg:(NSNotification *)noti{
    [self.mProgressV hide:YES];
    UploadImgModel *model = noti.object;
    [self.mArr_pic addObject:model];
    self.mTextV_content.text = [NSString stringWithFormat:@"%@%@",self.mTextV_content.text,model.originalName];
}

-(void)SavePublishArticle:(NSNotification *)noti{
    NSString *str = noti.object;
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    self.mProgressV.labelText = str;
//    self.mProgressV.userInteractionEnabled = NO;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
    self.mTextF_title.text = @"";
    self.mTextV_content.text = @"";
}

//点击发送按钮
-(void)clickPosting:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    D("self.textv.content-===%@",self.mTextV_content.text);
    if (self.mTextF_title.text.length==0) {
        self.mProgressV.mode = MBProgressHUDModeCustomView;
        self.mProgressV.labelText = @"请输入标题";
//        self.mProgressV.userInteractionEnabled = NO;
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
        return;
    }else if (self.mTextV_content.text.length == 0){
        self.mProgressV.mode = MBProgressHUDModeCustomView;
        self.mProgressV.labelText = @"请输入内容";
//        self.mProgressV.userInteractionEnabled = NO;
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
        return;
    }
    NSString *content = self.mTextV_content.text;
    for (int i=0; i<self.mArr_pic.count; i++) {
        UploadImgModel *model = [self.mArr_pic objectAtIndex:i];
        NSString *temp = model.originalName;
        content = [content stringByReplacingOccurrencesOfString:temp withString:model.url];
    }
    content = [NSString stringWithFormat:@"<p>%@</p>",content];
    
    if (self.mInt_section == 0) {//分享
        [[ShareHttp getInstance] shareHttpSavePublishArticleWith:self.mTextF_title.text Content:content uType:self.mModel_unit.UnitType UnitID:self.mModel_unit.UnitID SectionFlag:@"1"];
    }else if (self.mInt_section == 1){//展示
        [[ShareHttp getInstance] shareHttpSavePublishArticleWith:self.mTextF_title.text Content:content uType:self.mModel_unit.UnitType UnitID:self.mModel_unit.UnitID SectionFlag:@"2"];
    }
    
    self.mProgressV.labelText = @"加载中...";
    self.mProgressV.mode = MBProgressHUDModeIndeterminate;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
}
-(void)noMore{
    sleep(1);
}

- (void)Loading {
    sleep(TIMEOUT);
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    self.mProgressV.labelText = @"加载超时";
//    self.mProgressV.userInteractionEnabled = NO;
    sleep(2);
}

//点击选择图片按钮
-(void)clickSelectPic:(UIButton *)btn{
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
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2: //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage* image=[info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image=[info objectForKey:UIImagePickerControllerOriginalImage];
    }
    NSString *name = [NSString stringWithFormat:@"[图片%d]",self.mInt_index];
    self.mInt_index ++;
    //发送选中图片上传请求
    [[ShareHttp getInstance] shareHttpUploadSectionImgWith:image Name:name];
    self.mProgressV.labelText = @"加载中...";
    self.mProgressV.mode = MBProgressHUDModeIndeterminate;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    
//    return YES;
//}

//导航条返回按钮回调
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

- (IBAction)pullAction:(id)sender {
    if(self.isOpen == YES)
    {
        self.mTableV_type.frame = CGRectZero;
    }
    else
    {
        self.mTableV_type.frame = CGRectMake(self.pullDownBtn.frame.origin.x, self.pullDownBtn.frame.origin.y+self.pullDownBtn.frame.size.height, self.pullDownBtn.frame.size.width, self.pullDownBtn.frame.size.height*2);
    }
    self.isOpen = !self.isOpen;
}
@end

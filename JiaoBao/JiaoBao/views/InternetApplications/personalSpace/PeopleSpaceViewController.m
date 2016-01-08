//
//  PeopleSpaceViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/6/4.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "PeopleSpaceViewController.h"
#import "UnitTableViewCell.h"
#import "MobileUnitViewController.h"
#import "MobClick.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "KnowledgePeoleSpaceViewController.h"




@interface PeopleSpaceViewController ()
{
    id  _observer1,_observer2;

}
@property(nonatomic,strong)NSArray *unitArr,*unitArr2;//关联单位名称数组、关联单位身份数组
@property(nonatomic,strong)UIButton *addBtn;//指向点击cell上的addBtn，等数据返回时改变addbtn的title
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)UIImagePickerController *picker;


@end

@implementation PeopleSpaceViewController
@synthesize mTableV_personalS,mNav_navgationBar,mArr_personalS;


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:_observer1];
    [[NSNotificationCenter defaultCenter]removeObserver:_observer2];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setValueModel];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    [MobClick beginLogPageView:UMMESSAGE];
    [MobClick beginLogPageView:UMPAGE];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:UMMESSAGE];
    [MobClick endLogPageView:UMPAGE];

}
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
    }
    else
    {
        [MBProgressHUD showSuccess:ResultDesc toView:self.view];

    }
    
//    [[SDImageCache sharedImageCache] clearDisk];
    [self.mTableV_personalS reloadData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changeFaceImg" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeFaceImg:) name:@"changeFaceImg" object:nil];
    __weak PeopleSpaceViewController *weakSelf = self;

    _observer1 = [[NSNotificationCenter defaultCenter]addObserverForName:@"getIdentity" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSMutableArray *mArr = [[NSMutableArray alloc]initWithCapacity:0];
        NSMutableArray *mArr2 = [[NSMutableArray alloc]initWithCapacity:0];
        for(int i=0;i<[dm getInstance].identity.count;i++)
        {
            Identity_model *model= [[dm getInstance].identity objectAtIndex:i];
            if([model.RoleIdName isEqualToString:@"家长"]|[model.RoleIdName isEqualToString:@"学生"])
            {
                for(int i=0;i<model.UserClasses.count;i++)
                {
                    Identity_UserClasses_model *model2 = [model.UserClasses objectAtIndex:i];
                    [mArr addObject:model2.ClassName];
                    [mArr2 addObject:model.RoleIdName];
                    
                }
                
            }
            else
            {
                for(int i=0;i<model.UserUnits.count;i++)
                {
                    Identity_UserUnits_model *model2 = [model.UserUnits objectAtIndex:i];
                    [mArr addObject:model2.UnitName];
                    [mArr2 addObject:model.RoleIdName];
                    
                }
                
            }
            
            
            
            
        }
        
        weakSelf.unitArr = mArr;
        weakSelf.unitArr2 = mArr2;
        [weakSelf.unitTabelView reloadData];
        weakSelf.unitTabelView.frame = CGRectMake(0, weakSelf.mTableV_personalS.frame.size.height+weakSelf.mTableV_personalS.frame.origin.y, [dm getInstance].width, 30*weakSelf.unitArr.count+40);
        weakSelf.tableVIewBtn.frame = weakSelf.unitTabelView.frame;
        
        weakSelf.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, weakSelf.mNav_navgationBar.frame.size.height+weakSelf.mNav_navgationBar.frame.origin.y, [dm getInstance].width, [dm getInstance].height-weakSelf.mNav_navgationBar.frame.size.height)];
        weakSelf.mainScrollView.contentSize = CGSizeMake([dm getInstance].width, weakSelf.mTableV_personalS.frame.size.height+weakSelf.unitTabelView.frame.size.height);

    }];
    
    //获取关联身份数据 并加入到相应的数组中
    NSMutableArray *mArr = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *mArr2 = [[NSMutableArray alloc]initWithCapacity:0];
    for(int i=0;i<[dm getInstance].identity.count;i++)
    {
        Identity_model *model= [[dm getInstance].identity objectAtIndex:i];
        if([model.RoleIdName isEqualToString:@"家长"]|[model.RoleIdName isEqualToString:@"学生"])
        {
            for(int i=0;i<model.UserClasses.count;i++)
            {
                Identity_UserClasses_model *model2 = [model.UserClasses objectAtIndex:i];
                [mArr addObject:model2.ClassName];
                [mArr2 addObject:model.RoleIdName];
                

            }
            
        }
        else
        {
            for(int i=0;i<model.UserUnits.count;i++)
            {
                Identity_UserUnits_model *model2 = [model.UserUnits objectAtIndex:i];
                [mArr addObject:model2.UnitName];
                [mArr2 addObject:model.RoleIdName];

            }
            
        }

    }

    self.unitArr = mArr;
    self.unitArr2 = mArr2;
    
    // Do any additional setup after loading the view from its nib.
    
    self.mArr_personalS = [NSMutableArray array];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"个人中心"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];


    
    //表格
    self.mTableV_personalS.frame = CGRectMake(0, 0, [dm getInstance].width, 70+3*44);
    
    self.unitTabelView.frame = CGRectMake(0, self.mTableV_personalS.frame.size.height+self.mTableV_personalS.frame.origin.y, [dm getInstance].width, 30*self.unitArr.count+40);
    self.tableVIewBtn.frame = self.unitTabelView.frame;
    
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.mNav_navgationBar.frame.size.height+self.mNav_navgationBar.frame.origin.y, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height)];
    self.mainScrollView.contentSize = CGSizeMake([dm getInstance].width, self.mTableV_personalS.frame.size.height+self.unitTabelView.frame.size.height);
    [self.view addSubview:self.mainScrollView];
    //self.mainScrollView.backgroundColor = [UIColor redColor];
    [self.mainScrollView addSubview:self.mTableV_personalS];
    [self.mainScrollView addSubview:self.unitTabelView];
    [self.mainScrollView addSubview:self.tableVIewBtn];
    
    

//    [[RegisterHttp getInstance]registerHttpGetMyMobileUnitList:[dm getInstance].jiaoBaoHao];
//    [[RegisterHttp getInstance]registerHttpJoinUnitOP:[dm getInstance].jiaoBaoHao option:0 tableStr:<#(NSString *)#>]
}

//设置显示值
-(void)setValueModel{
    [self.mArr_personalS removeAllObjects];
    NSString *trueName = [dm getInstance].TrueName;
    NSString *nickName = [dm getInstance].NickName;
//    NSMutableArray *tempArr0 = [NSMutableArray arrayWithObjects:nickName,@"账号信息",@"手机",@"邮箱",@"密码",@"所在单位", nil];
//    NSMutableArray *tempArr1 = [NSMutableArray arrayWithObjects:trueName,[dm getInstance].jiaoBaoHao,@"",@"",@"修改密码",@"加入单位", nil];
    NSMutableArray *tempArr0 = [NSMutableArray arrayWithObjects:nickName,@"教宝号",@"修改密码",@"求知个人中心",@"求知个人中心", nil];
    NSMutableArray *tempArr1 = [NSMutableArray arrayWithObjects:trueName,[dm getInstance].jiaoBaoHao,@"",@"",@"", nil];
    for (int i=0; i<5; i++) {
        PersonalSpaceModel *model = [[PersonalSpaceModel alloc] init];
        model.mStr_nickName = [NSString stringWithFormat:@"%@",[tempArr0 objectAtIndex:i]];
        model.mStr_trueName = [NSString stringWithFormat:@"%@",[tempArr1 objectAtIndex:i]];
        [self.mArr_personalS addObject:model];
    }
    [self.mTableV_personalS reloadData];
}
#pragma -mark 列表代理方法
-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView isEqual:self.unitTabelView])
    {
        return self.unitArr.count;
    }
    return self.mArr_personalS.count-1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:self.unitTabelView])
    {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 35)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 200, 35)];
        label.text = @"  我的单位";
        //label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:label];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 200, 35)];
        //label2.text = @"加入单位";
        label2.textColor = [UIColor lightGrayColor];
        label2.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:label2];
        return headerView;
        
    }
    return 0;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:self.unitTabelView])
    {
        return 30;
    }
    else
    {
        return 0;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    if([tableView isEqual:self.unitTabelView])
    {
        return 30;
        
    }
    else
    {
        if (indexPath.row == 0) {
            return 70;
        }else{
            return 44;
        }
        
    }

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果是关联单位的列表
    if([tableView isEqual:self.unitTabelView])
    {
        static NSString *indentifier = @"unitTabelViewCell";
        UnitTableViewCell *cell = (UnitTableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
        
        if (cell == nil) {
            cell = [[UnitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UnitTableViewCell" owner:self options:nil];
            //这时myCell对象已经通过自定义xib文件生成了
            if ([nib count]>0) {
                cell = (UnitTableViewCell *)[nib objectAtIndex:0];
                //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
            }
            //添加图片点击事件
            //若是需要重用，需要写上以下两句代码
            UINib * n= [UINib nibWithNibName:@"UnitTableViewCell" bundle:[NSBundle mainBundle]];
            [self.mTableV_personalS registerNib:n forCellReuseIdentifier:indentifier];
        }
        //cell.delegate = self;
        cell.tag = indexPath.row;

        cell.unitNameLabel.text = [self.unitArr objectAtIndex:indexPath.row];

        NSString *identTypeLabelStr = [NSString stringWithFormat:@"(%@)",[self.unitArr2 objectAtIndex:indexPath.row] ];
        cell.identTypeLabel.text = identTypeLabelStr;


        cell.addBtn.hidden = YES;

        if(indexPath.row == self.unitArr.count -1)
        {
            cell.bottomLine.hidden = NO;
        }
        else
        {
            cell.bottomLine.hidden = YES;
        }
        return cell;

        
        
    }
    else//如果是个人中心的主列表
    {
    static NSString *CellWithIdentifier = @"PeopleSpaceTableViewCell";
    PeopleSpaceTableViewCell *cell = (PeopleSpaceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PeopleSpaceTableViewCell" owner:self options:nil] lastObject];
    }
    PersonalSpaceModel *model = [self.mArr_personalS objectAtIndex:indexPath.row];
    
    if (indexPath.row ==0) {
        cell.mImgV_head.hidden = NO;
        [[SDImageCache sharedImageCache] removeImageForKey:[NSString stringWithFormat:@"%@%@",AccIDImg,[dm getInstance].jiaoBaoHao]];
        [cell.mImgV_head sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,[dm getInstance].jiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];
        cell.mImgV_head.frame = CGRectMake(10, 10, cell.mImgV_head.frame.size.width, cell.mImgV_head.frame.size.height);
        cell.imgBtn.frame = cell.mImgV_head.frame;
        [cell.imgBtn addTarget:self action:@selector(imgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.mLab_nickName.frame = CGRectMake(cell.mImgV_head.frame.size.width+20, 15, [dm getInstance].width-75-20, cell.mLab_nickName.frame.size.height);
        cell.mLab_trueName.frame = CGRectMake(cell.mImgV_head.frame.size.width+20, 15+cell.mLab_nickName.frame.size.height+5, [dm getInstance].width-75-20, cell.mLab_nickName.frame.size.height);
        cell.mLab_line.frame = CGRectMake(0, 69, [dm getInstance].width, .5);
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }else{
        if (indexPath.row ==2||indexPath.row == 3) {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.mImgV_head.hidden = YES;
        cell.mLab_nickName.frame = CGRectMake(15, 10, cell.mLab_nickName.frame.size.width, cell.mLab_nickName.frame.size.height);
        cell.mLab_trueName.frame = CGRectMake(100, 10, 200, cell.mLab_nickName.frame.size.height);
        cell.mLab_line.frame = CGRectMake(0, 43, [dm getInstance].width, .5);
    }
    cell.mLab_nickName.text = model.mStr_nickName;
    cell.mLab_trueName.text = model.mStr_trueName;
    
    return cell;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        ReviseNameViewController *reviseName = [[ReviseNameViewController alloc] init];
        reviseName.mInt_flag = 1;
        [utils pushViewController:reviseName animated:YES];
    }else if (indexPath.row == 2){
        ReviseNameViewController *reviseName = [[ReviseNameViewController alloc] init];
        reviseName.mInt_flag = 2;
        [utils pushViewController:reviseName animated:YES];
    }
    if(indexPath.row == 3)
    {
        if([tableView isEqual:self.unitTabelView])
        {
            MobileUnitViewController *detail = [[MobileUnitViewController alloc]init];
            [utils pushViewController:detail animated:YES];
            
        }
        else
        {
            KnowledgePeoleSpaceViewController *space = [[KnowledgePeoleSpaceViewController alloc]init];
            [utils pushViewController:space animated:YES];
        }

        
    }
}
-(void)imgBtnAction:(id)sender
{
    UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照",nil];
    action.tag = 1;
    [action showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1) {//单位
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {

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
                case 0: //相册
                {
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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
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
        
        //        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        //            picker.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        //        }
        //        [self presentViewController:picker animated:YES completion:nil];
        [utils pushViewController1:self.picker animated:YES];
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误信息!" message:@"当前设备不支持拍摄功能" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma 拍照模块
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *lastChosenMediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if([lastChosenMediaType isEqual:(NSString *) kUTTypeImage])
    {
        UIImage *chosenImage=[info objectForKey:UIImagePickerControllerOriginalImage];
//        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//        if(orientation == UIInterfaceOrientationLandscapeLeft||orientation == UIInterfaceOrientationLandscapeRight){
        
            chosenImage = [self fixOrientation:chosenImage];

       // }

        NSData *imageData = UIImageJPEGRepresentation(chosenImage,1);
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


-(void)ClickBtnWith:(UIButton *)btn cell:(UnitTableViewCell *)cell
{
//    self.addBtn = btn;
//    unitModel *model = [self.unitArr objectAtIndex:cell.tag];
//    if ([self checkNetWork]) {
//        return;
//    }
//    [[RegisterHttp getInstance]registerHttpJoinUnitOP:model.AccId option:@"1" tableStr:model.TabIdStr];
    
    
}


//导航条返回按钮回调
-(void)myNavigationGoback{
    
    [utils popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)progressViewTishi:(NSString *)title{
    [MBProgressHUD showError:title toView:self.view];
}

-(void)ProgressViewLoad:(NSString *)title{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    [MBProgressHUD showMessage:title toView:self.view];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tbBtnAction:(id)sender {
    MobileUnitViewController *detail = [[MobileUnitViewController alloc]init];
    [utils pushViewController:detail animated:YES];
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

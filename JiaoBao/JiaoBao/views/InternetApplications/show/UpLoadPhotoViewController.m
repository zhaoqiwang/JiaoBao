//
//  UpLoadPhotoViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-12-25.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "UpLoadPhotoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SelectionCell.h"
#import "UITableView+DataSourceBlocks.h"
#import "TableViewWithBlock.h"
//#import "ELCImagePickerDemoViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "Reachability.h"
#import "MobClick.h"
#import "PhotoCollectionCell.h"
#import <AVFoundation/AVFoundation.h>


@interface UpLoadPhotoViewController ()
{
     BOOL isLongpress;
}
@property(nonatomic,strong)UIImagePickerController *picker;


@end

@implementation UpLoadPhotoViewController
@synthesize mStr_flag,mBtn_name,mBtn_upload,mLab_name,mNav_navgationBar,mStr_groupID,mTableV_name,mTextF_name,mArr_albums,delegate;

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:UMMESSAGE];
    [MobClick beginLogPageView:UMPAGE];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:UMMESSAGE];
    [MobClick endLogPageView:UMPAGE];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mArr_photo = [[NSMutableArray alloc]initWithCapacity:0];
    // Do any additional setup after loading the view from its nib.
        [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionCell" bundle:nil]forCellWithReuseIdentifier:@"cell"];
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(deleteCell:) name:@"delete" object:nil];

    //上传照片成功
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpLoadPhotoUnit" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpLoadPhotoUnit:) name:@"UpLoadPhotoUnit" object:nil];
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"上传照片"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.mNav_navgationBar setRightBtnTitle:@"上传"];

    [self.view addSubview:self.mNav_navgationBar];
    
    //
    self.mLab_name.frame = CGRectMake(20, self.mNav_navgationBar.frame.size.height+10, self.mLab_name.frame.size.width, self.mLab_name.frame.size.height);
    self.mTextF_name.frame = CGRectMake(self.mLab_name.frame.origin.x+self.mLab_name.frame.size.width+10, self.mLab_name.frame.origin.y, self.mTextF_name.frame.size.width, self.mTextF_name.frame.size.height);
    self.mBtn_name.frame = self.mTextF_name.frame;
    self.mTableV_name.frame = CGRectMake(self.mTextF_name.frame.origin.x, self.mTextF_name.frame.origin.y+self.mTextF_name.frame.size.height, self.mTextF_name.frame.size.width, 0);
    self.mBtn_upload.frame = CGRectMake([dm getInstance].width/2-self.mBtn_upload.frame.size.width/2, self.mTextF_name.frame.origin.y+self.mTextF_name.frame.size.height+30, self.mBtn_upload.frame.size.width, self.mBtn_upload.frame.size.height);
    
    isOpened=NO;
    self.mTableV_name = [[TableViewWithBlock alloc]initWithFrame:CGRectMake(self.mTextF_name.frame.origin.x, self.mTextF_name.frame.origin.y+30, 179, 0)] ;
    [self.mTableV_name initTableViewDataSourceAndDelegate:^NSInteger(UITableView *tableView,NSInteger section){
        return self.mArr_albums.count;
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        if ([self.mStr_flag intValue] == 1) {
            PersonPhotoModel *model = [self.mArr_albums objectAtIndex:indexPath.row];
            [cell.lb setText:model.GroupName];
        }else{
            UnitAlbumsModel *model = [self.mArr_albums objectAtIndex:indexPath.row];
            [cell.lb setText:model.nameStr];
        }
        
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        if ([self.mStr_flag intValue] == 1) {
            PersonPhotoModel *model = [self.mArr_albums objectAtIndex:indexPath.row];
            [cell.lb setText:model.GroupName];
            self.mStr_groupID = model.ID;
        }else{
            UnitAlbumsModel *model = [self.mArr_albums objectAtIndex:indexPath.row];
            [cell.lb setText:model.nameStr];
            self.mStr_groupID = model.TabID;
        }
        self.mTextF_name.text=cell.lb.text;
        [self.mBtn_name sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [self.mTableV_name.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.mTableV_name.layer setBorderWidth:2];
    [self.view addSubview:self.mTableV_name];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mArr_photo.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCollectionCell *cell = (PhotoCollectionCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                                                 forIndexPath:indexPath];
    cell.imgV.image = [self.mArr_photo objectAtIndex:indexPath.row];
    cell.deleteBtn.tag = indexPath.row;

    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 10, 15, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

// 定义左右cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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

//上传照片成功
-(void)UpLoadPhotoUnit:(NSNotification *)noti{
    //[MBProgressHUD hideHUDForView:self.view];
    mInt_count = mInt_count + 1;
    if (mInt_count == self.mArr_photo.count) {
        [self.delegate UpLoadPhotoSuccess];
        NSString *flag = noti.object;
        if ([flag intValue] == 0) {//成功
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"上传成功" toView:self.view];
            mInt_count=0;
            [self.mArr_photo removeAllObjects];
            [self.collectionView reloadData];
        }else{
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"上传失败" toView:self.view];
            mInt_count =0;
            [self.mArr_photo removeAllObjects];
            [self.collectionView reloadData];
        }

    }
}

- (IBAction)changeOpenStatus:(id)sender{
    if (isOpened) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=self.mTableV_name.frame;
            frame.size.height=0;
            [self.mTableV_name setFrame:frame];
            
        } completion:^(BOOL finished){
            isOpened=NO;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=self.mTextF_name.frame;
            frame.size.height=self.mArr_albums.count*30;
            frame.origin.y = frame.origin.y+ 30;
            
            [self.mTableV_name setFrame:frame];
            D("mTableV_name_frame = %@",NSStringFromCGRect(self.mTableV_name.frame));
        } completion:^(BOOL finished){
            isOpened=YES;
        }];
    }
}

-(IBAction)uploadPhoto:(id)sender{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if (self.mStr_groupID.length == 0) {
        [MBProgressHUD showError:@"请先选择相册" toView:self.view];
        return;
    }
    UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:@"上传照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册选择",@"相机选择",nil];
    action.tag = 1;
    [action showInView:self.view.superview];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0)
    {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if(author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
            [MBProgressHUD showError:@"您暂时没有访问相册的权限" toView:self.view];
            return;
        }
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
        
        elcPicker.maximumImagesCount = 1; //设置的图像的最大数目来选择至10
        elcPicker.returnsOriginalImage = YES; //只返回fullScreenImage，而不是fullResolutionImage
        elcPicker.returnsImage = YES; //返回的UIImage如果YES。如果NO，只返回资产位置信息
        elcPicker.onOrder = YES; //对于多个图像选择，显示和选择图像的退货订单
        //    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //支持图片和电影类型
        elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //支持图片和电影类型
        
        elcPicker.imagePickerDelegate = self;
        
        [self presentViewController:elcPicker animated:YES completion:nil];
    }
    else if(buttonIndex == 1)
    {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
            [MBProgressHUD showError:@"请开启摄像头功能" toView:self.view];
            return;
        }
        [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
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

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (info.count>0) {
        mInt_count = 0;
        mInt_uploadCount = (int)info.count+mInt_uploadCount;
    }
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                NSData *imageData = UIImageJPEGRepresentation(image,0);
                UIImage *img = [UIImage imageWithData:imageData];
                [self.mArr_photo addObject:img];

                
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        }

        else {
            NSLog(@"Uknown asset type");
        }
    }
    [self.collectionView reloadData];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma 拍照模块
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
    }];

    UIImage* image=[info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image=[info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    NSData *imageData = UIImageJPEGRepresentation(image,0);
    UIImage *img = [UIImage imageWithData:imageData];
    [self.mArr_photo addObject:img];
    [self.collectionView reloadData];

    
}

-(void)navigationRightAction:(UIButton *)sender
{
    [MBProgressHUD showMessage:@"正在上传" toView:self.view];

    for(int i=0;i<self.mArr_photo.count;i++)
    {
        NSString *timeSp = [NSString stringWithFormat:@"图片%d.png", i];
        UIImage *image = [self.mArr_photo objectAtIndex:i];
        NSData *imageData = UIImageJPEGRepresentation(image,0);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        
        NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",timeSp]];

        BOOL result = [imageData writeToFile:imgPath atomically:YES];
        for (;;) {
            if (result) {
                if ([self.mStr_flag intValue] == 1) {
                    [[ThemeHttp getInstance] themeHttpUpLoadPhotoFromAPP:[dm getInstance].jiaoBaoHao FileName:timeSp Describe:@"" GroupID:self.mStr_groupID FIle:imgPath];
                }else{
                    UnitAlbumsModel *model = [self.mArr_albums objectAtIndex:0];
                    [[ThemeHttp getInstance] themeHttpUpLoadPhotoUnit:model.UnitID GroupID:self.mStr_groupID Creatby:[dm getInstance].jiaoBaoHao Fiel:imgPath];
                }
                break;
            }
        }

    }


    
}

-(void)deleteCell:(id)sender
{
    UIButton *btn =(UIButton*)[sender object];
    [self.mArr_photo removeObjectAtIndex:btn.tag];
    [self.collectionView reloadData];
    
}

//导航条返回按钮回调
-(void)myNavigationGoback{
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

@end

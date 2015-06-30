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

@interface UpLoadPhotoViewController ()

@end

@implementation UpLoadPhotoViewController
@synthesize mStr_flag,mBtn_name,mBtn_upload,mLab_name,mNav_navgationBar,mStr_groupID,mTableV_name,mTextF_name,mArr_albums,delegate;

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //上传照片成功
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpLoadPhotoUnit" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpLoadPhotoUnit:) name:@"UpLoadPhotoUnit" object:nil];
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"上传照片"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    //
    self.mLab_name.frame = CGRectMake(20, self.mNav_navgationBar.frame.size.height+10, self.mLab_name.frame.size.width, self.mLab_name.frame.size.height);
    self.mTextF_name.frame = CGRectMake(self.mLab_name.frame.origin.x+self.mLab_name.frame.size.width+10, self.mLab_name.frame.origin.y, self.mTextF_name.frame.size.width, self.mTextF_name.frame.size.height);
    self.mBtn_name.frame = self.mTextF_name.frame;
    self.mTableV_name.frame = CGRectMake(self.mTextF_name.frame.origin.x, self.mTextF_name.frame.origin.y+self.mTextF_name.frame.size.height, self.mTextF_name.frame.size.width, 0);
    self.mBtn_upload.frame = CGRectMake(20, self.mTextF_name.frame.origin.y+self.mTextF_name.frame.size.height+30, self.mBtn_upload.frame.size.width, self.mBtn_upload.frame.size.height);
    
    isOpened=NO;
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
    [MBProgressHUD hideHUDForView:self.view];
    mInt_count = mInt_count + 1;
    if (mInt_count == mInt_uploadCount) {
        [self.delegate UpLoadPhotoSuccess];
        NSString *flag = noti.object;
        if ([flag intValue] == 0) {//成功
            [MBProgressHUD showSuccess:@"上传成功" toView:self.view];
        }else{
            [MBProgressHUD showError:@"上传失败" toView:self.view];
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
            CGRect frame=self.mTableV_name.frame;
            frame.size.height=90;
            [self.mTableV_name setFrame:frame];
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
    UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:@"上传照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册选择",nil];
    action.tag = 1;
    [action showInView:self.view.superview];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 100; //设置的图像的最大数目来选择至100
    elcPicker.returnsOriginalImage = YES; //只返回fullScreenImage，而不是fullResolutionImage
    elcPicker.returnsImage = YES; //返回的UIImage如果YES。如果NO，只返回资产位置信息
    elcPicker.onOrder = YES; //对于多个图像选择，显示和选择图像的退货订单
//    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //支持图片和电影类型
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //支持图片和电影类型
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (info.count>0) {
        mInt_count = 0;
        mInt_uploadCount = (int)info.count;
        [MBProgressHUD showMessage:@"上传中..." toView:self.view];
    }
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
//    NSMutableArray *imagesFilePath = [NSMutableArray array];//路径
//    NSMutableArray *imagesName = [NSMutableArray array];//名字
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                NSData *imageData = UIImageJPEGRepresentation(image,1.0);
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                //文件名
                NSFileManager* fileManager=[NSFileManager defaultManager];
                NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",timeSp]];
                BOOL yesNo=[[NSFileManager defaultManager] fileExistsAtPath:imgPath];
                if (!yesNo) {//不存在，则直接写入后通知界面刷新
                    BOOL result = [imageData writeToFile:imgPath atomically:YES];
                    for (;;) {
                        if (result) {
                            if ([self.mStr_flag intValue] == 1) {
                                [[ThemeHttp getInstance] themeHttpUpLoadPhotoFromAPP:[dm getInstance].jiaoBaoHao FileName:[NSString stringWithFormat:@"%@.png",timeSp] Describe:@"" GroupID:self.mStr_groupID FIle:imgPath];
                            }else{
                                UnitAlbumsModel *model = [self.mArr_albums objectAtIndex:0];
                                [[ThemeHttp getInstance] themeHttpUpLoadPhotoUnit:model.UnitID GroupID:self.mStr_groupID Creatby:[dm getInstance].jiaoBaoHao Fiel:imgPath];
                            }
                            break;
                        }
                    }
                }else {//存在
                    BOOL blDele= [fileManager removeItemAtPath:imgPath error:nil];//先删除
                    if (blDele) {//删除成功后，写入，通知界面
                        BOOL result = [imageData writeToFile:imgPath atomically:YES];
                        for (;;) {
                            if (result) {
                                if ([self.mStr_flag intValue] == 1) {
                                    [[ThemeHttp getInstance] themeHttpUpLoadPhotoFromAPP:[dm getInstance].jiaoBaoHao FileName:[NSString stringWithFormat:@"%@.png",timeSp] Describe:@"" GroupID:self.mStr_groupID FIle:imgPath];
                                }else{
                                    UnitAlbumsModel *model = [self.mArr_albums objectAtIndex:0];
                                    [[ThemeHttp getInstance] themeHttpUpLoadPhotoUnit:model.UnitID GroupID:self.mStr_groupID Creatby:[dm getInstance].jiaoBaoHao Fiel:imgPath];
                                }
                                break;
                            }
                        }
                    }
                }
//                [imagesFilePath addObject:imgPath];
                
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        }
//        else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
//            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
//                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
////                [images addObject:image];
//            } else {
//                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
//            }
//        }
        else {
            NSLog(@"Uknown asset type");
        }
        timeSp = [NSString stringWithFormat:@"%d",[timeSp intValue] +1];
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
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

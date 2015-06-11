//
//  AccessoryViewController.m
//  JiaoBao
//
//  Created by Zqw on 15-3-13.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "AccessoryViewController.h"
#import "define_constant.h"

@interface AccessoryViewController ()

@end

@implementation AccessoryViewController
@synthesize mTableV_file,mArr_sumFile,mNav_navgationBar,delegate,mInt_flag,mArr_photo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    self.mArr_sumFile = [NSMutableArray array];
    self.mArr_photo = [NSMutableArray array];
    //添加导航条
    if (self.mInt_flag == 1) {//查看
        self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"附件"];
        [self.mNav_navgationBar setRightBtnTitle:@"删除"];
    }else{//选择附件
        self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"选择文件"];
        [self.mNav_navgationBar setRightBtnTitle:@"确定"];
    }
    
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    
    [self.view addSubview:self.mNav_navgationBar];
    
    //获取到沙盒中的文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSLog(@"paths = %@",paths);
    //文件名
//    NSString *tempPath =[paths objectAtIndex:0] ;
    NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
    NSArray *tempArr = [fileManager contentsOfDirectoryAtPath:tempPath error:nil];
    for (int i=0; i<tempArr.count; i++) {
        AccessoryModel *model = [[AccessoryModel  alloc] init];
        model.mInt_select = 0;
        model.mStr_name = [tempArr objectAtIndex:i];
        [self.mArr_sumFile addObject:model];
    }
    
    self.mTableV_file.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_sumFile.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"AccessoryTableViewCell";
    AccessoryTableViewCell *cell = (AccessoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AccessoryTableViewCell" owner:self options:nil] lastObject];
    }
    cell.delegate = self;
    cell.tag = indexPath.row;
    [cell headImgClick];
    AccessoryModel *model = [self.mArr_sumFile objectAtIndex:indexPath.row];
    cell.mImgV_select.frame = CGRectMake(10, 5, 34, 34);
    if (model.mInt_select == 0) {
        cell.mImgV_select.image = [UIImage imageNamed:@"blank"];
    }else{
        cell.mImgV_select.image = [UIImage imageNamed:@"selected"];
    }
    cell.mLab_name.frame = CGRectMake(47, 0, [dm getInstance].width-50, 44);
    cell.mLab_name.text = model.mStr_name;
    
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray array];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
    
    AccessoryModel *model0 = [self.mArr_sumFile objectAtIndex:indexPath.row];
    NSArray * rslt = [model0.mStr_name componentsSeparatedByString:@"."];//在“.”的位置将文件名分成几块
    NSString * str = [rslt objectAtIndex:[rslt count]-1];//找到最后一块，即为后缀名
    
    if (([str isEqual:@"png"]||[str isEqual:@"gif"]||[str isEqual:@"jpg"]||[str isEqual:@"bmp"])){
        int a = 0;
        [self.mArr_photo removeAllObjects];
        for (int i = 0; i < [self.mArr_sumFile count]; i++) {
            AccessoryModel *model = [self.mArr_sumFile objectAtIndex:i];
            NSArray * rslt = [model.mStr_name componentsSeparatedByString:@"."];//在“.”的位置将文件名分成几块
            NSString * str = [rslt objectAtIndex:[rslt count]-1];//找到最后一块，即为后缀名
            if (([str isEqual:@"png"]||[str isEqual:@"gif"]||[str isEqual:@"jpg"]||[str isEqual:@"bmp"])){
                NSString * getImageStrPath = [NSString stringWithFormat:@"%@/%@",tempPath,model.mStr_name];
                [photos addObject:[MWPhoto photoWithFilePath:getImageStrPath]];
                [self.mArr_photo addObject:model.mStr_name];
                //判断当前点击的这张图片，在图片列表中，是第几张
                if ([model0.mStr_name isEqual:model.mStr_name]) {
                    a = (int)photos.count-1;
                }
            }
        }
        self.photos = photos;
        // Create browser
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = NO;//分享按钮,默认是
        browser.displayNavArrows = NO;//左右分页切换,默认否
        browser.displaySelectionButtons = YES;//是否显示选择按钮在图片上,默认否
        browser.alwaysShowControls = NO;//控制条件控件 是否显示,默认否
        browser.zoomPhotosToFill = NO;//是否全屏,默认是
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        browser.wantsFullScreenLayout = YES;//是否全屏
#endif
        browser.enableGrid = NO;//是否允许用网格查看所有图片,默认是
        browser.startOnGrid = NO;//是否第一张,默认否
        browser.enableSwipeToDismiss = NO;
        [browser setCurrentPhotoIndex:a];
        
        _selections = [NSMutableArray new];
        for (int i = 0; i < photos.count; i++) {
            [_selections addObject:[NSNumber numberWithBool:NO]];
        }
        
        double delayInSeconds = 0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
        });
        
        self.navigationController.title = @"";
        [self.navigationController pushViewController:browser animated:YES];
    }else{
        OpenFileViewController *openFile = [[OpenFileViewController alloc] init];
        openFile.mStr_name = model0.mStr_name;
        [utils pushViewController:openFile animated:YES];
    }
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    D("Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
    NSString *name = [self.mArr_photo objectAtIndex:index];
    for (int i=0; i<self.mArr_sumFile.count; i++) {
        AccessoryModel *model = [self.mArr_sumFile objectAtIndex:i];
        if ([name isEqual:model.mStr_name]) {
            if (selected) {
                model.mInt_select = 1;
            }else{
                model.mInt_select = 0;
            }
            break;
        }
    }
    [self.mTableV_file reloadData];
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return [[_selections objectAtIndex:index] boolValue];
}

//是否选择的回调
-(void)AccessoryTableViewCellTapPress:(AccessoryTableViewCell *)accessoryTableViewCell{
    AccessoryModel *model = [self.mArr_sumFile objectAtIndex:accessoryTableViewCell.tag];
    if (model.mInt_select == 0) {
        model.mInt_select = 1;
    }else{
        model.mInt_select = 0;
    }
    [self.mTableV_file reloadData];
}

//导航条返回按钮
-(void)myNavigationGoback{
    [utils popViewControllerAnimated:YES];
}

-(void)navigationRightAction:(UIButton *)sender{
    if (self.mInt_flag == 1) {//删除附件
        UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:@"确定删除？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定",nil];
        [action showInView:self.view.superview];
    }else{//选择好附件
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i=0; i<self.mArr_sumFile.count; i++) {
            AccessoryModel *model = [self.mArr_sumFile objectAtIndex:i];
            if (model.mInt_select == 1) {
                [tempArr addObject:model.mStr_name];
            }
        }
        
        [self.delegate selectFile:tempArr];
        [utils popViewControllerAnimated:YES];
    }
}

#pragma mark UIActionsheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
        for (int i=(int)self.mArr_sumFile.count-1; i>=0; i--) {
            AccessoryModel *model = [self.mArr_sumFile objectAtIndex:i];
            if (model.mInt_select == 1) {
                NSString *temp = [NSString stringWithFormat:@"%@/%@",tempPath,model.mStr_name];
                D("temp-===%@",temp);
                [self.mArr_sumFile removeObjectAtIndex:i];
                [[NSFileManager defaultManager] removeItemAtPath:temp error:nil];
            }
        }
        [self.mTableV_file reloadData];
    }
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

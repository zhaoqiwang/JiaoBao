//
//  AccessoryViewController.m
//  JiaoBao
//
//  Created by Zqw on 15-3-13.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "AccessoryViewController.h"

@interface AccessoryViewController ()

@end

@implementation AccessoryViewController
@synthesize mTableV_file,mArr_sumFile,mNav_navgationBar,delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mArr_sumFile = [NSMutableArray array];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"选择文件"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.mNav_navgationBar setRightBtnTitle:@"确定"];
    [self.view addSubview:self.mNav_navgationBar];
    
    //获取到沙盒中的文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //文件名
    NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file"]];
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
    AccessoryModel *model = [self.mArr_sumFile objectAtIndex:indexPath.row];
    cell.mImgV_select.frame = CGRectMake(10, 10, 24, 24);
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
    AccessoryModel *model = [self.mArr_sumFile objectAtIndex:indexPath.row];
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

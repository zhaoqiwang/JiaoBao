//
//  PersonalSpaceViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/6/4.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "PersonalSpaceViewController.h"

@interface PersonalSpaceViewController ()

@end

@implementation PersonalSpaceViewController
@synthesize mTableV_personalS,mNav_navgationBar,mProgressV,mArr_personalS;

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
//    //发送注册请求
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"registerGetTime" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerGetTime:) name:@"registerGetTime" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"输入密码"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    //表格
    self.mTableV_personalS.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height);
    
    self.mProgressV = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.mProgressV];
    self.mProgressV.delegate = self;
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_personalS.count;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 70;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *CellWithIdentifier = @"TopArthListCell";
//    TopArthListCell *cell = (TopArthListCell *)[tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
//    
//    if(cell == nil){
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"TopArthListCell" owner:self options:nil] lastObject];
//        cell.frame = CGRectMake(0, 0, [dm getInstance].width, 70);
//    }
//    TopArthListModel *model = [self.mArr_list objectAtIndex:indexPath.row];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    //文件名
//    NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.JiaoBaoHao]];
//    UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
//    cell.mImgV_headImg.frame = CGRectMake(13, 10, 48, 48);
//    if (img.size.width>0) {
//        [cell.mImgV_headImg setImage:img];
//    }else{
//        [cell.mImgV_headImg setImage:[UIImage imageNamed:@"root_img"]];
//        //获取头像
//        [[ExchangeHttp getInstance] getUserInfoFace:model.JiaoBaoHao];
//    }
//    //标题
//    CGSize numSize = [[NSString stringWithFormat:@"%@",model.Title] sizeWithFont:[UIFont systemFontOfSize:14]];
//    cell.mLab_title.frame = CGRectMake(cell.mLab_title.frame.origin.x, cell.mLab_title.frame.origin.y, [dm getInstance].width-cell.mImgV_headImg.frame.size.width-23, numSize.height*2);
//    cell.mLab_title.text = model.Title;
//    if (numSize.width>cell.mLab_title.frame.size.width) {
//        cell.mLab_title.numberOfLines = 2;
//    }
//    //姓名
//    CGSize size = [@"金视野" sizeWithFont:[UIFont systemFontOfSize:10]];
//    cell.mLab_name.text = model.UserName;
//    cell.mLab_name.frame = CGRectMake(cell.mLab_name.frame.origin.x, 70-12-size.height, cell.mLab_name.frame.size.width, size.height);
//    //时间
//    cell.mLab_time.text = model.RecDate;
//    cell.mLab_time.frame = CGRectMake(cell.mLab_time.frame.origin.x, 70-12-size.height, cell.mLab_time.frame.size.width, size.height);
//    //赞个数
//    CGSize likeSize = [[NSString stringWithFormat:@"%@",model.LikeCount] sizeWithFont:[UIFont systemFontOfSize:10]];
//    cell.mLab_likeCount.frame = CGRectMake([dm getInstance].width-10-likeSize.width, 70-12-likeSize.height, likeSize.width, likeSize.height);
//    cell.mLab_likeCount.text = model.LikeCount;
//    //赞图标
//    UIImage *likeImg = [UIImage imageNamed:@"share_like_1"];
//    cell.mImgV_likeCount.frame = CGRectMake(cell.mLab_likeCount.frame.origin.x-likeImg.size.width-5, 70-12-likeImg.size.height, likeImg.size.width, likeImg.size.height);
//    cell.mImgV_likeCount.image = likeImg;
//    //阅读人数
//    CGSize lookSize = [[NSString stringWithFormat:@"%@",model.ViewCount] sizeWithFont:[UIFont systemFontOfSize:10]];
//    cell.mLab_viewCount.frame = CGRectMake(cell.mImgV_likeCount.frame.origin.x-lookSize.width-5, 70-12-lookSize.height, lookSize.width, lookSize.height);
//    cell.mLab_viewCount.text = model.ViewCount;
//    //阅读图标
//    UIImage *lookImg = [UIImage imageNamed:@"share_look"];
//    cell.mImgV_viewCount.frame = CGRectMake(cell.mLab_viewCount.frame.origin.x-lookImg.size.width-5, 70-12-lookImg.size.height, lookImg.size.width, lookImg.size.height);
//    cell.mImgV_viewCount.image = lookImg;
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

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

@end

//
//  GetPickedViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/9/18.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "GetPickedViewController.h"
#import "ChoicenessDetailViewController.h"

@interface GetPickedViewController ()

@end

@implementation GetPickedViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //获取一个精选内容集
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SingleGetPickedById" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetPickedById:) name:@"SingleGetPickedById" object:nil];
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mModel_first.PTitle];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    //
    self.mTalbeV_liset.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    self.mTalbeV_liset.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.mTalbeV_liset addHeaderWithTarget:self action:@selector(headerRereshing)];
//    self.mTalbeV_liset.headerPullToRefreshText = @"下拉刷新";
//    self.mTalbeV_liset.headerReleaseToRefreshText = @"松开后刷新";
//    self.mTalbeV_liset.headerRefreshingText = @"正在刷新...";
//    [self.mTalbeV_liset addFooterWithTarget:self action:@selector(footerRereshing)];
//    self.mTalbeV_liset.footerPullToRefreshText = @"上拉加载更多";
//    self.mTalbeV_liset.footerReleaseToRefreshText = @"松开加载更多数据";
//    self.mTalbeV_liset.footerRefreshingText = @"正在加载...";
    
    //发送请求
    [[KnowledgeHttp getInstance] GetPickedByIdWithTabID:self.mModel_first.TabID flag:@"1"];
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
}

//获取一个精选内容集
-(void)GetPickedById:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *code = [dic objectForKey:@"ResultCode"];
    if ([code integerValue] ==0) {
        self.mModel_getPickdById = [dic objectForKey:@"model"];
    }else{
        NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
        [MBProgressHUD showError:ResultDesc toView:self.view];
    }
    [self.mTalbeV_liset reloadData];
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.mModel_getPickdById.TabID integerValue]>0) {
        return self.mModel_getPickdById.PickContent.count+1;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"KnowledgeTableViewCell";
    KnowledgeTableViewCell *cell = (KnowledgeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[KnowledgeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KnowledgeTableViewCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell = (KnowledgeTableViewCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        //添加图片点击事件
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"KnowledgeTableViewCell" bundle:[NSBundle mainBundle]];
        [self.mTalbeV_liset registerNib:n forCellReuseIdentifier:indentifier];
    }
    //精选
    for (UIView *temp in cell.subviews) {
        temp.hidden = NO;
    }
//    cell.delegate = self;
    cell.backgroundColor = [UIColor whiteColor];
    cell.mImgV_top.hidden = YES;
    if (indexPath.row==0) {
        cell.LikeBtn.hidden = YES;
        cell.mLab_title.hidden = NO;
        CGSize titleSize2 = [[NSString stringWithFormat:@"%@",self.mModel_getPickdById.PTitle] sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_title.frame = CGRectMake(9, 10, titleSize2.width, cell.mLab_title.frame.size.height);
        cell.mLab_title.text = self.mModel_getPickdById.PTitle;
        cell.mLab_Category0.hidden = YES;
        cell.mLab_Category1.hidden = YES;
        cell.mLab_Att.hidden = YES;
        cell.mLab_AttCount.hidden = YES;
        cell.mLab_Answers.hidden = YES;
        cell.mLab_AnswersCount.hidden = YES;
        cell.mLab_View.hidden = YES;
        cell.mLab_ViewCount.hidden = YES;
        cell.mLab_LikeCount.hidden = YES;
        cell.mLab_ATitle.hidden = YES;
        cell.mLab_Abstracts.hidden = YES;
        cell.mInt_flag = 3;
        //            cell.pickContentModel = model;
        cell.mView_background.hidden = YES;
        cell.mLab_IdFlag.hidden = YES;
        cell.mLab_RecDate.hidden = NO;
        cell.mLab_RecDate.frame = CGRectMake(cell.mLab_title.frame.origin.x+cell.mLab_title.frame.size.width+5, 10, cell.mLab_RecDate.frame.size.width, cell.mLab_RecDate.frame.size.height);
        cell.mLab_RecDate.text = self.mModel_getPickdById.RecDate;
        //按钮
        cell.mBtn_detail.hidden = YES;
//        [cell.mBtn_detail setTitle:@"往期精选" forState:UIControlStateNormal];
//        cell.mBtn_detail.frame = CGRectMake([dm getInstance].width-56-10, 0, 56, cell.mBtn_detail.frame.size.height);
        cell.mScrollV_pic.hidden = NO;
        cell.mScrollV_pic.frame = CGRectMake(0, 30, [dm getInstance].width, 100);
        cell.mScrollV_pic.backgroundColor = [UIColor redColor];
        UIImageView *temp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 100)];
        NSString *tempUrl;
        if (self.mModel_getPickdById.ImgContent.count>0) {
            tempUrl = [NSString stringWithFormat:@"%@%@%@",[dm getInstance].url,self.mModel_getPickdById.baseImgUrl,[self.mModel_getPickdById.ImgContent objectAtIndex:0]];
        }
        D("dghrdk;ljg;dklj-====%@",tempUrl);
        [temp sd_setImageWithURL:(NSURL *)tempUrl placeholderImage:[UIImage  imageNamed:@"root_img"]];
        [cell.mScrollV_pic addSubview:temp];
        cell.mLab_comment.hidden = YES;
        cell.mLab_commentCount.hidden = YES;
        cell.mLab_line.hidden = YES;
        cell.mImgV_head.hidden = YES;
        cell.mCollectionV_pic.hidden = YES;
        //图片
        [cell.mCollectionV_pic reloadData];
        cell.mCollectionV_pic.backgroundColor = [UIColor clearColor];
        cell.mLab_line2.hidden = YES;
        cell.mWebV_comment.hidden = YES;
        cell.mBtn_all.hidden = YES;
        cell.mBtn_evidence.hidden = YES;
        cell.mBtn_discuss.hidden = YES;
        cell.mLab_selectCategory.hidden = YES;
        cell.mLab_selectCategory1.hidden = YES;
    }else{
        PickContentModel *model = [self.mModel_getPickdById.PickContent objectAtIndex:indexPath.row-1];
        cell.LikeBtn.hidden = YES;
        cell.mLab_title.hidden = NO;
        cell.mLab_title.frame = CGRectMake(9, 10, [dm getInstance].width-9*2-40, cell.mLab_title.frame.size.height);
        cell.mLab_title.text = model.Title;
        cell.mLab_Category0.hidden = YES;
        cell.mLab_Category1.hidden = YES;
        cell.mLab_Att.hidden = YES;
        cell.mLab_AttCount.hidden = YES;
        cell.mLab_Answers.hidden = YES;
        cell.mLab_AnswersCount.hidden = YES;
        cell.mLab_View.hidden = YES;
        cell.mLab_ViewCount.hidden = YES;
        cell.mLab_LikeCount.hidden = YES;
        cell.mLab_ATitle.hidden = YES;
        cell.mLab_Abstracts.hidden = NO;
        cell.mInt_flag = 3;
        cell.pickContentModel = model;
        cell.tag = indexPath.row;
        NSString *string2 = model.Abstracts;
        string2 = [string2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        string2 = [string2 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        NSString *name2 = [NSString stringWithFormat:@"<font size=14 color=black>%@</font>",string2];
        
        NSMutableDictionary *row2 = [NSMutableDictionary dictionary];
        [row2 setObject:name2 forKey:@"text"];
        RTLabelComponentsStructure *componentsDS2 = [RCLabel extractTextStyle:[row2 objectForKey:@"text"]];
        cell.mLab_Abstracts.componentsAndPlainText = componentsDS2;
        CGSize optimalSize2 = [cell.mLab_Abstracts optimumSize];
        D("dfgjldkjflk-===%@,%f",model.Abstracts,optimalSize2.height);
        if (optimalSize2.height==23) {
            optimalSize2 = CGSizeMake(optimalSize2.width, 25);
        }else if (optimalSize2.height==14) {
            optimalSize2 = CGSizeMake(optimalSize2.width, 20);
        }else if (optimalSize2.height>20) {
            optimalSize2 = CGSizeMake(optimalSize2.width, 35);
        }
        cell.mLab_Abstracts.frame = CGRectMake(5, cell.mLab_title.frame.origin.y+cell.mLab_title.frame.size.height+7, [dm getInstance].width-10, optimalSize2.height);
        cell.mView_background.hidden = NO;
        cell.mView_background.frame = CGRectMake(cell.mLab_Abstracts.frame.origin.x-2, cell.mLab_Abstracts.frame.origin.y-5, [dm getInstance].width-6, cell.mLab_Abstracts.frame.size.height+4);
        cell.mLab_IdFlag.hidden = YES;
        cell.mLab_RecDate.hidden = YES;
        cell.mLab_comment.hidden = YES;
        cell.mLab_commentCount.hidden = YES;
        cell.mLab_line.hidden = NO;
        cell.mImgV_head.hidden = YES;
        cell.mCollectionV_pic.hidden = NO;
        //图片
        [cell.mCollectionV_pic reloadData];
        cell.mCollectionV_pic.backgroundColor = [UIColor clearColor];
        if (model.Thumbnail.count>0) {
            cell.mCollectionV_pic.frame = CGRectMake(5, cell.mView_background.frame.origin.y+cell.mView_background.frame.size.height+5, [dm getInstance].width-65, ([dm getInstance].width-65-30)/3);
        }else{
            cell.mCollectionV_pic.frame = cell.mView_background.frame;
        }
        //分割线
        cell.mLab_line.frame = CGRectMake(0, cell.mCollectionV_pic.frame.origin.y+cell.mCollectionV_pic.frame.size.height+5, [dm getInstance].width, .5);
        cell.mLab_line2.hidden = YES;
        cell.mBtn_detail.hidden = YES;
        cell.mWebV_comment.hidden = YES;
        cell.mBtn_all.hidden = YES;
        cell.mBtn_evidence.hidden = YES;
        cell.mBtn_discuss.hidden = YES;
        cell.mLab_selectCategory.hidden = YES;
        cell.mLab_selectCategory1.hidden = YES;
        cell.mScrollV_pic.hidden = YES;
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.row==0) {
        return 130;
    }else{
        return [self cellHeightPicked:indexPath];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row>0) {
        PickContentModel *model = [self.mModel_getPickdById.PickContent objectAtIndex:indexPath.row-1];
        ChoicenessDetailViewController *detail = [[ChoicenessDetailViewController alloc]init];
        detail.pickContentModel = model;
        [utils pushViewController:detail animated:YES];
    }
}

-(float)cellHeightPicked:(NSIndexPath *)indexPath{
    float tempF = 0.0;
    PickContentModel *model = [self.mModel_getPickdById.PickContent objectAtIndex:indexPath.row-1];
    tempF = tempF+10+16;
    NSString *string2 = model.Abstracts;
    string2 = [string2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string2 = [string2 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    NSString *name2 = [NSString stringWithFormat:@"<font size=14 color=black>%@</font>",string2];
    
    CGSize size = [name2 sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-10, 1000)];
    if (size.height>20) {
        size = CGSizeMake(size.width, 32);
    }
    
    if (size.height==23) {
        size = CGSizeMake(size.width, 25);
    }else if (size.height>20) {
        size = CGSizeMake(size.width, 35);
    }
    tempF = tempF+size.height;
    //图片
    if (model.Thumbnail.count>0) {
        tempF = tempF+5+([dm getInstance].width-65-30)/3;
    }
    tempF = tempF +13;
    return tempF;
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

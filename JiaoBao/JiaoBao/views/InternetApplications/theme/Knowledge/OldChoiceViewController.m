//
//  OldChoiceViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/9/9.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "OldChoiceViewController.h"

@interface OldChoiceViewController ()

@end

@implementation OldChoiceViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //获取往期精选
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PickedIndex" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PickedIndex:) name:@"PickedIndex" object:nil];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"往期精选"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    self.mTableV_list.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    //发送获取往期精选
    [[KnowledgeHttp getInstance] PickedIndexWithNumPerPage:@"20" pageNum:@"1" RowCount:@"0"];
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
}

//获取往期精选
-(void)PickedIndex:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *code = [dic objectForKey:@"ResultCode"];
    if ([code integerValue] ==0) {
        self.mArr_list = [dic objectForKey:@"array"];
        [self.mTableV_list reloadData];
    }
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_list.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"OldChoiceTableViewCell";
    OldChoiceTableViewCell *cell = (OldChoiceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[OldChoiceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OldChoiceTableViewCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell = (OldChoiceTableViewCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        //添加图片点击事件
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"OldChoiceTableViewCell" bundle:[NSBundle mainBundle]];
        [self.mTableV_list registerNib:n forCellReuseIdentifier:indentifier];
    }
    PickedIndexModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    cell.mLab_background.frame = CGRectMake(0, 0, [dm getInstance].width, cell.mLab_background.frame.size.height);
    //标题
    CGSize titleSize = [model.PTitle sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake([dm getInstance].width-27-86, 99999)];
    if (titleSize.height>18) {
        titleSize.height = 30;
    }
    cell.mLab_title.frame = CGRectMake(9, 30, [dm getInstance].width-27-86, titleSize.height);
    cell.mLab_title.text = model.PTitle;
    //日期
    cell.mLab_time.frame = CGRectMake(9, 100-20-cell.mLab_time.frame.size.height, cell.mLab_time.frame.size.width, cell.mLab_time.frame.size.height);
    cell.mLab_time.text = model.RecDate;
    //图片
    NSString *tempUrl;
    if (model.ImgContent.count>0) {
        tempUrl = [NSString stringWithFormat:@"%@%@%@",[dm getInstance].url,model.baseImgUrl,[model.ImgContent objectAtIndex:0]];
    }
    D("ldghjalksgjaskl-===%@",tempUrl);
    [cell.mImgV_img sd_setImageWithURL:(NSURL *)tempUrl placeholderImage:[UIImage  imageNamed:@"root_img"]];
    cell.mImgV_img.frame = CGRectMake([dm getInstance].width-86-9, 20, 86, 70);
    
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

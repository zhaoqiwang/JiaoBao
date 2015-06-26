//
//  NoticeView.m
//  JiaoBao
//
//  Created by Zqw on 14-11-28.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "NoticeView.h"

static NSString *NoticeCell = @"ShareCollectionViewCell";

@implementation NoticeView
@synthesize mLab_name,mBtn_posting,mCollectionV_unit,mScrollV_share,mTableV_detail,mArr_unit,mInt_flag,mBtn_add,mInt_index,mModel_notice,mArr_class,mArr_display,mArr_tabel;


- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self) {
        // Initialization code
        //通知shareview界面，将得到的值，传到界面
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getUnitInfoShow" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUnitInfoShow:) name:@"getUnitInfoShow" object:nil];
        //切换账号时，更新数据
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RegisterView" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RegisterView:) name:@"RegisterView" object:nil];
        //通知shareview界面，将得到的值，传到界面,最新更新，推荐
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TopArthListIndexImg" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TopArthListIndexImg:) name:@"TopArthListIndexImg" object:nil];
        //向转发界面传递得到的人员单位列表，在获取通知前，切换单位用到
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CMRevicer" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CMRevicer) name:@"CMRevicer" object:nil];
        //通知到内务获取到的单位通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetUnitNotices" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetUnitNotices:) name:@"GetUnitNotices" object:nil];
        //获取到关联单位和所有单位
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getUnitClassNotice" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUnitClassNotice:) name:@"getUnitClassNotice" object:nil];
        
        self.frame = frame;
        
        self.mArr_unit = [NSMutableArray array];
        self.mArr_tabel = [NSMutableArray array];
        self.mArr_class = [NSMutableArray array];
        self.mArr_display = [NSMutableArray array];
        self.mModel_notice = [[UnitNoticeModel alloc] init];
        self.mInt_index = 1;
        
        //scrollview
        self.mScrollV_share = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, self.frame.size.height)];
        [self addSubview:self.mScrollV_share];
        
        //collectionview,单位列表
        UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
        self.mCollectionV_unit = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 200) collectionViewLayout:flowLayout];
        
        self.mCollectionV_unit.delegate = self;
        self.mCollectionV_unit.dataSource = self;
        self.mCollectionV_unit.backgroundColor = [UIColor whiteColor];
        [self.mCollectionV_unit registerClass:[ShareCollectionViewCell class] forCellWithReuseIdentifier:NoticeCell];
        //设置本身大小和内容大小
        self.mCollectionV_unit.frame = CGRectMake(self.mCollectionV_unit.frame.origin.x, self.mCollectionV_unit.frame.origin.y, self.mCollectionV_unit.frame.size.width, self.mCollectionV_unit.collectionViewLayout.collectionViewContentSize.height);
        [self.mScrollV_share addSubview:self.mCollectionV_unit];
        
        //表格的标签
        self.mLab_name = [[UILabel alloc] initWithFrame:CGRectMake(0, self.mCollectionV_unit.frame.size.height, [dm getInstance].width, 20)];
        self.mLab_name.backgroundColor = [UIColor grayColor];
        self.mLab_name.text = @"  最新更新";
        self.mLab_name.font = [UIFont systemFontOfSize:12];
        [self.mScrollV_share addSubview:self.mLab_name];
        
        //表格,更改里面的自定义cell
        self.mTableV_detail = [[UITableView alloc] initWithFrame:CGRectMake(0, self.mLab_name.frame.origin.y+self.mLab_name.frame.size.height, [dm getInstance].width, 0)];
        self.mTableV_detail.delegate = self;
        self.mTableV_detail.dataSource = self;
        self.mTableV_detail.scrollEnabled = NO;
        [self.mScrollV_share addSubview:self.mTableV_detail];
        
        //加载更多按钮
        self.mBtn_add = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mBtn_add.frame = CGRectMake(0, self.mTableV_detail.frame.origin.y+self.mTableV_detail.frame.size.height, [dm getInstance].width, 40);
        self.mBtn_add.hidden = NO;
        [self.mBtn_add setTitle:@"查看更多" forState:UIControlStateNormal];
        self.mBtn_add.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.mBtn_add addTarget:self action:@selector(clickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.mBtn_add setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.mScrollV_share addSubview:self.mBtn_add];
        
        //发表文章按钮，根据情况，是否隐藏
        self.mBtn_posting = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img_btn = [UIImage imageNamed:@"root_addBtn"];
        [self.mBtn_posting setBackgroundImage:img_btn forState:UIControlStateNormal];
        self.mBtn_posting.frame = CGRectMake(([dm getInstance].width-img_btn.size.width)/2, self.frame.size.height-51+(51-img_btn.size.height)/2, img_btn.size.width, img_btn.size.height);
        self.mBtn_posting.hidden = YES;
        [self.mBtn_posting setTitle:@"发表文章" forState:UIControlStateNormal];
        [self.mBtn_posting setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.mBtn_posting addTarget:self action:@selector(clickPosting:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mBtn_posting];
    }
    return self;
}

//发表文章按钮
-(void)clickPosting:(UIButton *)btn{
    UnitSectionMessageModel *model = [self.mArr_unit objectAtIndex:self.mInt_flag];
    SharePostingViewController *posting = [[SharePostingViewController alloc] init];
    posting.mModel_unit = model;
    [utils pushViewController:posting animated:YES];
}

//点击查看更多按钮
-(void)clickAddBtn:(UIButton *)btn{
    D("点击查看更多按钮");
    if (self.mModel_notice.noticeInfoArray.count>=20) {
        self.mInt_index = (int)self.mModel_notice.noticeInfoArray.count/20+1;
        D("self.mint.page-====%lu %d",(unsigned long)self.mModel_notice.noticeInfoArray.count,self.mInt_index);
        UnitSectionMessageModel *model = [self.mArr_unit objectAtIndex:self.mInt_flag];
        [[ShareHttp getInstance] NoticeHttpGetUnitNoticesWith:model.UnitType UnitID:model.UnitID pageNum:[NSString stringWithFormat:@"%d",self.mInt_index]];
        [MBProgressHUD showMessage:@"" toView:self];
    } else {
        [MBProgressHUD showError:@"没有更多了" toView:self];
    }
}

//加载获取到得单位
-(void)getUnitInfoShow:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        NSMutableArray *array = [dic objectForKey:@"array"];
        for (int i=0; i<array.count; i++) {
            UnitSectionMessageModel *model = [array objectAtIndex:i];
            //        if ([model.IsMyUnit isEqual:@"1"]&&[model.UnitType isEqual:@"1"]) {
            if ([model.IsMyUnit isEqual:@"1"]) {
                [self.mArr_unit addObject:model];
                if ([dm getInstance].UID == [model.UnitID intValue]) {
                    self.mInt_flag = (int)self.mArr_unit.count-1;
                    //发送获取当前单位通知请求
                    UnitSectionMessageModel *model = [self.mArr_unit objectAtIndex:self.mInt_flag];
                    D("NoticeHttpGetUnitNoticesWith-===%@,%@,%d",model.UnitType,model.UnitID,self.mInt_index);
                    //发送获取切换单位和个人信息请求
                    [[LoginSendHttp getInstance] changeCurUnit];
                    [[LoginSendHttp getInstance] getUserInfoWith:[NSString stringWithFormat:@"%d",[dm getInstance].uType] UID:[NSString stringWithFormat:@"%d",[dm getInstance].UID]];
                    //设置标签名
                    self.mLab_name.text = [NSString stringWithFormat:@"  %@",model.UnitName];
                }
            }
        }
        //重置界面
        [self.mCollectionV_unit reloadData];
        [self reSetFrame];
    }else{
        [MBProgressHUD showError:@"超时" toView:self];
    }
}

//获取到个人信息的通知，然后请求单位信息
-(void)getIdentity:(NSNotification *)noti{
    //获取数量
    [[ShareHttp getInstance] shareHttpGetUnitSectionMessagesWith:@"2" AcdID:[NSString stringWithFormat:@"%d",[dm getInstance].uType]];
    //获取最新、推荐未读数量
    [[ShareHttp getInstance] shareHttpGetSectionMessageWith:@"_1" TopFlags:@"1" AccID:[NSString stringWithFormat:@"%d",[dm getInstance].uType]];
    [[ShareHttp getInstance] shareHttpGetSectionMessageWith:@"_1" TopFlags:@"2" AccID:[NSString stringWithFormat:@"%d",[dm getInstance].uType]];
    //请求最新更新数据
    [[ShareHttp getInstance] shareHttpGetTopArthListIndexWith:@"2" TopFlag:@"1" Page:[NSString stringWithFormat:@"%d",self.mInt_index]];
    [MBProgressHUD showMessage:@"" toView:self];
}

//获取到关联单位和所有单位
-(void)getUnitClassNotice:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        int index = [[dic objectForKey:@"index"] intValue];
        NSArray *array = [dic objectForKey:@"array"];
        NSMutableArray *tempArr = [NSMutableArray array];
        
        if (index == 1) {//关联的班级
            for (int i=0; i<array.count; i++) {
                UserClassModel *model = [array objectAtIndex:i];
                //第1根节点
                TreeView_node *node = [[TreeView_node alloc]init];
                node.nodeLevel = 1;
                node.type = 1;
                node.sonNodes = nil;
                node.isExpanded = FALSE;
                TreeView_Level0_Model *temp =[[TreeView_Level0_Model alloc]init];
                temp.mStr_name = model.ClassName;
                temp.mStr_classID = model.ClassID;
                temp.mStr_headImg = @"share_tableV_class";
                node.nodeData = temp;
                [tempArr addObject:node];
            }
            TreeView_node *node0 = [self.mArr_class objectAtIndex:1];
            node0.sonNodes = [NSMutableArray arrayWithArray:tempArr];
        }
        [self reloadDataForDisplayArray];
    }else{
        [MBProgressHUD showError:@"超时" toView:self];
    }
}
/*---------------------------------------
 初始化将要显示的cell的数据
 --------------------------------------- */
-(void) reloadDataForDisplayArray{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    for (TreeView_node *node in self.mArr_class) {
        [tmp addObject:node];
        if(node.isExpanded){
            for(TreeView_node *node2 in node.sonNodes){
                [tmp addObject:node2];
                if(node2.isExpanded){
                    for(TreeView_node *node3 in node2.sonNodes){
                        [tmp addObject:node3];
                    }
                }
            }
        }
    }
    self.mArr_display = [NSMutableArray arrayWithArray:tmp];
    //重置界面
    [self reSetFrame];
}

//当单位的utype类型是班级时，设置数据
-(void)unitTypeClass{
    //第0根节点
    TreeView_node *node0 = [[TreeView_node alloc]init];
    node0.nodeLevel = 0;
    node0.type = 0;
    node0.sonNodes = nil;
    node0.isExpanded = FALSE;
    node0.readflag = 0;
    TreeView_Level0_Model *temp0 =[[TreeView_Level0_Model alloc]init];
    temp0.mStr_name = @"本单位通知";
    temp0.mStr_headImg = @"share_tableV_school";
    temp0.mStr_img_detail = @"root_detail";
    temp0.mStr_img_open_close = @"root_close";
    temp0.mInt_number = 0;
    temp0.mInt_show = 0;
    node0.nodeData = temp0;
    
    TreeView_node *node1 = [[TreeView_node alloc]init];
    node1.nodeLevel = 0;
    node1.type = 0;
    node1.sonNodes = nil;
    node1.isExpanded = FALSE;
    node1.readflag = 1;
    TreeView_Level0_Model *temp1 =[[TreeView_Level0_Model alloc]init];
    temp1.mStr_name = @"我关联的班级";
    temp1.mStr_headImg = @"share_tableV_school";
    temp1.mStr_img_detail = @"root_detail";
    temp1.mStr_img_open_close = @"root_close";
    temp1.mInt_number = 0;
    temp1.mInt_show = 1;
    node1.nodeData = temp1;
    
    self.mArr_class = [NSMutableArray arrayWithObjects:node0,node1, nil];
    //重置界面
    [self reSetFrame];
}

//切换成下级单位数组
-(void)unitNext{
    for (int i=0; i<self.mArr_unit.count; i++) {
        UnitSectionMessageModel *model = [self.mArr_unit objectAtIndex:i];
        D("model.name-=-==%@,%@,%@",model.UnitName,model.UnitType,model.IsMyUnit);
        if ([model.UnitType intValue] == 1&&[model.IsMyUnit intValue] == 1) {
            [self.mArr_class addObject:model];
        }
    }
    //重置界面
    [self reSetFrame];
}

//切换账号时，更新数据
-(void)RegisterView:(NSNotification *)noti{
    [self.mArr_unit removeAllObjects];
    self.mInt_flag = 0;
    
    [self.mModel_notice.noticeInfoArray removeAllObjects];
}

//最新更新、推荐的通知
-(void)TopArthListIndexShow:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    NSMutableArray *array = noti.object;
    if (self.mInt_index > 1) {
        if (array.count>0) {
            [self.mArr_tabel addObjectsFromArray:array];
        }
    }else{
        self.mArr_tabel = [NSMutableArray arrayWithArray:array];
    }
    //刷新，布局
    [self clickUnitResetFrame];
}
//获取到头像后，更新界面
-(void)TopArthListIndexImg:(NSNotification *)noti{
    //刷新，布局
    [MBProgressHUD hideHUDForView:self];
    [self.mTableV_detail reloadData];
}

//当收到单位回调后，重置界面
-(void)reSetFrame{
    //单位
    self.mCollectionV_unit.frame = CGRectMake(self.mCollectionV_unit.frame.origin.x, self.mCollectionV_unit.frame.origin.y, self.mCollectionV_unit.frame.size.width, self.mCollectionV_unit.collectionViewLayout.collectionViewContentSize.height);
    //标签
    self.mLab_name.frame = CGRectMake(0, self.mCollectionV_unit.frame.size.height, [dm getInstance].width, 20);
    //表格,按钮，总大小
    [self clickUnitResetFrame];
}

//当收到点击单位的回调后，重置界面
-(void)clickUnitResetFrame{
    //表格
    [self.mTableV_detail reloadData];
    //判断当前用的是哪个数组
    UnitSectionMessageModel *userInfoModel = [self.mArr_unit objectAtIndex:self.mInt_flag];
    if ([userInfoModel.UnitType intValue] ==1||[userInfoModel.UnitType intValue] ==0){//当为教育局或最新更新、推荐
        self.mBtn_add.hidden = NO;
        self.mTableV_detail.frame = CGRectMake(0, self.mLab_name.frame.origin.y+self.mLab_name.frame.size.height, [dm getInstance].width, self.mModel_notice.noticeInfoArray.count*70);
        self.mBtn_add.frame = CGRectMake(0, self.mTableV_detail.frame.origin.y+self.mTableV_detail.frame.size.height, [dm getInstance].width, 40);
    }else if ([userInfoModel.UnitType intValue] ==2){//当为关联班级
        self.mBtn_add.hidden = YES;
        self.mTableV_detail.frame = CGRectMake(0, self.mLab_name.frame.origin.y+self.mLab_name.frame.size.height, [dm getInstance].width, self.mArr_display.count*48);
    }
    
    D("self.mTableV_detail.frame-===%@",NSStringFromCGRect(self.mTableV_detail.frame));
    //发表文章
    if ([userInfoModel.UnitType isEqual:@"1"]) {
        self.mBtn_posting.hidden = NO;
        //总内容frame
        self.mScrollV_share.frame = CGRectMake(0, 0, [dm getInstance].width, self.frame.size.height-51);
    }else{
        self.mBtn_posting.hidden = YES;
        //总内容frame
        self.mScrollV_share.frame = CGRectMake(0, 0, [dm getInstance].width, self.frame.size.height);
    }
    //设置scrollview内容大小
    if ([userInfoModel.UnitType intValue] ==1||[userInfoModel.UnitType intValue] ==0){//当为教育局或最新更新、推荐
        self.mScrollV_share.contentSize = CGSizeMake([dm getInstance].width, self.mBtn_add.frame.origin.y+self.mBtn_add.frame.size.height);
    }else if ([userInfoModel.UnitType intValue] ==2||[userInfoModel.UnitType intValue] ==4){//当为班级
        self.mScrollV_share.contentSize = CGSizeMake([dm getInstance].width, self.mTableV_detail.frame.origin.y+self.mTableV_detail.frame.size.height);
    }
    
    D("self.mTableV_detail.frame-===%@",NSStringFromCGRect(self.mTableV_detail.frame));
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.mArr_unit.count==0) {
        return 0;
    }
    UnitSectionMessageModel *userInfoModel = [self.mArr_unit objectAtIndex:self.mInt_flag];
    if ([userInfoModel.UnitType intValue] ==1||[userInfoModel.UnitType intValue] ==0){//当为教育局
        return self.mModel_notice.noticeInfoArray.count;
    }else if ([userInfoModel.UnitType intValue] ==2){//当为关联班级
        if (self.mArr_display.count==0) {
            return 0;
        }
        return self.mArr_display.count;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"TreeView_Level0_Cell";
    UnitSectionMessageModel *userInfoModel = [self.mArr_unit objectAtIndex:self.mInt_flag];
    if ([userInfoModel.UnitType intValue] ==1||[userInfoModel.UnitType intValue] ==0){//当为教育局或最新更新、推荐
        static NSString *CellWithIdentifier = @"TopArthListCell";
        TopArthListCell *cell = (TopArthListCell *)[tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TopArthListCell" owner:self options:nil] lastObject];
            cell.frame = CGRectMake(0, 0, [dm getInstance].width, 70);
        }
        NoticeInfoModel *model = [self.mModel_notice.noticeInfoArray objectAtIndex:indexPath.row];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.JiaoBaoHao]];
        UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
        cell.mImgV_headImg.frame = CGRectMake(13, 10, 48, 48);
        if (img.size.width>0) {
            [cell.mImgV_headImg setImage:img];
        }else{
            [cell.mImgV_headImg setImage:[UIImage imageNamed:@"root_img"]];
        }
        //标题
        CGSize numSize = [[NSString stringWithFormat:@"%@",model.Subject] sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_title.frame = CGRectMake(cell.mLab_title.frame.origin.x, cell.mLab_title.frame.origin.y, [dm getInstance].width-cell.mImgV_headImg.frame.size.width-23, numSize.height*2);
        cell.mLab_title.text = model.Subject;
        if (numSize.width>cell.mLab_title.frame.size.width) {
            cell.mLab_title.numberOfLines = 2;
        }
        //姓名
        CGSize size = [model.UserName sizeWithFont:[UIFont systemFontOfSize:10]];
        cell.mLab_name.text = model.UserName;
        cell.mLab_name.frame = CGRectMake(cell.mLab_name.frame.origin.x, 70-12-size.height, cell.mLab_name.frame.size.width, size.height);
        //时间
        CGSize timeSize = [[NSString stringWithFormat:@"%@",model.Recdate] sizeWithFont:[UIFont systemFontOfSize:10]];
        cell.mLab_time.text = model.Recdate;
        cell.mLab_time.frame = CGRectMake([dm getInstance].width-10-timeSize.width, 70-12-size.height, timeSize.width, size.height);
        
        cell.mLab_likeCount.hidden = YES;
        cell.mLab_viewCount.hidden = YES;
        cell.mImgV_likeCount.hidden = YES;
        cell.mImgV_viewCount.hidden = YES;
        return cell;
    }else if ([userInfoModel.UnitType intValue] ==2){//当为关联班级
        TreeView_Level0_Cell *cell = (TreeView_Level0_Cell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TreeView_Level0_Cell" owner:self options:nil] lastObject];
            cell.frame = CGRectMake(0, 0, [dm getInstance].width, 48);
        }
        TreeView_node *node = [mArr_display objectAtIndex:indexPath.row];
        if(node.type == 0){//类型为0的cell
            //            cell.delegate = self;
            cell.mNode = node;
            if (node.readflag == 0||node.readflag == 1) {
                cell.mBtn_detail.userInteractionEnabled = NO;
            } else {
                cell.mBtn_detail.userInteractionEnabled = YES;
            }
            [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
            [cell setNeedsDisplay]; //重新描绘cell
        }
        else if(node.type == 1){//类型为1的cell
            cell.mNode = node;
            [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
            [cell setNeedsDisplay]; //重新描绘cell
        }
        return cell;
    }
    
    return nil;
}
/*---------------------------------------
 为不同类型cell填充数据
 --------------------------------------- */
-(void) loadDataForTreeViewCell:(UITableViewCell*)cell with:(TreeView_node*)node{
    TreeView_Level0_Cell *cell0 = (TreeView_Level0_Cell*)cell;
    TreeView_Level0_Model *nodeData = node.nodeData;
    cell0.mLab_name.text = nodeData.mStr_name;
    //本地图片
    [cell0.mImgV_head setImage:[UIImage imageNamed:nodeData.mStr_headImg]];
    cell0.mImgV_head.hidden = NO;
    cell0.mImgV_head.frame = CGRectMake(32, 12, 24, 24);
    
    [cell0.mBtn_detail setImage:[UIImage imageNamed:nodeData.mStr_img_detail] forState:UIControlStateNormal];
    cell0.mBtn_detail.frame = CGRectMake([dm getInstance].width-44-10, 0, 44, 48);
    cell0.mBtn_detail.tag = node.readflag;
    if (node.isExpanded) {
        [cell0.mImgV_open_close setImage:[UIImage imageNamed:@"root_open"]];
    } else {
        [cell0.mImgV_open_close setImage:[UIImage imageNamed:nodeData.mStr_img_open_close]];
    }
    //定位
    CGSize nameSize = [nodeData.mStr_name sizeWithFont:[UIFont systemFontOfSize:15]];
    cell0.mLab_name.frame = CGRectMake(cell0.mLab_name.frame.origin.x, cell0.mLab_name.frame.origin.y, nameSize.width, cell0.mLab_name.frame.size.height);
    if (nodeData.mInt_number>0) {
        cell0.mImgV_number.hidden = NO;
        cell0.mLab_number.hidden = NO;
        UIImage *img = [UIImage imageNamed:@"root_dian"];
        CGSize numSize = [[NSString stringWithFormat:@"%d",nodeData.mInt_number] sizeWithFont:[UIFont systemFontOfSize:16]];
        cell0.mImgV_number.frame = CGRectMake(cell0.mLab_name.frame.origin.x+cell0.mLab_name.frame.size.width, (48-img.size.height)/2+2, numSize.width+5, img.size.height);
        [cell0.mImgV_number setImage:img];
        cell0.mLab_number.frame = cell0.mImgV_number.frame;
        cell0.mLab_number.text = [NSString stringWithFormat:@"%d",nodeData.mInt_number];
    }else{
        cell0.mImgV_number.hidden = YES;
        cell0.mLab_number.hidden = YES;
    }
    //是否显示详情按钮
    if (nodeData.mInt_show == 1) {
        cell0.mBtn_detail.hidden = NO;
        cell0.mImgV_open_close.hidden = NO;
    }else{
        cell0.mBtn_detail.hidden = YES;
        cell0.mImgV_open_close.hidden = YES;
    }
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    UnitSectionMessageModel *userInfoModel = [self.mArr_unit objectAtIndex:self.mInt_flag];
    if ([userInfoModel.UnitType intValue] ==1||[userInfoModel.UnitType intValue] ==0){//当为教育局或最新更新、推荐
        return 70;
    }else if ([userInfoModel.UnitType intValue] ==2||[userInfoModel.UnitType intValue] ==4){//当为班级
        return 48;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UnitSectionMessageModel *userInfoModel = [self.mArr_unit objectAtIndex:self.mInt_flag];
    if ([userInfoModel.UnitType intValue] ==1||[userInfoModel.UnitType intValue] ==0){//当为教育局或最新更新、推荐，进入文章详情
        NoticeInfoModel *model = [self.mModel_notice.noticeInfoArray objectAtIndex:indexPath.row];
        ArthDetailViewController *arth = [[ArthDetailViewController alloc] init];
        arth.mInt_from = 2;
        arth.mStr_title = model.Subject;
        arth.mStr_tableID = model.TabIDStr;
        [utils pushViewController:arth animated:YES];
    }else if ([userInfoModel.UnitType intValue] ==2){//当为班级
        TreeView_node *node = [self.mArr_display objectAtIndex:indexPath.row];
        if (node.type == 0) {//判断为最大层级
            if (node.readflag == 0) {//本单位分享
                NoticeListViewController *notice = [[NoticeListViewController alloc] init];
                notice.mStr_title = userInfoModel.UnitName;
                notice.mStr_classID = userInfoModel.UnitID;
                [dm getInstance].UID = [userInfoModel.UnitID intValue];
                [dm getInstance].mStr_unit = userInfoModel.UnitName;
                [utils pushViewController:notice animated:YES];
            }else{
                [self reloadDataForDisplayArrayChangeAt:node.readflag];//修改cell的状态(关闭或打开)
                if (node.isExpanded) {//根据现在是否打开状态，判断是否发生请求
                    if (node.readflag == 1) {//关联的班级
                        [[ShareHttp getInstance] shareHttpGetMyUserClassWith:[dm getInstance].jiaoBaoHao UID:userInfoModel.UnitID Section:@"3"];
                    }else if (node.readflag == 2){//所有班级
                        [[ShareHttp getInstance] shareHttpGetUnitClassWith:userInfoModel.UnitID Section:@"2"];
                    }
                    [MBProgressHUD showMessage:@"" toView:self];
                }
            }
        } else {//第1层级，点击跳转界面，进入文章列表
            TreeView_Level0_Model *nodeData = node.nodeData;
            NoticeListViewController *notice = [[NoticeListViewController alloc] init];
            notice.mStr_title = nodeData.mStr_name;
            notice.mStr_classID = nodeData.mStr_classID;
            [dm getInstance].UID = [userInfoModel.UnitID intValue];
            [dm getInstance].mStr_unit = userInfoModel.UnitName;
            [utils pushViewController:notice animated:YES];
        }
    }
}

/*---------------------------------------
 修改cell的状态(关闭或打开)
 --------------------------------------- */
-(void) reloadDataForDisplayArrayChangeAt:(NSInteger)row{
    for (TreeView_node *node in self.mArr_class) {
        if(node.readflag == row){
            node.isExpanded = !node.isExpanded;
        }
        for(TreeView_node *node2 in node.sonNodes){
            if(node2.readflag == row){
                node2.isExpanded = !node2.isExpanded;
            }
        }
    }
    [self reloadDataForDisplayArray];
}

#pragma mark - Collection View Data Source
//collectionView里有多少个组
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return 1;
//}
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    return self.mArr_unit.count;
}
//定义并返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ShareCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:NoticeCell forIndexPath:indexPath];
    if (!cell) {
        
    }
    UnitSectionMessageModel *model = [self.mArr_unit objectAtIndex:indexPath.row];
    cell.mImgV_red.hidden = YES;
    cell.mLab_count.hidden = YES;
    //图标
    int a = ([dm getInstance].width-50)/4;
    cell.mImgV_background.frame = CGRectMake(10, 10, a-20, a-20);
    if (indexPath.row == self.mInt_flag) {
        cell.mImgV_background.frame = CGRectMake(0, 0, a, a-3);
        cell.mImgV_background.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@1",model.imgName]];
    }else{
        cell.mImgV_background.frame = CGRectMake(10, 10, a-20, a-20);
        cell.mImgV_background.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@0",model.imgName]];
    }
    
    //标题
    cell.mLab_name.text = model.UnitName;
    CGSize size = [model.UnitName sizeWithFont:[UIFont systemFontOfSize:12]];
    if (size.width>cell.mLab_name.frame.size.width) {
        cell.mLab_name.numberOfLines = 2;
    }
    return cell;
}

//设置每组的cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //找到当前点击的cell，然后改变选中值，重置界面
    self.mInt_flag = (int)indexPath.row;
    [self.mArr_tabel removeAllObjects];
    [self.mArr_class removeAllObjects];
    [self.mCollectionV_unit reloadData];
    UnitSectionMessageModel *model = [self.mArr_unit objectAtIndex:indexPath.row];
    self.mLab_name.text = [NSString stringWithFormat:@"  %@",model.UnitName];
    self.mInt_index = 1;
    [self.mModel_notice.noticeInfoArray removeAllObjects];
    
    if ([model.UnitType intValue] ==1){//教育局
        //先切换单位
        [dm getInstance].UID = [model.UnitID intValue];
        [dm getInstance].mStr_unit = model.UnitName;
        //    [dm getInstance].mStr_tableID = userUnitsModel.TabIDStr;
        //发送获取切换单位和个人信息请求
        [[LoginSendHttp getInstance] changeCurUnit];
        [[LoginSendHttp getInstance] getUserInfoWith:[dm getInstance].jiaoBaoHao UID:[NSString stringWithFormat:@"%d",[dm getInstance].UID]];
        [MBProgressHUD showMessage:@"" toView:self];
    }else if ([model.UnitType intValue] ==2){//学校
        [self unitTypeClass];
        [self reloadDataForDisplayArray];//初始化将要显示的数据
    }
}
//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(([dm getInstance].width-50)/4, ([dm getInstance].width-50)/4);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

//向转发界面传递得到的人员单位列表，在获取通知前，切换单位用到
-(void)CMRevicer{
    for (int i=0; i<self.mArr_unit.count; i++) {
        UnitSectionMessageModel *model = [self.mArr_unit objectAtIndex:i];
        if ([dm getInstance].UID == [model.UnitID intValue]) {
            self.mInt_flag = i;
            //发送获取当前单位通知请求
            [LoginSendHttp getInstance].mInt_forwardFlag = 1;
            UnitSectionMessageModel *model = [self.mArr_unit objectAtIndex:self.mInt_flag];
            D("NoticeHttpGetUnitNoticesWith-===%@,%@,%d",model.UnitType,model.UnitID,self.mInt_index);
            [[ShareHttp getInstance] NoticeHttpGetUnitNoticesWith:model.UnitType UnitID:model.UnitID pageNum:[NSString stringWithFormat:@"%d",self.mInt_index]];
            [self.mCollectionV_unit reloadData];
        }
    }
}

//通知到内务获取到的单位通知
-(void)GetUnitNotices:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        //判断是否是加载更多
        if (self.mModel_notice.noticeInfoArray.count == 0) {
            self.mModel_notice = [dic objectForKey:@"model"];
        }else{
            UnitNoticeModel *model = [dic objectForKey:@"model"];
            [self.mModel_notice.noticeInfoArray addObjectsFromArray:model.noticeInfoArray];
        }
        
        D("self.mModel_notice...%lu",(unsigned long)self.mModel_notice.noticeInfoArray.count);
        [self.mTableV_detail reloadData];
        //表格,按钮，总大小
        [self clickUnitResetFrame];
    }else{
        [MBProgressHUD showError:@"超时" toView:self];
    }
}


@end

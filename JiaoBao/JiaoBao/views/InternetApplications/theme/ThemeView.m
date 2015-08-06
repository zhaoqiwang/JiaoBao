//
//  ThemeView.m
//  JiaoBao
//
//  Created by Zqw on 14-12-16.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "ThemeView.h"
#import "Reachability.h"
#import "MobClick.h"

@implementation ThemeView

- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = frame;
        //做bug服务器显示当前的哪个界面
        NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
        [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
        [self setBackgroundColor:[UIColor colorWithRed:247/255.0 green:246/255.0 blue:246/255.0 alpha:1]];
        
        self.mArr_first = [NSMutableArray array];
        self.mArr_choice = [NSMutableArray array];
        self.mArr_education = [NSMutableArray array];
        self.mArr_extracurricular = [NSMutableArray array];
        self.mArr_happy = [NSMutableArray array];
        self.mArr_life = [NSMutableArray array];
        self.mArr_paternity = [NSMutableArray array];
        self.mArr_recommend = [NSMutableArray array];
        self.mArr_science = [NSMutableArray array];
        self.mInt_index = 0;
        //首页精选等
        self.mScrollV_all = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, [dm getInstance].width-20-40, 48)];
        int tempWidth = 50;
        for (int i=0; i<9; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(tempWidth*i, 1, tempWidth, 47)];
            [button setTag:i];
            if (i==0) {
                button.selected = YES;
            }
            [button setTitleColor:[UIColor colorWithRed:130/255.0 green:129/255.0 blue:130/255.0 alpha:1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:91/255.0 green:178/255.0 blue:57/255.0 alpha:1] forState:UIControlStateSelected];
            [button setBackgroundColor:[UIColor colorWithRed:247/255.0 green:246/255.0 blue:246/255.0 alpha:1]];
            //设置标题位置
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"NewWorkView_click_%d",0]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"NewWorkView_%d",0]] forState:UIControlStateSelected];
            
            [button addTarget:self action:@selector(selectScrollButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.mScrollV_all addSubview:button];
        }
        self.mScrollV_all.contentSize = CGSizeMake(50*9, 48);
        [self addSubview:self.mScrollV_all];
        //表格
        self.mTableV_knowledge = [[UITableView alloc] initWithFrame:CGRectMake(0, 48, [dm getInstance].width, self.frame.size.height-48)];
        self.mTableV_knowledge.delegate = self;
        self.mTableV_knowledge.dataSource = self;
        [self addSubview:self.mTableV_knowledge];
    }
    return self;
}

-(void)selectScrollButton:(UIButton *)btn{
    self.mInt_index = (int)btn.tag;
    for (UIButton *btn1 in self.mScrollV_all.subviews) {
        if ([btn1.class isSubclassOfClass:[UIButton class]]) {
            if ((int)btn1.tag == self.mInt_index) {
                btn1.selected = YES;
            }else{
                btn1.selected = NO;
            }
        }
    }
}

-(void)ProgressViewLoad{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    [[KnowledgeHttp getInstance]UserIndexQuestionWithNumPerPage:@"10" pageNum:@"1" RowCount:@"0" flag:@"1"];
   // [[KnowledgeHttp getInstance]reportanswerWithAId:@"85"];//没有成功
//    [[KnowledgeHttp getInstance]GetAnswerByIdWithNumPerPage:@"20" pageNum:@"1" QId:@"15" flag:@"1"];
//    [[KnowledgeHttp getInstance]UpdateAnswerWithTabID:@"15" Title:@"" AContent:@"333333"];
//    [[KnowledgeHttp getInstance]AddAnswerWithQId:@"15" Title:@"" AContent:@"2" UserName:@""];
//    [[KnowledgeHttp getInstance]QuestionDetailWithQId:@"15"];
//    [[KnowledgeHttp getInstance] knowledgeHttpGetProvice];
//    [[KnowledgeHttp getInstance] knowledgeHttpGetCity:@"" level:@""];
//    [MBProgressHUD showMessage:@"" toView:self];
}
//检查当前网络是否可用
-(BOOL)checkNetWork{
    if([Reachability isEnableNetwork]==NO){
        [MBProgressHUD showError:NETWORKENABLE toView:self];
        return YES;
    }else{
        return NO;
    }
}

//切换账号时，更新数据
-(void)RegisterView:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    [dm getInstance].mImt_showUnRead = 0;
    [dm getInstance].mImt_shareUnRead = 0;
}

-(NSMutableArray *)arrayDataSource{
    NSMutableArray *array = [NSMutableArray array];
    switch (self.mInt_index) {
        case 0:
            array = [NSMutableArray arrayWithArray:self.mArr_first];
            break;
        case 1:
            array = [NSMutableArray arrayWithArray:self.mArr_choice];
            break;
        case 2:
            array = [NSMutableArray arrayWithArray:self.mArr_recommend];
            break;
        case 3:
            array = [NSMutableArray arrayWithArray:self.mArr_education];
            break;
        case 4:
            array = [NSMutableArray arrayWithArray:self.mArr_science];
            break;
        case 5:
            array = [NSMutableArray arrayWithArray:self.mArr_life];
            break;
        case 6:
            array = [NSMutableArray arrayWithArray:self.mArr_happy];
            break;
        case 7:
            array = [NSMutableArray arrayWithArray:self.mArr_paternity];
            break;
        case 8:
            array = [NSMutableArray arrayWithArray:self.mArr_extracurricular];
            break;
        default:
            break;
    }
    return array;
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return [self arrayDataSource].count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *indentifier = @"TopArthListCell";
//    TopArthListCell *cell = (TopArthListCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
//    if (cell == nil) {
//        cell = [[TopArthListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TopArthListCell" owner:self options:nil];
//        //这时myCell对象已经通过自定义xib文件生成了
//        if ([nib count]>0) {
//            cell = (TopArthListCell *)[nib objectAtIndex:0];
//            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
//        }
//        //添加图片点击事件
//        //若是需要重用，需要写上以下两句代码
//        UINib * n= [UINib nibWithNibName:@"TopArthListCell" bundle:[NSBundle mainBundle]];
////        [self.mTableV_detail registerNib:n forCellReuseIdentifier:indentifier];
//    }
    NSMutableArray *array = [self arrayDataSource];
    return nil;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

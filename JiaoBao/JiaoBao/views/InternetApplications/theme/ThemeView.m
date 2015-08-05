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
//@synthesize mScrollV_share,mTableV_detail,mTableV_difine,mInt_index,mArr_tabel,mBtn_add,mLab_name,mArr_difine;

- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = frame;
        //做bug服务器显示当前的哪个界面
        NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
        [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    }
    return self;
}

-(void)ProgressViewLoad{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    [[KnowledgeHttp getInstance]QuestionIndexWithNumPerPage:@"20" pageNum:@"1" CategoryId:@"15"];
//    [[KnowledgeHttp getInstance]UpdateQuestionWithTabIDStr:@"15" KnContent:@"2 + 2 = ?" TagsList:@""];没成功 TabIDStr参数不知道在哪获取
//    [[KnowledgeHttp getInstance]NewQuestionWithCategoryId:@"15" Title:@"加法" KnContent:@"1 + 1 = ?" TagsList:@"加,减,乘,除" QFlag:@"1" AreaCode:@"" atAccIds:@""];
//    [[KnowledgeHttp getInstance]CategoryIndexQuestionWithNumPerPage:@"10" pageNum:@"1" RowCount:@"0" flag:@"1" uid:@"15"];
    //[[KnowledgeHttp getInstance]GetAllCategory];
    //[[KnowledgeHttp getInstance]GetCategoryWithParentId:nil subject:nil];
    //[[KnowledgeHttp getInstance]GetUserInfo];
//    [[KnowledgeHttp getInstance] knowledgeHttpGetProvice];
//    [[KnowledgeHttp getInstance]GetAccIdbyNickname:@[@"123",@"456"]];
    
//    [[KnowledgeHttp getInstance] knowledgeHttpGetCity:@"" level:@""];
    //[MBProgressHUD showMessage:@"" toView:self];
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

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
//        return self.mArr_tabel.count;
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"TopArthListCell";
    TopArthListCell *cell = (TopArthListCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[TopArthListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TopArthListCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell = (TopArthListCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        //添加图片点击事件
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"TopArthListCell" bundle:[NSBundle mainBundle]];
//        [self.mTableV_detail registerNib:n forCellReuseIdentifier:indentifier];
    }
//    if (tableView.tag == 1){
    
    return nil;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.row == 1) {
        return 20;
    }else{
        return 50;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

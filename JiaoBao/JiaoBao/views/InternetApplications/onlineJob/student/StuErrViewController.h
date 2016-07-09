//
//  StuErrViewController.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/18.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"//上拉下拉刷新
#import "SelectChapteridViewController.h"


@interface StuErrViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,SelectChapteridViewCDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@property (nonatomic,strong) StuInfoModel *mModel_stuInf;//学生信息，包含id
@property (nonatomic,strong) GenInfo *mModel_gen;//当前选择的学生
@property(nonatomic,strong)NSMutableArray *webDataArr;//错题集内容数组
@property (weak, nonatomic) IBOutlet UIButton *conditionBtn;//显示筛选条件
-(void)sendRequest;

- (IBAction)conditionAction:(id)sender;//筛选条件方法
@property (strong, nonatomic) IBOutlet UITextView *textView;//显示错题内容的textview

@end

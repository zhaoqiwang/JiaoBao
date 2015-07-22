//
//  ReSendMsgViewController.m
//  JiaoBao
//
//  Created by Zqw on 15-2-13.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ReSendMsgViewController.h"
#import "Reachability.h"
#import "Forward_cell.h"
#import "Forward_section.h"
#import "MsgDetail_ReaderList.h"
#import "MobClick.h"
#define Margin 10//边距
#define BtnColor [UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1]//按钮背景色

NSString *kDetailedViewControllerID0 = @"Forward_section";    // view controller storyboard id
NSString *kCellID0 = @"Forward_cell";

@interface ReSendMsgViewController ()

@end

@implementation ReSendMsgViewController
@synthesize mBtn_send,mCollentV_member,mNav_navgationBar,mTextF_text,mView_text,mArr_member;

-(instancetype)init{
    self = [super init];
    self.mArr_member = [[NSMutableArray alloc] init];
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:UMMESSAGE];
    [MobClick beginLogPageView:UMPAGE];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    //键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:UMMESSAGE];
    [MobClick endLogPageView:UMPAGE];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"接收人详情"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    self.mCollentV_member.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height-51);
    self.mCollentV_member.backgroundColor = [UIColor whiteColor];
    self.mCollentV_member.layer.borderWidth = 1;
    self.mCollentV_member.layer.borderColor = [[UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1] CGColor];
    [self.mCollentV_member registerClass:[Forward_cell class] forCellWithReuseIdentifier:kCellID0];
//    [self.mCollentV_member registerClass:[Forward_section class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDetailedViewControllerID0];
    
    //输入View坐标
    self.mView_text.frame = CGRectMake(0, [dm getInstance].height-51, [dm getInstance].width, 51);
    //输入框
    self.mTextF_text.frame = CGRectMake(15, 10, [dm getInstance].width-15-70, 51-20);
    //发送按钮
    self.mBtn_send.frame = CGRectMake([dm getInstance].width-65, 0, 60, 51);
    [self.mBtn_send addTarget:self action:@selector(clickSendBtn:) forControlEvents:UIControlEventTouchUpInside];
}

//点击发送按钮
-(void)clickSendBtn:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    D("点击发送按钮");
    [self.mTextF_text resignFirstResponder];
    if (self.mTextF_text.text.length==0) {
        [MBProgressHUD showError:@"请输入内容" toView:self.view];
        return;
    }
//    CommMsgListModel *model = [self.mArr_msg objectAtIndex:self.mArr_msg.count-1];
//    [[LoginSendHttp getInstance] addFeeBackWithUID:model.TabIDStr content:self.mTextF_text.text];
    [MBProgressHUD showMessage:@"发送中..." toView:self.view];
}

#pragma mark - Collection View Data Source
//collectionView里有多少个组
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return 1;
//}
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    return self.mArr_member.count;
}
//定义并返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Forward_cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID0 forIndexPath:indexPath];
    if (!cell) {
        
    }
    
    MsgDetail_ReaderList *model = [self.mArr_member objectAtIndex:indexPath.row];
    
    if ([model.flag integerValue] == 1) {
        cell.mImgV_select.image = [UIImage imageNamed:@"selected"];
    }else{
        cell.mImgV_select.image = [UIImage imageNamed:@"blank"];
    }
//    CGSize size = [model.TrueName sizeWithFont:[UIFont systemFontOfSize:12]];
    cell.backgroundColor = [UIColor grayColor];
    cell.mLab_name.text = model.TrueName;
    
    return cell;
}
//定义并返回每个headerView或footerView
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    Forward_section *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kDetailedViewControllerID0 forIndexPath:indexPath];
////    view.delegate = self;
//    view.frame = CGRectMake(0, 0, 0, 0);
//    return view;
//}
//设置每组的cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //找到当前点击的cell，然后改变选中值，重置界面
    MsgDetail_ReaderList *model = [self.mArr_member objectAtIndex:indexPath.row];
        if ([model.flag integerValue] == 0) {
            model.flag = @"1";
        }else{
            model.flag = @"0";
        }
        [self.mCollentV_member reloadData];

}
//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(([dm getInstance].width-40)/2, 40);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
//手动设置size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    return CGSizeMake(120, 40);
//}

//开始滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.mTextF_text resignFirstResponder];
    D("4444444444");
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

- (void) keyboardWasShown:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSValue *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.mCollentV_member.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height-51-keyboardSize.height);
                         self.mView_text.frame = CGRectMake(0, [dm getInstance].height-keyboardSize.height-51, [dm getInstance].width, 51);
                     }
                     completion:^(BOOL finished){
                         ;
                     }];
}
- (void) keyboardWasHidden:(NSNotification *) notif{
    NSDictionary *userInfo = [notif userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.mCollentV_member.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height-51);
                         self.mView_text.frame = CGRectMake(0, [dm getInstance].height-51, [dm getInstance].width, 51);
                     }
                     completion:^(BOOL finished){
                         ;
                     }];
}

//键盘点击DO
#pragma mark - UITextView Delegate Methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)ProgressViewLoad{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    [MBProgressHUD showMessage:@"" toView:self.view];
}

//导航条返回按钮
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

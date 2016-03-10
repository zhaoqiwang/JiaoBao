//
//  TeacherViewController.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/9.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "TeacherViewController.h"
#import "addDateCell.h"
#import "dm.h"

@interface TeacherViewController ()

@end

@implementation TeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"addDateCell";
    addDateCell *cell = (addDateCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (cell == nil) {
        cell = [[addDateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"addDateCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell = (addDateCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        //添加图片点击事件
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"addDateCell" bundle:[NSBundle mainBundle]];
        [self.tableview registerNib:n forCellReuseIdentifier:indentifier];
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self _doClickShowModalDialog:nil];
    //[self _doClickCloseDialog:nil];
    
}
-(void) _doClickShowModalDialog : (UIButton*) sender {
    NSLog(@"_doClickShowModalDialog");
    
    UIView* vwFullScreenView = [[UIView alloc]init];
    vwFullScreenView.tag=9999;
    vwFullScreenView.backgroundColor=[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:0.5];
    vwFullScreenView.frame=self.view.window.frame;
    [self.view.window addSubview:vwFullScreenView];
    
//    UIView* vwDialog = [[UIView alloc] init];
//    vwDialog.frame=CGRectMake(10, 0, [dm getInstance].width-20, 135);
//    vwDialog.backgroundColor=[UIColor whiteColor];
//    vwDialog.layer.borderColor=[UIColor grayColor].CGColor;
//    vwDialog.layer.borderWidth=0.6;
//    vwDialog.layer.cornerRadius=6;
//    vwDialog.center=vwFullScreenView.center;
//    [vwFullScreenView addSubview:vwDialog];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ModelDialog" owner:self options:nil];
    //这时myCell对象已经通过自定义xib文件生成了
    if ([nib count]>0) {
        UIView *customView = [nib objectAtIndex:0];
        customView.frame=CGRectMake(10, 0, [dm getInstance].width-20, 135);
        customView.center=vwFullScreenView.center;

        customView.layer.borderWidth=0.6;
        customView.layer.cornerRadius=6;
        customView.layer.borderColor = [UIColor clearColor].CGColor;
        [vwFullScreenView addSubview:customView];

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

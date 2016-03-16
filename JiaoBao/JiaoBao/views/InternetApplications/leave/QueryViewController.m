//
//  QueryViewController.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/15.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "QueryViewController.h"
#import "QueryCell.h"
#import "CustomQueryCell.h"
#import "dm.h"


@interface QueryViewController ()

@end

@implementation QueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellFlag = YES;
    UIView *headView = [[UIView alloc]init ];
    if(self.mInt_leaveID ==1){
        headView.frame = CGRectMake(0, 0, [dm getInstance].width, CGRectGetHeight(self.tableHeadView.frame));
        [headView addSubview:self.tableHeadView];

    }
    else if (self.mInt_leaveID ==2){
        headView.frame = CGRectMake(0, 0, [dm getInstance].width, CGRectGetHeight(self.teaHeadView.frame));
        [headView addSubview:self.teaHeadView];

    }
    else if (self.mInt_leaveID == 3){
        headView.frame = CGRectMake(0, 0, [dm getInstance].width, CGRectGetHeight(self.ParentsHeadView.frame));
        [headView addSubview:self.ParentsHeadView];

    }
    else{
        headView.frame = CGRectMake(0, 0, [dm getInstance].width, CGRectGetHeight(self.teaHeadView.frame));
        [headView addSubview:self.teaHeadView];
        
    }

    self.tableView.tableHeaderView = headView;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.cellFlag == NO){
        static NSString *indentifier = @"QueryCell";
        QueryCell *cell = (QueryCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
        
        if (cell == nil) {
            cell = [[QueryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QueryCell" owner:self options:nil];
            //这时myCell对象已经通过自定义xib文件生成了
            if ([nib count]>0) {
                cell = (QueryCell *)[nib objectAtIndex:0];
                //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
            }
            //添加图片点击事件
            //若是需要重用，需要写上以下两句代码
            UINib * n= [UINib nibWithNibName:@"QueryCell" bundle:[NSBundle mainBundle]];
            [self.tableView registerNib:n forCellReuseIdentifier:indentifier];
        }
        return cell;
        
    }
    else{
        static NSString *indentifier = @"CustomQueryCell";
        CustomQueryCell *cell = (CustomQueryCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
        
        if (cell == nil) {
            cell = [[CustomQueryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomQueryCell" owner:self options:nil];
            //这时myCell对象已经通过自定义xib文件生成了
            if ([nib count]>0) {
                cell = (CustomQueryCell *)[nib objectAtIndex:0];
                //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
            }
            //添加图片点击事件
            //若是需要重用，需要写上以下两句代码
            UINib * n= [UINib nibWithNibName:@"CustomQueryCell" bundle:[NSBundle mainBundle]];
            [self.tableView registerNib:n forCellReuseIdentifier:indentifier];
        }
        return cell;
        
    }

    
    
    return nil;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(self.cellFlag == YES){
        return self.stuSection;
    }
    else{
        return self.sectionView;
        
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 32;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectionBtnAction:(id)sender {
    UIButton *btn = sender;
    if([btn isEqual:self.myBtn]){
        self.myBtn.selected = YES;
        self.stdBtn.selected = NO;
        self.cellFlag = YES;
        [self.tableView reloadData];
    }else{
        self.myBtn.selected = NO;
        self.stdBtn.selected = YES;
        self.cellFlag = NO;
        [self.tableView reloadData];
        
    }
    
}
@end

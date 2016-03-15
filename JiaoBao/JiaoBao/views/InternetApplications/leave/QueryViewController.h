//
//  QueryViewController.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/15.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueryViewController : UITableViewController<UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *tableHeadView;
@property (weak, nonatomic) IBOutlet UIButton *myBtn;
@property (weak, nonatomic) IBOutlet UIButton *stdBtn;

@property (strong, nonatomic) IBOutlet UIView *sectionView;
@property (nonatomic,assign) int mInt_leaveID;//区分身份，门卫0，班主任1，普通老师2，家长3
- (IBAction)selectionBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *teaHeadView;

@end

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
- (IBAction)buttonSelectionAction:(id)sender ;
@property (strong, nonatomic) IBOutlet UIView *sectionView;

@end

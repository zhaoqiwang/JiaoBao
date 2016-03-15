//
//  TeacherViewController.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/9.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelDialog.h"

@interface TeacherViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ModelDialogDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

//
//  AddQuestionViewController.h
//  JiaoBao
//
//  Created by songyanming on 15/8/11.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"

@interface AddQuestionViewController : UIViewController<MyNavigationDelegate>
@property(nonatomic,strong)MyNavigationBar *mNav_navgationBar;
@property (weak, nonatomic) IBOutlet UITextField *provinceTF;
@property (weak, nonatomic) IBOutlet UITextField *regionTF;
@property (weak, nonatomic) IBOutlet UITextField *countyTF;
- (IBAction)provinceBtnAction:(id)sender;
- (IBAction)regionBtnAction:(id)sender;
- (IBAction)countyBtnAction:(id)sender;
- (IBAction)categaryBtnAction:(id)sender;


@end

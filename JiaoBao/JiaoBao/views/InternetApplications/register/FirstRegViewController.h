//
//  FirstRegViewController.h
//  JiaoBao
//
//  Created by songyanming on 15/6/3.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"

@interface FirstRegViewController : UIViewController<UITextFieldDelegate,MyNavigationDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tel;
@property (weak, nonatomic) IBOutlet UITextField *urlNumTF;
@property (weak, nonatomic) IBOutlet UITextField *tel_identi_codeTF;
@property (weak, nonatomic) IBOutlet UIImageView *urlImgV;
@property(nonatomic,strong)NSString *telStr;
@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property(nonatomic,assign)BOOL forgetPWSymbol;

@property(nonatomic,assign)BOOL telSymbol,urlSymbol ,identi_code_Symbol;
- (IBAction)getIdentiCodeAction:(id)sender;
- (IBAction)nextStepAction:(id)sender;
- (IBAction)getUrlImageAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *get_identi_code_btn;

@end
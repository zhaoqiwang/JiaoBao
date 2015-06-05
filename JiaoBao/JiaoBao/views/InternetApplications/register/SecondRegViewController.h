//
//  SecondRegViewController.h
//  JiaoBao
//
//  Created by songyanming on 15/6/4.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"


@interface SecondRegViewController : UIViewController<MyNavigationDelegate>
@property(nonatomic,strong)NSString *tel,*urlNumStr;
@property (weak, nonatomic) IBOutlet UITextField *urlNumTF;
@property (weak, nonatomic) IBOutlet UITextField *tel_identi_codeTF;
@property (weak, nonatomic) IBOutlet UIImageView *urlImgV;
@property(nonatomic,assign)BOOL telSymbol,urlSymbol ,identi_code_Symbol;
@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property(nonatomic,assign)BOOL forgetPWSymbol;


- (IBAction)getIdentiCodeAction:(id)sender;
- (IBAction)nextStepAction:(id)sender;
- (IBAction)getUrlImageAction:(id)sender;

@end

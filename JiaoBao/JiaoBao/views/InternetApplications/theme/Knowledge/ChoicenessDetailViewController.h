//
//  ChoicenessDetailViewController.h
//  JiaoBao
//
//  Created by songyanming on 15/9/10.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickContentModel.h"
#import "MyNavigationBar.h"



@interface ChoicenessDetailViewController : UIViewController<MyNavigationDelegate>
@property(nonatomic,strong)PickContentModel *pickContentModel;
@property(nonatomic,strong)MyNavigationBar *mNav_navgationBar;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;


@end

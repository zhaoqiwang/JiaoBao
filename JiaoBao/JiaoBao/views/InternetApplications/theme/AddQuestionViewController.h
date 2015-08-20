//
//  AddQuestionViewController.h
//  JiaoBao
//
//  Created by songyanming on 15/8/11.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "ELCImagePickerController.h"
#include<AssetsLibrary/AssetsLibrary.h>


@interface AddQuestionViewController : UIViewController<MyNavigationDelegate,UIActionSheetDelegate,ELCAssetSelectionDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)MyNavigationBar *mNav_navgationBar;
@property (weak, nonatomic) IBOutlet UITextField *provinceTF;
@property (weak, nonatomic) IBOutlet UITextField *regionTF;
@property (weak, nonatomic) IBOutlet UITextField *countyTF;
@property(nonatomic,strong)NSMutableArray *mArr_AllCategory;
@property (weak, nonatomic) IBOutlet UITextField *categoryTF;
@property(nonatomic,strong)NSMutableString *categoryId;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;

@property (weak, nonatomic) IBOutlet UITextField *knContentTF;
@property (weak, nonatomic) IBOutlet UITextField *atAccIdsTF;
@property(nonatomic,strong)NSString *AreaCode;
@property (nonatomic,weak) IBOutlet UITextView *mTextV_content;//内容
@property(nonatomic,assign)int imageCount,mInt_index;
@property(nonatomic,strong)NSMutableArray *mArr_pic;
@property(nonatomic,assign)int tfContentTag;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *ttitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

-(IBAction)mBtn_photo:(id)sender;



- (IBAction)provinceBtnAction:(id)sender;
- (IBAction)regionBtnAction:(id)sender;
- (IBAction)countyBtnAction:(id)sender;
- (IBAction)categaryBtnAction:(id)sender;
- (IBAction)addQuestionAction:(id)sender;


@end

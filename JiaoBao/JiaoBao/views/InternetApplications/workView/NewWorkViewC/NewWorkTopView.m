//
//  NewWorkTopView.m
//  JiaoBao
//
//  Created by Zqw on 15-4-25.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "NewWorkTopView.h"

@implementation NewWorkTopView

@synthesize mArr_accessory,mInt_sendMsg,mView_accessory,mBtn_accessory,mBtn_send,mBtn_sendMsg,mBtn_photos,mTextV_input,delegate;

- (id)init{
    self = [super init];
    if (self) {
        // Initialization code
//        self.frame = frame;
        self.mArr_accessory = [NSMutableArray array];
        //输入框
        self.mTextV_input = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, [dm getInstance].width-20, 60)];
        //添加边框
        self.mTextV_input.layer.borderWidth = .5;
        self.mTextV_input.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
        //将图层的边框设置为圆脚
        self.mTextV_input.layer.cornerRadius = 4;
        self.mTextV_input.layer.masksToBounds = YES;
        self.mTextV_input.delegate = self;
        self.mTextV_input.returnKeyType = UIReturnKeyDone;//return键的类型
        [self addSubview:self.mTextV_input];
        //计算间隙
        int a = ([dm getInstance].width-60*3+10-90-20)/3;
        //附件
        self.mBtn_accessory = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mBtn_accessory.frame = CGRectMake(10, self.mTextV_input.frame.origin.y+self.mTextV_input.frame.size.height+10, 60, 30);
        [self.mBtn_accessory setImage:[UIImage imageNamed:@"NewWork_accessory"] forState:UIControlStateNormal];
        [self.mBtn_accessory setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.mBtn_accessory.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.mBtn_accessory addTarget:self action:@selector(mBtn_accessory:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mBtn_accessory];
        //拍照
        self.mBtn_photos = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mBtn_photos.frame = CGRectMake(self.mBtn_accessory.frame.origin.x+self.mBtn_accessory.frame.size.width+a, self.mBtn_accessory.frame.origin.y, 60, 30);
        [self.mBtn_photos setImage:[UIImage imageNamed:@"NewWork_photo"] forState:UIControlStateNormal];
        [self.mBtn_photos setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.mBtn_photos.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.mBtn_photos addTarget:self action:@selector(mBtn_photo:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mBtn_photos];
        //短信提醒
        self.mBtn_sendMsg = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mBtn_sendMsg.frame = CGRectMake(self.mBtn_photos.frame.origin.x+self.mBtn_photos.frame.size.width+a, self.mBtn_accessory.frame.origin.y, 90, 30);
        if (self.mInt_sendMsg == 0) {
            [self.mBtn_sendMsg setImage:[UIImage imageNamed:@"NewWork_SendMsg"] forState:UIControlStateNormal];
        }else if (self.mInt_sendMsg == 1){
            [self.mBtn_sendMsg setImage:[UIImage imageNamed:@"NewWork_unSendMsg"] forState:UIControlStateNormal];
        }
        [self.mBtn_sendMsg addTarget:self action:@selector(sendMsgBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.mBtn_sendMsg setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.mBtn_sendMsg.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.mBtn_sendMsg];
        //发送按钮
        self.mBtn_send = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mBtn_send.frame = CGRectMake(self.mBtn_sendMsg.frame.origin.x+self.mBtn_sendMsg.frame.size.width+a, self.mBtn_accessory.frame.origin.y, 50, 30);
        [self.mBtn_send setImage:[UIImage imageNamed:@"NewWork_Send"] forState:UIControlStateNormal];
        [self.mBtn_send addTarget:self action:@selector(mBtn_send:) forControlEvents:UIControlEventTouchUpInside];
        [self.mBtn_send setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.mBtn_send.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.mBtn_send];
        //附件显示框
        self.mView_accessory = [[UIView alloc] initWithFrame:CGRectMake(20, self.mBtn_accessory.frame.origin.y+self.mBtn_accessory.frame.size.height+10, [dm getInstance].width-30, 0)];
        [self addSubview:self.mView_accessory];
        //上半部分frame
        self.frame = CGRectMake(0, 0, [dm getInstance].width, self.mView_accessory.frame.origin.y+self.mView_accessory.frame.size.height);
    }
    return self;
}

//点击发送短信按钮
-(void)sendMsgBtn:(UIButton *)btn{
    if (self.mInt_sendMsg == 0) {
        self.mInt_sendMsg = 1;
        [self.mBtn_sendMsg setImage:[UIImage imageNamed:@"NewWork_unSendMsg"] forState:UIControlStateNormal];
    } else {
        self.mInt_sendMsg = 0;
        [self.mBtn_sendMsg setImage:[UIImage imageNamed:@"NewWork_SendMsg"] forState:UIControlStateNormal];
    }
}

//附件按钮点击事件
-(void)mBtn_accessory:(UIButton *)btn{
    AccessoryViewController *access = [[AccessoryViewController alloc] init];
    access.delegate = self;
    [utils pushViewController:access animated:YES];
}

//点击照片
-(void)mBtn_photo:(UIButton *)btn{
    UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:@"添加附件" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册添加",@"拍照添加",nil];
    action.tag = 1;
    [action showInView:self.superview];
}

//发送按钮
-(void)mBtn_send:(UIButton *)btn{
    [self.delegate mBtn_send:btn];
}

//点击删除附件
-(void)deleteAccessoryPhoto:(UIButton *)btn{
    //从数组中删除
    [self.mArr_accessory removeObjectAtIndex:btn.tag];
    //刷新界面
    [self addAccessoryPhoto];
}

//附件选择界面的回调
-(void)selectFile:(NSMutableArray *)array{
    [self.mArr_accessory addObjectsFromArray:array];
    //添加显示附件
    [self addAccessoryPhoto];
}

//刷新显示附件
-(void)addAccessoryPhoto{
    //清掉显示的附件
    for (UIButton *btn in self.mView_accessory.subviews) {
        [btn removeFromSuperview];
    }
    //将选中的文件，在界面中显示
    CGRect rect0 = CGRectMake(0, 0, 25, 25);
    for (int i =0; i<self.mArr_accessory.count; i++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeContactAdd];
        but.frame = CGRectMake(rect0.origin.x+2, rect0.origin.y+2, 25, 25);
        but.tag = i;
        [but setImage:[UIImage imageNamed:@"work_deleteAccessory"] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(deleteAccessoryPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [self.mView_accessory addSubview:but];
        UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tempBtn.frame = CGRectMake(30, but.frame.origin.y, self.self.mView_accessory.frame.size.width-35, 25);
        AccessoryModel *model = [self.mArr_accessory objectAtIndex:i];
        [tempBtn setTitle:model.mStr_name forState:UIControlStateNormal];
        tempBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        tempBtn.tag = i;
        tempBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [tempBtn addTarget:self action:@selector(clickAccessoryPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [self.mView_accessory addSubview:tempBtn];
        rect0 = CGRectMake(0, but.frame.origin.y+25, 0, 25);
    }
    if (self.mArr_accessory.count == 0) {
        rect0 = CGRectMake(0, 0, 0, 0);
    }
    self.mView_accessory.frame = CGRectMake(self.mView_accessory.frame.origin.x, self.mView_accessory.frame.origin.y, self.mView_accessory.frame.size.width, rect0.origin.y);
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.mView_accessory.frame.origin.y+self.mView_accessory.frame.size.height);
    //NSLog(@"height = %f",self.frame.size.height);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshWorkView" object:nil];

    //[self setFrame];
}

//UIActionSheet回调方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1) {//单位
        if (buttonIndex == 0){//相册添加
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
            
            elcPicker.maximumImagesCount = 10; //设置的图像的最大数目来选择至100
            elcPicker.returnsOriginalImage = YES; //只返回fullScreenImage，而不是fullResolutionImage
            elcPicker.returnsImage = YES; //返回的UIImage如果YES。如果NO，只返回资产位置信息
            elcPicker.onOrder = YES; //对于多个图像选择，显示和选择图像的退货订单
            //            elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //支持图片和电影类型
            elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //支持图片和电影类型
            elcPicker.imagePickerDelegate = self;
            //            [self presentViewController:elcPicker animated:YES completion:nil];
            [utils pushViewController1:elcPicker animated:YES];
        }else if (buttonIndex == 1){//拍照添加
            [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
        }
    }
}

//点击附件
-(void)clickAccessoryPhoto:(UIButton *)btn{
    NSString *name = [self.mArr_accessory objectAtIndex:btn.tag];
    if([[name pathExtension] isEqualToString:@"png"]) {  //取得后缀名这.png的文件名
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
        NSString *imgPath=[tempPath stringByAppendingPathComponent:name];
        UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, self.frame.size.height)];
        D("tempviewshgkeh-====%@",NSStringFromCGRect(self.frame));
        tempView.backgroundColor = [UIColor blackColor];
        tempView.tag = 998;
        UITapGestureRecognizer *tempTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTempViewRemove:)];
        [tempView addGestureRecognizer:tempTap];
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height-320)/2, 320, 320)];
        [imgV setImage:img];
        [tempView addSubview:imgV];
        [self addSubview:tempView];
    }
}

//放大头像后，点击移除
-(void)clickTempViewRemove:(UITapGestureRecognizer *)tap{
    for (UIView *view in self.subviews) {
        if (view.tag == 998) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark ELCImagePickerControllerDelegate Methods
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [utils popViewControllerAnimated1:YES];
    if (info.count>0) {
        //        self.mProgressV.labelText = @"处理中...";
        //        self.mProgressV.mode = MBProgressHUDModeIndeterminate;
        //        [self.mProgressV show:YES];
        //        [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
        //        D("info.count-===%lu",(unsigned long)info.count);
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //文件名
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
    //判断文件夹是否存在
    if(![fileManager fileExistsAtPath:tempPath]) {//如果不存在
        [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                NSData *imageData = UIImageJPEGRepresentation(image,0);
                
                NSString *imgPath=[tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",timeSp]];

                D("图片路径是：%@",imgPath);
                BOOL yesNo=[[NSFileManager defaultManager] fileExistsAtPath:imgPath];
                if (!yesNo) {//不存在，则直接写入后通知界面刷新
                    BOOL result = [imageData writeToFile:imgPath atomically:YES];
                    for (;;) {
                        if (result) {
                            AccessoryModel *model = [[AccessoryModel  alloc] init];
                            model.mStr_name= [NSString stringWithFormat:@"%@.png",timeSp];
                            model.pathStr = imgPath;
                            model.fileAttributeDic = [fileManager attributesOfItemAtPath:imgPath error:nil];
                            [self.mArr_accessory addObject:model];
                            
                            break;
                        }
                    }
                }else {//存在
                    BOOL blDele= [fileManager removeItemAtPath:imgPath error:nil];//先删除
                    if (blDele) {//删除成功后，写入，通知界面
                        BOOL result = [imageData writeToFile:imgPath atomically:YES];
                        for (;;) {
                            if (result) {
                                AccessoryModel *model = [[AccessoryModel  alloc] init];
                                model.mStr_name= [NSString stringWithFormat:@"%@.png",timeSp];
                                model.pathStr = imgPath;
                                model.fileAttributeDic = [fileManager attributesOfItemAtPath:imgPath error:nil];
                                [self.mArr_accessory addObject:model];
                                
                                break;
                            }
                        }
                    }
                }
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        }
        else {
            NSLog(@"Uknown asset type");
        }
        timeSp = [NSString stringWithFormat:@"%d",[timeSp intValue] +1];
    }
    //添加显示附件
    [self addAccessoryPhoto];
    //    [self.mProgressV hide:YES];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [utils popViewControllerAnimated1:YES];
}

-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType{
    NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediatypes count]>0) {
        NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
        self.picker=[[UIImagePickerController alloc] init];
        self.picker.mediaTypes=mediatypes;
        self.picker.delegate=self;
        //        picker.allowsEditing=YES;
        self.picker.sourceType=sourceType;
        
        
        if([[[UIDevice
              currentDevice] systemVersion] floatValue]>=8.0) {
            
            self.picker.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            
        }
        NSString *requiredmediatype=(NSString *)kUTTypeImage;
        NSArray *arrmediatypes=[NSArray arrayWithObject:requiredmediatype];
        [self.picker setMediaTypes:arrmediatypes];
        
//        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
//            picker.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//        }
        //        [self presentViewController:picker animated:YES completion:nil];
        [utils pushViewController1:self.picker animated:YES];
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误信息!" message:@"当前设备不支持拍摄功能" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma 拍照模块
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *lastChosenMediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if([lastChosenMediaType isEqual:(NSString *) kUTTypeImage])
    {
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        UIImage *chosenImage=[info objectForKey:UIImagePickerControllerOriginalImage];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
        //判断文件夹是否存在
        if(![fileManager fileExistsAtPath:tempPath]) {//如果不存在
            [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSData *imageData = UIImageJPEGRepresentation(chosenImage,0);
        
        NSString *imgPath=[tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",timeSp]];
        D("图片路径是：%@",imgPath);

        BOOL yesNo=[[NSFileManager defaultManager] fileExistsAtPath:imgPath];
        AccessoryModel *model = [[AccessoryModel  alloc] init];

        if (!yesNo) {//不存在，则直接写入后通知界面刷新
            BOOL result = [imageData writeToFile:imgPath atomically:YES];
            for (;;) {
                if (result) {
                    model.mStr_name= [NSString stringWithFormat:@"%@.png",timeSp];
                    model.pathStr = imgPath;
                    model.fileAttributeDic = [fileManager attributesOfItemAtPath:imgPath error:nil];
                    [self.mArr_accessory addObject:model];
                    
                    break;
                }
            }
        }else {//存在
            BOOL blDele= [fileManager removeItemAtPath:imgPath error:nil];//先删除
            if (blDele) {//删除成功后，写入，通知界面
                BOOL result = [imageData writeToFile:imgPath atomically:YES];
                for (;;) {
                    if (result) {
                        model.mStr_name= [NSString stringWithFormat:@"%@.png",timeSp];
                        model.pathStr = imgPath;
                        model.fileAttributeDic = [fileManager attributesOfItemAtPath:imgPath error:nil];
                        [self.mArr_accessory addObject:model];
                        
                        break;
                    }
                }
            }
        }
        [self.mArr_accessory addObject:model];
    }
    
    if([lastChosenMediaType isEqual:(NSString *) kUTTypeMovie])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示信息!" message:@"系统只支持图片格式" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        
    }
    //添加显示附件
    [self addAccessoryPhoto];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

@end

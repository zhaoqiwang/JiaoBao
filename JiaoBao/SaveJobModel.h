//
//  SaveJobModel.h
//  JiaoBao
//
//  Created by Zqw on 15/10/22.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SaveClassModel;

@interface SaveJobModel : NSManagedObject

@property (nonatomic, retain) NSString * additional;
@property (nonatomic, retain) NSString * additionalDes;
@property (nonatomic, retain) NSString * allNum;
@property (nonatomic, retain) NSString * chapterID;
@property (nonatomic, retain) NSString * chapterName;
@property (nonatomic, retain) NSString * classID;
@property (nonatomic, retain) NSString * classNam;
@property (nonatomic, retain) NSString * desId;
@property (nonatomic, retain) NSString * distribution;
@property (nonatomic, retain) NSString * doLv;
@property (nonatomic, retain) NSString * expTime;
@property (nonatomic, retain) NSString * gradeCode;
@property (nonatomic, retain) NSString * gradeName;
@property (nonatomic, retain) NSString * homeworkName;
@property (nonatomic, retain) NSString * hwType;
@property (nonatomic, retain) NSString * inpNum;
@property (nonatomic, retain) NSNumber * isAnSms;
@property (nonatomic, retain) NSNumber * isQsSms;
@property (nonatomic, retain) NSNumber * isRep;
@property (nonatomic, retain) NSString * longTime;
@property (nonatomic, retain) NSNumber * modeSlection;
@property (nonatomic, retain) NSString * schoolName;
@property (nonatomic, retain) NSString * selNum;
@property (nonatomic, retain) NSString * subjectID;
@property (nonatomic, retain) NSString * subjectName;
@property (nonatomic, retain) NSString * teacherJiaobaohao;
@property (nonatomic, retain) NSString * tecName;
@property (nonatomic, retain) NSString * versionID;
@property (nonatomic, retain) NSString * versionName;
@property (nonatomic, retain) NSSet *saveClass;
@end

@interface SaveJobModel (CoreDataGeneratedAccessors)

- (void)addSaveClassObject:(SaveClassModel *)value;
- (void)removeSaveClassObject:(SaveClassModel *)value;
- (void)addSaveClass:(NSSet *)values;
- (void)removeSaveClass:(NSSet *)values;

@end

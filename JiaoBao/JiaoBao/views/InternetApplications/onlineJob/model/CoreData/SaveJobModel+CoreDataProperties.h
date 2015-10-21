//
//  SaveJobModel+CoreDataProperties.h
//  JiaoBao
//
//  Created by songyanming on 15/10/21.
//  Copyright © 2015年 JSY. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SaveJobModel.h"
#import "SaveClassModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SaveJobModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *additional;
@property (nullable, nonatomic, retain) NSString *additionalDes;
@property (nullable, nonatomic, retain) NSString *allNum;
@property (nullable, nonatomic, retain) NSString *chapterID;
@property (nullable, nonatomic, retain) NSString *chapterName;
@property (nullable, nonatomic, retain) NSString *classID;
@property (nullable, nonatomic, retain) NSString *classNam;
@property (nullable, nonatomic, retain) NSString *desId;
@property (nullable, nonatomic, retain) NSString *distribution;
@property (nullable, nonatomic, retain) NSString *doLv;
@property (nullable, nonatomic, retain) NSString *expTime;
@property (nullable, nonatomic, retain) NSString *gradeCode;
@property (nullable, nonatomic, retain) NSString *gradeName;
@property (nullable, nonatomic, retain) NSString *homeworkName;
@property (nullable, nonatomic, retain) NSString *hwType;
@property (nullable, nonatomic, retain) NSString *inpNum;
@property (nullable, nonatomic, retain) NSNumber *isAnSms;
@property (nullable, nonatomic, retain) NSNumber *isQsSms;
@property (nullable, nonatomic, retain) NSNumber *isRep;
@property (nullable, nonatomic, retain) NSString *longTime;
@property (nullable, nonatomic, retain) NSNumber *modeSlection;
@property (nullable, nonatomic, retain) NSString *schoolName;
@property (nullable, nonatomic, retain) NSString *selNum;
@property (nullable, nonatomic, retain) NSString *subjectID;
@property (nullable, nonatomic, retain) NSString *subjectName;
@property (nullable, nonatomic, retain) NSString *teacherJiaobaohao;
@property (nullable, nonatomic, retain) NSString *tecName;
@property (nullable, nonatomic, retain) NSString *versionID;
@property (nullable, nonatomic, retain) NSString *versionName;
@property (nullable, nonatomic, retain) NSSet<SaveClassModel *> *saveClass;

@end

@interface SaveJobModel (CoreDataGeneratedAccessors)

- (void)addSaveClassObject:(SaveClassModel *)value;
- (void)removeSaveClassObject:(SaveClassModel *)value;
- (void)addSaveClass:(NSSet<SaveClassModel *> *)values;
- (void)removeSaveClass:(NSSet<SaveClassModel *> *)values;

@end

NS_ASSUME_NONNULL_END

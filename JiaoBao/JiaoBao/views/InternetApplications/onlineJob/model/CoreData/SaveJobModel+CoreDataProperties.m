//
//  SaveJobModel+CoreDataProperties.m
//  JiaoBao
//
//  Created by songyanming on 15/10/21.
//  Copyright © 2015年 JSY. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SaveJobModel+CoreDataProperties.h"

@implementation SaveJobModel (CoreDataProperties)

@dynamic additional;
@dynamic additionalDes;
@dynamic allNum;
@dynamic chapterID;
@dynamic chapterName;
@dynamic classID;
@dynamic classNam;
@dynamic desId;
@dynamic distribution;
@dynamic doLv;
@dynamic expTime;
@dynamic gradeCode;
@dynamic gradeName;
@dynamic homeworkName;
@dynamic hwType;
@dynamic inpNum;
@dynamic isAnSms;
@dynamic isQsSms;
@dynamic isRep;
@dynamic longTime;
@dynamic modeSlection;
@dynamic schoolName;
@dynamic selNum;
@dynamic subjectID;
@dynamic subjectName;
@dynamic teacherJiaobaohao;
@dynamic tecName;
@dynamic versionID;
@dynamic versionName;
@dynamic saveClass;
-(void)addSaveClassObject:(SaveClassModel *)value
{
    NSMutableOrderedSet *saveClass = [self.saveClass mutableCopy];
    [saveClass addObject:value];
    self.saveClass = [saveClass copy];

    
}

@end

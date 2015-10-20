//
//  JobModel+CoreDataProperties.h
//  JiaoBao
//
//  Created by songyanming on 15/10/19.
//  Copyright © 2015年 JSY. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "JobModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JobModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *modeSelection;
@property (nullable, nonatomic, retain) NSString *classSelection;
@property (nullable, nonatomic, retain) NSString *gradeSelection;
@property (nullable, nonatomic, retain) NSString *subjectSelection;
@property (nullable, nonatomic, retain) NSString *versionSection;
@property (nullable, nonatomic, retain) NSString *chapterSelection;
@property (nullable, nonatomic, retain) NSString *difficultySelection;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *deadline;
@property (nullable, nonatomic, retain) NSString *jobDuration;

@end

NS_ASSUME_NONNULL_END

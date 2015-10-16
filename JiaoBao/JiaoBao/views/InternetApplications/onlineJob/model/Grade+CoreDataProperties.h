//
//  Grade+CoreDataProperties.h
//  JiaoBao
//
//  Created by songyanming on 15/10/16.
//  Copyright © 2015年 JSY. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Grade.h"

NS_ASSUME_NONNULL_BEGIN

@interface Grade (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *tabIDStr;
@property (nullable, nonatomic, retain) NSString *tabID;
@property (nullable, nonatomic, retain) NSString *gradeCode;
@property (nullable, nonatomic, retain) NSString *gradeName;
@property (nullable, nonatomic, retain) NSString *isEnable;
@property (nullable, nonatomic, retain) NSString *orderby;

@end

NS_ASSUME_NONNULL_END

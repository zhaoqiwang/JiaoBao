//
//  SaveClassModel+CoreDataProperties.h
//  JiaoBao
//
//  Created by songyanming on 15/10/21.
//  Copyright © 2015年 JSY. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SaveClassModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SaveClassModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *classID;
@property (nullable, nonatomic, retain) NSString *classNam;
@property (nullable, nonatomic, retain) NSNumber *doLv;
@property (nullable, nonatomic, retain) SaveJobModel *owner;

@end

NS_ASSUME_NONNULL_END

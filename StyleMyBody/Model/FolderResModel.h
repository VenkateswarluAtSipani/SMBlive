//
//  FolderResModel.h
//  StyleMyBody
//
//  Created by sipani online on 5/10/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FolderCategoryModel.h"

@interface FolderResModel : NSObject
@property (nonatomic, strong) NSNumber *folderId;
@property (nonatomic, strong) NSString *folderName;
@property (nonatomic, strong) FolderCategoryModel *folderCatModel;
@property (nonatomic, strong) NSArray *servicesArr; // ServiceResModel
@property (nonatomic, assign) BOOL isFolderEpanded;


@end

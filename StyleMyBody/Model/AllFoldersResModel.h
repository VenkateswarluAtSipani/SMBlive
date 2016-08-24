//
//  AllFoldersResModel.h
//  StyleMyBody
//
//  Created by sipani online on 5/10/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FolderResModel.h"

@interface AllFoldersResModel : NSObject

@property (nonatomic, strong) NSArray * foldersModelArr; //FolderResModel
@property (nonatomic, strong) NSArray * notMappedServicesArr; //ServiceResModel

@end

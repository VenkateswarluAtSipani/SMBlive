//
//  SearchAndFilterModel.h
//  StyleMyBody
//
//  Created by sipani online on 28/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchAndFilterModel : NSObject

@property(nonatomic,strong)NSNumber* categoryId;
@property(nonatomic,strong)NSNumber* Id;
@property(nonatomic,strong)NSString* search	;
@property(nonatomic,strong)NSNumber* type;

@property (nonatomic, strong) NSNumber *serveFor;
@property (nonatomic, strong) NSNumber *preference;
@property (nonatomic, strong) NSNumber *minPrice;
@property (nonatomic, strong) NSNumber *maxPrice;

@end

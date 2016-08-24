//
//  OfferDetailViewController.h
//  StyleMyBody
//
//  Created by sipani online on 5/25/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceResModel.h"

@interface OfferDetailViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *headerTitleLbl;
@property (nonatomic, strong) ServiceResModel *serviceModel;

@end

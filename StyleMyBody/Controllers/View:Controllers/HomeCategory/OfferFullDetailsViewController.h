//
//  OfferFullDetailsViewController.h
//  StyleMyBody
//
//  Created by sipani online on 5/29/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OffersListResModel.h"

@interface OfferFullDetailsViewController : UIViewController

@property (nonatomic, strong) OffersListResModel *offerDetailmodel;
@property (nonatomic,strong)NSNumber *offerId;
@property (nonatomic,strong)NSString *offerType;
- (IBAction)backBtnAction:(id)sender;
@property (nonatomic, strong) NSNumber *centerId;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end

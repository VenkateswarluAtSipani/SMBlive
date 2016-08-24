//
//  InternetBankingVC.h
//  StyleMyBody
//
//  Created by sipani online on 08/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InternetBankingVC : UIViewController{
    
    __weak IBOutlet NSLayoutConstraint *heightofTV;
    __weak IBOutlet NSLayoutConstraint *bottomspaceofTV;
}
@property (weak, nonatomic) IBOutlet UIButton *btn;
- (IBAction)dropclick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSDictionary *bookingInfo;


@end

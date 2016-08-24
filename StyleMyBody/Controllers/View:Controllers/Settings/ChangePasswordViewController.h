//
//  ChangePasswordViewController.h
//  StyleMyBody
//
//  Created by sipani online on 01/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController
- (IBAction)saveBTN:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *oldpasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *newpasswordTF;





@end

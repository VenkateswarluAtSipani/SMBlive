//
//  ViewController.h
//  StyleMyBody
//
//  Created by sipani online on 4/11/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    
  
     __weak IBOutlet UIView *MenuItemContainerView;
    
    __weak IBOutlet UIView *menuItemTitleView;
    
    __weak IBOutlet UILabel *menuItemTitleLbl;
}
@property (weak, nonatomic) IBOutlet UIButton *locationBTN;


@end


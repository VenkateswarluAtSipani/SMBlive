//
//  PaymentView.h
//  StyleMyBody
//
//  Created by K venkateswarlu on 08/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentView : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    __weak IBOutlet UILabel *amountLbl;
}
@property (nonatomic,strong)NSDictionary *bookingIdDict;
@end

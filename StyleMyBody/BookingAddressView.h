//
//  BookingAddressView.h
//  StyleMyBody
//
//  Created by K venkateswarlu on 08/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressListModel.h"

@interface BookingAddressView : UIViewController
{
    
    __weak IBOutlet UITextField *tagTxt;
    __weak IBOutlet UITextField *address1Txt;
    __weak IBOutlet UITextField *address2Txt;
    __weak IBOutlet UITextField *cityTxt;
    __weak IBOutlet UITextField *stateTxt;
    __weak IBOutlet UITextField *zipTxt;
}
@property(nonatomic,strong)AddressListModel *addressListModel;

@end

//
//  FilterView.h
//  StyleMyBody
//
//  Created by sipani online on 28/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchAndFilterModel.h"
@interface FilterView : UIViewController{
    

    
    __weak IBOutlet UIButton *maleBtn;
    __weak IBOutlet UIButton *femaleBtn;
    __weak IBOutlet UIButton *uniSexBtn;
    
    __weak IBOutlet UIButton *ratedBtn;
    __weak IBOutlet UIButton *favoriteBtn;
    __weak IBOutlet UIButton *homeServiceBtn;
    
 
    __weak IBOutlet NSLayoutConstraint *heightOfSearchTbl;
    
    
    __weak IBOutlet UILabel *filterCountLbl;
}
- (IBAction)filterBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceOfSubmit;
- (IBAction)sexAction:(id)sender;
- (IBAction)PreferencesAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTbl;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak)  SearchAndFilterModel *searchAndFilterModel;
@end

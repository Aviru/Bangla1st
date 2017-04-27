//
//  Cell_Header.h
//  Bangla 1st
//
//  Created by Abhijit Rana on 18/03/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARButton.h"

@interface Cell_Header : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblHeadertitle;
@property (weak, nonatomic) IBOutlet ARButton *btnMore;

@end

//
//  VideoDetailsVC.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 17/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "BaseVC.h"
#import "ModelList.h"

@interface VideoDetailsVC : BaseVC

@property(nonatomic,strong)ModelList *objModelList;

@property(nonatomic,assign)BOOL isFromListVC;

@end

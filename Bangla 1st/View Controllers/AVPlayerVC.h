//
//  AVPlayerVC.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 17/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <AVKit/AVKit.h>

@interface AVPlayerVC : AVPlayerViewController

@property(nonatomic,strong)AVPlayerViewController *avPlayerVC;

@property(nonatomic,assign)BOOL isFromListVC;

@property(nonatomic,strong)NSString *strVideoURL;
@property(nonatomic,strong)NSString *strIMAAddURL;

@end

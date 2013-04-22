//
//  GameDetailViewController.h
//  GameCX
//
//  Created by Mathias on 14/3/13.
//  Copyright (c) 2013 Mathias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UIImageView+WebCache.h"

@interface GameDetailViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *gameLabel;
@property (nonatomic, strong) IBOutlet UILabel *gameSubtitleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *gameImageView;



@property (nonatomic, strong) NSString *gameName;
@property (nonatomic, strong) NSString *gameSubtitle;
@property  NSURL *gameImageURL;

@end


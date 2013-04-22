//
//  GameViewController.h
//  GameCX
//
//  Created by Mathias on 14/3/13.
//  Copyright (c) 2013 Mathias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface GameViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *gameTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *SearchBar;

@end

//
//  GameViewController.m
//  GameCX
//
//  Created by Mathias on 14/3/13.
//  Copyright (c) 2013 Mathias. All rights reserved.
//

#import "GameViewController.h"
#import "GameDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface GameViewController ()

@end

@implementation GameViewController{
    NSMutableArray *totalStrings;
    NSMutableArray *filteredStrings;
    
    
    NSMutableArray *subtitle;
    NSMutableArray *thumbnails;
    
    BOOL isFiltered;
}
    
@synthesize gameTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.SearchBar.delegate =self;
    self.gameTableView.delegate = self;
    self.gameTableView.dataSource=self;
  
    //This tells the table cell not to show the separator as our own cell images already come with the separator.
    [self.gameTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //Styling the Table View Background
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    self.gameTableView.backgroundColor = [UIColor clearColor];
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.gameTableView.contentInset = inset;

 [self retrieveFromParse];    
    
}

- (void) retrieveFromParse {
    PFQuery *retrieveGames = [PFQuery queryWithClassName:@"gameFX"];
    //  [retrievePets  whereKeyExists:@"name"];
    
    [retrieveGames findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"%@", objects);
            totalStrings = [[NSMutableArray alloc] initWithArray:objects];
            
        }
        [self.gameTableView reloadData];
    }];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *) searchText{
    if (searchText.length ==0)
        isFiltered =NO;
    else {
        isFiltered =YES;
        
        
        filteredStrings=[[NSMutableArray alloc]init];
        
        //convert PFObject ---> NSString
        
        for(PFObject *element in totalStrings){
            NSString *str = [element objectForKey:@"name"]; //totalStrings --->NSString
            
            NSLog(@"%@", NSStringFromClass([element class]));
            
            NSRange stringRange =[str rangeOfString:searchText options:NSCaseInsensitiveSearch]; //Searching gametitle text
            
            if (stringRange.location !=NSNotFound) {
                [filteredStrings addObject:element]; //Add the PFObject back to make cellForRowAtIndexPath method
            }
        }
    }
    
    [self.gameTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section
{
    return  (isFiltered) ? [filteredStrings count] : [totalStrings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"GameTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    //Get tempObject using ternary operator to determine which array to get tempObject from
    PFObject *tempObject = (!isFiltered) ? [totalStrings objectAtIndex:indexPath.row] : [filteredStrings objectAtIndex:indexPath.row];
    //Game Title
    UILabel *gameTableLabel = (UILabel *)[cell viewWithTag:101];
    gameTableLabel.text = [tempObject objectForKey:@"name"];
        
    UILabel *gameTableLabel2 = (UILabel *)[cell viewWithTag:102];
    gameTableLabel2.text = [tempObject objectForKey:@"subtitle"];
        
        
    //Game Image
    /*
    PFFile *theImage = [tempObject objectForKey:@"image"];
    NSData *imageData = [theImage getData];
    UIImage *image = [UIImage imageWithData:imageData];
    UIImageView *gameTableImageView = (UIImageView *)[cell viewWithTag:100];
    gameTableImageView.image = image;*/

    PFFile *theImage = [tempObject objectForKey:@"image"];
    NSURL *url=[NSURL URLWithString:theImage.url];
    UIImageView *gameTableImageView = (UIImageView *)[cell viewWithTag:100];
    gameTableImageView.image=nil;
    [gameTableImageView setImageWithURL:url];
    
    
    // Assign our own background image for the cell
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    
    return cell;
}
//Add create the “cellBackgroundForRowAtIndexPath:” method to determine the background image to assign.
- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:[self gameTableView] numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top.png"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    
    return background;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"gameDetailSegue"]) {
        
        //Cleaned up code - Read comments to see what I changed
        
        //Setting the indexPath and destViewController was the same in both IF statments
        //so moved outside
        NSIndexPath *indexPath = [self.gameTableView indexPathForSelectedRow];
        GameDetailViewController *destViewController = segue.destinationViewController;
        
        //Use of ternary operator to create PFObject based on isFiltered
        //Removes need of an IF statement
        PFObject *tempObject = (isFiltered) ? [filteredStrings objectAtIndex: indexPath.row] : [totalStrings objectAtIndex:indexPath.row];
        destViewController.gameName = [tempObject objectForKey:@"name"];
        destViewController.gameSubtitle = [tempObject objectForKey:@"subtitle"];
        
        PFFile *theImage = [tempObject objectForKey:@"image"];
         //   NSData *imageData = [theImage getData];
          //  UIImage *image = [UIImage imageWithData:imageData];
          //  destViewController.gameImage = image;
        
        /* Previously you wrote:
            [destViewController.gameImageView setImageWithURL:[NSURL URLWithString:theImage.url]];
         This doesn't work because:
            • You need destViewController as a property to set it's properties in this way
            • You can't set the property of a property in this way
                ie. the "image" property of the "gameImageView"
         
         I have created a new property, "gameImageURL", and created and passed a URL through.
         See code in the GameDetailViewController to see what's changed
         */
        
        destViewController.gameImageURL = [NSURL URLWithString:theImage.url];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

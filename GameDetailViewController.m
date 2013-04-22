//
//  GameDetailViewController.m
//  GameCX
//
//  Created by Mathias on 14/3/13.
//  Copyright (c) 2013 Mathias. All rights reserved.
//

#import "GameDetailViewController.h"

@interface GameDetailViewController ()

@end

@implementation GameDetailViewController

@synthesize gameLabel, gameSubtitleLabel, gameImageView;
@synthesize gameName, gameSubtitle, gameImageURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    gameLabel.text = gameName;
    gameSubtitleLabel.text = gameSubtitle;
    
    /* Basically set the image - as you were doing before.
     You'll be happy to know you won't be needing to do any GDC code (from your other question)
     as the ImageView class takes care of that for you and it shouldn't lag.
     
     If you would like to use GDC in the future (maybe you're loading
     lots of text or something) below is some example code of how to load
     a big text file from a URL via dispatch_async and then set it to a textView
     via dispatch_sync - hope this helps :)
     */
    
    [gameImageView setImageWithURL:gameImageURL];
    
    /* START EXAMPLE GDC CODE - UNCOMMENT TO SEE WITH SYNTAX
     
    //Here we start the background loading
    dispatch_async(dispatch_queue_create("LoadTxt", NULL), ^{
        NSError *error;
        //Here we load the text
        NSString *text = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:self.textURL]
                                                        encoding:NSUTF8StringEncoding
                                                           error:&error];
        //We've got the text now, got back to foreground
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (error) NSLog(@"Something went wrong: %@",error);
            else body.text = text;
            //We've now successfully set the text
        });
    });
    END EXAMPLE GDC CODE*/
    
    [self.view addSubview:gameImageView];

  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

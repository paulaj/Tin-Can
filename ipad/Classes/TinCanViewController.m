//
//  TinCanViewController.m
//  TinCan
//
//  Created by Drew Harry on 5/10/10.
//  Copyright MIT Media Lab 2010. All rights reserved.
//

#import "TinCanViewController.h"
#import "ParticipantView.h"

@implementation TinCanViewController




#pragma mark Application Events

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {    
    // TODO I don't like having to hardcode the frame here - worried about rotation and 
    // portability / scalability if resolutions change in the future.
    self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)] retain];
    
    // Create the participants view.
    participantsContainer = [[UIView alloc] initWithFrame:self.view.frame];
    [participantsContainer retain];
    [self.view addSubview:participantsContainer];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self initParticipantsView];
    
    NSLog(@"Done loading view.");
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];    
    NSLog(@"viewDidLoad");
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
    [self.view release];
    [participants release];
    
}




#pragma mark Internal Methods

- (void)initParticipantsView {
    
    participants = [[NSMutableSet set] retain];
    // For now, hard code these. 
    [participants addObject:[[ParticipantView alloc] initWithName:@"MATT" withPosition:CGPointMake(400, 1050) withRotation:0.0]];
    [participants addObject:[[ParticipantView alloc] initWithName:@"DREW" withPosition:CGPointMake(-30, 512) withRotation:M_PI/2]];
    [participants addObject:[[ParticipantView alloc] initWithName:@"CHRIS" withPosition:CGPointMake(798, 512) withRotation:-M_PI/2]];
    
    for(ParticipantView *participant in participants) {
        
        [participantsContainer addSubview:participant];
        [participantsContainer bringSubviewToFront:participant];
        [participant setNeedsDisplay];
    }
}




@end

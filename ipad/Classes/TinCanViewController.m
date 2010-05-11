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
    
    
    // Now, drop the MeetingTimer in the middle of the screen.
    meetingTimerView = [[MeetingTimerView alloc] initWithFrame:CGRectMake(200, 200, 75, 600)];
    [meetingTimerView retain];
    
    [self.view addSubview:meetingTimerView];
    
    NSLog(@"Done loading view.");
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];    
    
    // Kick off the timer.
    clock = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(clk) userInfo:nil repeats:YES];
    [clock retain];
    
    NSLog(@"viewDidLoad");
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    [participantsContainer release];
    participantsContainer = nil;
    
    [meetingTimerView release];
    meetingTimerView = nil;
}


- (void)dealloc {
    [super dealloc];
    [self.view release];
    [participants release];
    
    [clock invalidate];
    [clock release];
}




#pragma mark Internal Methods

- (void)clk {
    [meetingTimerView setNeedsDisplay];
}   

- (void)initParticipantsView {
    
    participants = [[NSMutableSet set] retain];
    
    // For now, hard code these. Eventually, these will get pulled from the server.
    // We'll also want to the layout quite a bit more - right now we're having to
    // hardcode both the rotation and the actual positions. That's a post
    // sponsor week TODO, though.
    [participants addObject:[[ParticipantView alloc] initWithName:@"MATT" withPosition:CGPointMake(256, 1060) withRotation:0.0 withColor:[UIColor redColor]]];
    [participants addObject:[[ParticipantView alloc] initWithName:@"ANDREA" withPosition:CGPointMake(512, 1060) withRotation:0.0 withColor:[UIColor redColor]]];
    
    [participants addObject:[[ParticipantView alloc] initWithName:@"JAEWOO" withPosition:CGPointMake(-30, 256) withRotation:M_PI/2 withColor:[UIColor redColor]]];
    [participants addObject:[[ParticipantView alloc] initWithName:@"CHARLIE" withPosition:CGPointMake(-30, 512) withRotation:M_PI/2 withColor:[UIColor redColor]]];
    [participants addObject:[[ParticipantView alloc] initWithName:@"TREVOR" withPosition:CGPointMake(-30, 768) withRotation:M_PI/2 withColor:[UIColor yellowColor]]];

    [participants addObject:[[ParticipantView alloc] initWithName:@"CHRIS" withPosition:CGPointMake(798, 256) withRotation:-M_PI/2 withColor:[UIColor yellowColor]]];
    [participants addObject:[[ParticipantView alloc] initWithName:@"DREW" withPosition:CGPointMake(798, 512) withRotation:-M_PI/2 withColor:[UIColor greenColor]]];
    [participants addObject:[[ParticipantView alloc] initWithName:@"IG-JAE" withPosition:CGPointMake(798, 768) withRotation:-M_PI/2 withColor:[UIColor blueColor]]];

    [participants addObject:[[ParticipantView alloc] initWithName:@"DORI" withPosition:CGPointMake(256, -20) withRotation:M_PI withColor:[UIColor blueColor]]];
    [participants addObject:[[ParticipantView alloc] initWithName:@"PAULINA" withPosition:CGPointMake(512, -20) withRotation:M_PI withColor:[UIColor blueColor]]];

    
    for(ParticipantView *participant in participants) {
        
        [participantsContainer addSubview:participant];
        [participantsContainer bringSubviewToFront:participant];
        [participant setNeedsDisplay];
    }
}




@end

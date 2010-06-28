//
//  UITableTestViewController.m
//  UITableTest
//
//  Created by Drew Harry on 6/18/10.
//  Copyright MIT Media Lab 2010. All rights reserved.
//

#import "UITableTestViewController.h"
#import "UITableTestCell.h"

@implementation UITableTestViewController

@synthesize nameList;

#define ROW_HEIGHT 60

//- (id)initWithFrame:(CGRect)frame {
	//if (self = [super initWithFrame:frame]) {
	//	self.title = @"My Awesome Test Table";
		//self.frame=CGRectMake(0, 0, 100, 500);
//		self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//		self.tableView.rowHeight = ROW_HEIGHT;
       // self.nameList = [NSMutableArray array];
	//}
	//return self;
//}
//


- (void)loadView {
    // allocate the subclassed UIView, and set it as the UIViewController's main view
    self.view = [[[UITableView alloc] initWithFrame:CGRectMake(200, 200, 320, 460) style:UITableViewStylePlain] autorelease];
	[(UITableView *)self.view setDelegate:self];
	[(UITableView *)self.view setDataSource:self];
	
	[self.view setBackgroundColor:[UIColor blackColor]];

	
	self.nameList = [NSMutableArray array];
	[nameList addObject:@"Drew"];
    [nameList addObject:@"Stephanie"];
    [nameList addObject:@"Ariel"];
    [nameList addObject:@"Paula"];
	[nameList addObject:@"OMG"];
	[nameList addObject:@"This"];
	[nameList addObject:@"Actually"];
	[nameList addObject:@"Works"];
	NSLog(@":%@", self.nameList);
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic -- create and push a new view controller
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
   [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// There is only one section.
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.nameList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    NSLog(@"Got tableView call");
    
    static NSString *CellIdentifier = @"UITableTestCell";
    
	UITableTestCell *testCell = (UITableTestCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(testCell==nil) {
        testCell = [[[UITableTestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        testCell.frame = CGRectMake(0.0, 0.0, 320.0, ROW_HEIGHT);
    }
    
    NSString *name = [nameList objectAtIndex:indexPath.row];
	testCell.name = name;
 	
    return testCell;
}
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

@end

//
//  YMColorPickerViewController.m
//  YMColorPickerKit
//
//  Created by 林 亮太 on 12/06/24.
//  Copyright (c) 2012 Hayashi Ryota. All rights reserved.
//

#import "YMColorPickerViewController.h"
#import "YMColorPickerView.h"

@implementation YMColorPickerViewController

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    YMColorPickerView* colorPickerView = [[YMColorPickerView alloc] init];
    self.view  = colorPickerView;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

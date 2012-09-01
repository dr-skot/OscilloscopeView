//
//  ViewController.m
//  OscilloscopeView
//
//  Created by Scott Shepherd on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "OscilloscopeView.h"

@interface ViewController ()
@property (strong, nonatomic) OscilloscopeView *tdView;
@end

@implementation ViewController
@synthesize tdView;

- (void)dealloc
{
  self.tdView = nil;
  [super dealloc];
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  tdView = [[OscilloscopeView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:tdView];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  ringBuffer = new RingBuffer(32768, 2); 
  audioManager = [Novocaine audioManager];
  
  [audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
   {
     [tdView refreshWithData:data numFrames:numFrames numChannels:numChannels];
   }];
  
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
    return YES;
  }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
  NSLog(@"rotated");
  tdView.frame = self.view.bounds;
}

@end

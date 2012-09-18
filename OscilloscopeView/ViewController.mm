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
@property (strong, nonatomic) OscilloscopeView *oscilloscopeView;
@end

@implementation ViewController
@synthesize oscilloscopeView = _oscilloscopeView;

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.view.backgroundColor = UIColor.blackColor;

  _oscilloscopeView = [[OscilloscopeView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:self.oscilloscopeView];
}

- (void)viewDidUnload
{
  self.oscilloscopeView = nil;
  [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.oscilloscopeView start];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [self.oscilloscopeView start];
  [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
    return YES;
  }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  CGRect rect = self.view.bounds;
  rect.size.width = self.view.bounds.size.height;
  rect.size.height = self.view.bounds.size.width;
  self.oscilloscopeView.frame = rect;
  [self.oscilloscopeView setNeedsDisplay];
}


@end

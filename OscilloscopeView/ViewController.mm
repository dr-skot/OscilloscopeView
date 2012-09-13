//
//  ViewController.m
//  OscilloscopeView
//
//  Created by Scott Shepherd on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "OscilloscopePath.h"
#import "OscilloscopeView.h"

@interface ViewController ()
@property (strong, nonatomic) OscilloscopePath *pathMaker;
@property (strong, nonatomic) OscilloscopeView *oscilloscopeView;
@end

@implementation ViewController
@synthesize pathMaker = _pathMaker;
@synthesize oscilloscopeView = _oscilloscopeView;

- (void)dealloc
{
  self.pathMaker = nil;
  self.oscilloscopeView = nil;
  [super dealloc];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = UIColor.blackColor;
  
  self.oscilloscopeView = [[OscilloscopeView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:self.oscilloscopeView];
  [self.oscilloscopeView release]; // because it got overretained when assigned  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  ringBuffer = new RingBuffer(32768, 2); 
  audioManager = [Novocaine audioManager];
  audioManager.samplingRate = 16000;
  audioManager.numInputChannels = 1;

  int framesPerSample = 512;
  float *frameBuffer = new float[framesPerSample * sizeof(float)];
  
  [audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
   {
     ringBuffer->AddNewInterleavedFloatData(data, numFrames, numChannels);
     if (ringBuffer->NumUnreadFrames() >= framesPerSample) {
       ringBuffer->FetchData(frameBuffer, framesPerSample, 0, 1);
       [self.oscilloscopeView refreshWithData:frameBuffer numFrames:framesPerSample numChannels:1];
       //[self performSelectorOnMainThread:@selector(changeWave) withObject:nil waitUntilDone:NO];
     }
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
  self.pathMaker.size = self.view.bounds.size;
}

@end

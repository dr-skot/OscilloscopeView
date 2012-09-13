//
//  ViewController.m
//  OscilloscopeView
//
//  Created by Scott Shepherd on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "OscilloscopePath.h"

@interface ViewController ()
@property (strong, nonatomic) OscilloscopePath *pathMaker;
@end

@implementation ViewController
@synthesize pathMaker = _pathMaker;

- (void)dealloc
{
  self.pathMaker = nil;
  [super dealloc];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = UIColor.blackColor;

  self.pathMaker = [[OscilloscopePath alloc] initWithSize:self.view.bounds.size];
  
  oscilloscope = [CAShapeLayer layer];
  [oscilloscope setStrokeColor:UIColor.greenColor.CGColor];
  [oscilloscope setFillColor:UIColor.clearColor.CGColor];
  [oscilloscope setLineWidth:2];
  
  [self.view.layer addSublayer:oscilloscope];
  oscilloscope.frame = self.view.bounds;
  
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
  audioManager.samplingRate = 16000;
  audioManager.numInputChannels = 1;

  int framesPerSample = 512;
  float *frameBuffer = new float[framesPerSample * sizeof(float)];
  
  [audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
   {
     ringBuffer->AddNewInterleavedFloatData(data, numFrames, numChannels);
     if (ringBuffer->NumUnreadFrames() >= framesPerSample) {
       ringBuffer->FetchData(frameBuffer, framesPerSample, 0, 1);
       [self.pathMaker setData:frameBuffer numFrames:framesPerSample numChannels:1];
       [self performSelectorOnMainThread:@selector(changeWave) withObject:nil waitUntilDone:NO];
     }
   }];
  
}

- (void)changeWave
{
  oscilloscope.path = self.pathMaker.path;
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

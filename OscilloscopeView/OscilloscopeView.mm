//
//  OscilloscopeView.m
//  OscilloscopeView
//
//  Created by Scott Shepherd on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OscilloscopeView.h"
#import "Novocaine.h"
#import "RingBuffer.h"

@interface OscilloscopeView ()
@property (nonatomic) float *data;
@property (nonatomic) UInt32 numFrames;
@property (nonatomic) UInt32 numChannels;
@property (assign, nonatomic) Novocaine *audioManager;
@property (nonatomic) RingBuffer *ringBuffer;
@property (nonatomic) int framesPerSample;
@property (nonatomic) float *frameBuffer;
@end

@implementation OscilloscopeView

@synthesize color = _color;
@synthesize thickness = _thickness;
@synthesize stride = _stride;

@synthesize data = _data;
@synthesize numFrames = _numFrames;
@synthesize numChannels = _numChannels;
@synthesize audioManager = _audioManager;
@synthesize ringBuffer = _ringBuffer;

@synthesize frameBuffer = _frameBuffer;
@synthesize framesPerSample = _framesPerSample;

- (void)dealloc
{
  free(self.frameBuffer);
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.color = [UIColor greenColor];
    self.thickness = 2.0;
    self.stride = 1.0;

    self.audioManager = [Novocaine audioManager];
    self.audioManager.samplingRate = 16000;
    self.audioManager.numInputChannels = 1;
    
    self.ringBuffer = new RingBuffer(32768, 2); 
    self.framesPerSample = 5120;
    self.frameBuffer = new float[self.framesPerSample * sizeof(float)];
  }
  return self;
}

- (void)start
{
  int framesPerSample = self.framesPerSample;
  float *frameBuffer = self.frameBuffer;
  
  self.audioManager.inputBlock = ^(float *data, UInt32 numFrames, UInt32 numChannels)
   {
     self.ringBuffer->AddNewInterleavedFloatData(data, numFrames, numChannels);
     if (self.ringBuffer->NumUnreadFrames() >= framesPerSample) {
       self.ringBuffer->FetchData(frameBuffer, framesPerSample, 0, 1);
       [self refreshWithData:frameBuffer numFrames:framesPerSample numChannels:1];
     }
   };
}

- (void)stop
{
  self.audioManager.inputBlock = nil;
}

- (void)refreshWithData:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels
{
  self.data = data;
  self.numFrames = numFrames;
  self.numChannels = numChannels;
  [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:self waitUntilDone:NO];
}

- (void)drawRect:(CGRect)rect
{
  float w = self.bounds.size.width;
  float h = self.bounds.size.height;
  float h2 = h/2;
  float hScale = h2 / 1.25;
  float wScale = _numFrames / w;
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  CGContextClearRect(ctx, self.bounds);
  
  if (_numFrames > 0) {
    
    // make the path
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0, h2 + _data[0] * hScale);
    for (int t = 1; t < w; t += _stride) {
      CGContextAddLineToPoint(ctx, t, h2 + _data[(int)(t * wScale)*_numChannels] * hScale);
    }

    // stroke it
    CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
    CGContextSetLineWidth(ctx, self.thickness);
    CGContextStrokePath(ctx);
  }
}

@end

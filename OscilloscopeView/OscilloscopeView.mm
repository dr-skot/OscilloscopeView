//
//  OscilloscopeView.m
//  OscilloscopeView
//
//  Created by Scott Shepherd on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OscilloscopeView.h"
#import "Novocaine.h"

// TODO I don't think this has to be .mm anymore

@interface OscilloscopeView ()
@property (nonatomic) float *data;
@property (nonatomic) UInt32 numFrames;
@property (nonatomic) UInt32 numChannels;
@property (assign, nonatomic) Novocaine *audioManager;
- (void)refreshWithData:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels;
@end

@implementation OscilloscopeView

@synthesize color = _color;
@synthesize thickness = _thickness;
@synthesize pixelStride = _pixelStride;

@synthesize data = _data;
@synthesize numFrames = _numFrames;
@synthesize numChannels = _numChannels;
@synthesize audioManager = _audioManager;

@synthesize redrawsPerSec = _redrawsPerSec;

- (void)dealloc
{
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.color = [UIColor greenColor];
    self.thickness = 2.0;
    self.pixelStride = [[UIScreen mainScreen] scale];

    self.audioManager = [Novocaine audioManager];
    self.audioManager.numInputChannels = 1;

    self.redrawsPerSec = 24;
  }
  return self;
}

- (void)start
{ 
  // by observation
  UInt32 framesPerUpdate = 512;
  float dataUpdatesPerSec = (float) self.audioManager.samplingRate / framesPerUpdate;

  int cyclesBeforeDraw = (int) (dataUpdatesPerSec / self.redrawsPerSec);

  __block int bufferSize = cyclesBeforeDraw * framesPerUpdate;
  __block float *buffer = new float[bufferSize];
  __block int bufferIndex = 0;
  self.audioManager.inputBlock = ^(float *data, UInt32 numFrames, UInt32 numChannels)
   {
     if (bufferIndex + numFrames > bufferSize) {
       [self refreshWithData:buffer numFrames:bufferIndex numChannels:numChannels];
       bufferIndex = 0;
     }
     memcpy(buffer + bufferIndex * sizeof(float), data, numFrames * sizeof(float));
     bufferIndex += numFrames;
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
  float w = rect.size.width;
  float h = rect.size.height;
  float h2 = h/2;
  float hScale = h2 / 1.25;
  float wScale = _numFrames / w;
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  CGContextClearRect(ctx, rect);
  
  if (_numFrames > 0) {
    
    NSLog(@"width %f, frames %lu, stride %f", w, _numFrames, _pixelStride);
    
    // make the path
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0, h2 + _data[0] * hScale);
    for (float t = 1; t < w; t += _pixelStride) {
      NSLog(@"point %f, %f", t, h2 + _data[(int)(t * wScale)*_numChannels] * hScale);
      CGContextAddLineToPoint(ctx, t, h2 + _data[(int)(t * wScale)*_numChannels] * hScale);
    }

    // stroke it
    CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
    CGContextSetLineWidth(ctx, self.thickness);
    CGContextStrokePath(ctx);
  }
}

@end

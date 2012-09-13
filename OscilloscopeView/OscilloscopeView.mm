CGMutablePathRef path = CGPathCreateMutable();
//
//  OscilloscopeView.m
//  OscilloscopeView
//
//  Created by Scott Shepherd on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OscilloscopeView.h"

@interface OscilloscopeView ()
@property (nonatomic) float *data;
@property (nonatomic) UInt32 numFrames;
@property (nonatomic) UInt32 numChannels;
@end

@implementation OscilloscopeView

@synthesize bgColor = _bgColor;
@synthesize gridColor = _gridColor;
@synthesize waveColor = _waveColor;

@synthesize data = _data;
@synthesize numFrames = _numFrames;
@synthesize numChannels = _numChannels;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.bgColor = [UIColor blackColor];
    self.gridColor = [UIColor whiteColor];
    self.waveColor = [UIColor greenColor];
  }
  return self;
}

- (void)refreshWithData:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels
{
  self.data = data;
  self.numFrames = numFrames;
  self.numChannels = numChannels;
  [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:self waitUntilDone:NO];
}

- (CGPathRef)path
{
  float w = self.bounds.size.width;
  float h = self.bounds.size.height; 
  float h2 = h/2;
  float hScale = h2 / 1.25;
  float wScale = _numFrames / w;

  CGMutablePathRef path = CGPathCreateMutable();

  float stride = 1;
  if (_numFrames > 0) {
    CGPathMoveToPoint(path, nil, 0, h2 + _data[0] + hScale);
    for (int t = 1; t < w; t += stride) {
      CGPathAddLineToPoint(path, nil, t, h2 + _data[(int)(t * wScale)*_numChannels] * hScale);
    }
  }

  return path;
}

- (void)drawRect:(CGRect)rect
{
  float w = self.bounds.size.width;
  float h = self.bounds.size.height; 
  float h2 = h/2;
  float hScale = h2 / 1.25;
  float wScale = _numFrames / w;
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  // bg
  CGContextSetFillColorWithColor(ctx, _bgColor.CGColor);
  CGContextFillRect(ctx, self.bounds);
  
  if (_gridColor) {
    CGContextSetStrokeColorWithColor(ctx, _gridColor.CGColor);
    CGContextSetLineWidth(ctx, 0.5);
    CGContextBeginPath(ctx);
    for (int t = 0; t < w; t += 20) {
      CGContextMoveToPoint(ctx, t, 0);
      CGContextAddLineToPoint(ctx, t, h);
    }
    for (int y = 0; y < h; y += 20) {
      CGContextMoveToPoint(ctx, 0, y);
      CGContextAddLineToPoint(ctx, w, y);
    }
    CGContextStrokePath(ctx);
  }
  
  CGContextSetStrokeColorWithColor(ctx, _waveColor.CGColor);
  CGContextSetLineWidth(ctx, 2);

  // wave
  float stride = 4;
  if (_numFrames > 0) {
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0, h2 + _data[0] * hScale);
    for (int t = 1; t < w; t += stride) {
      CGContextAddLineToPoint(ctx, t, h2 + _data[(int)(t * wScale)*_numChannels] * hScale);
    }
    CGContextStrokePath(ctx);
  }
}

@end

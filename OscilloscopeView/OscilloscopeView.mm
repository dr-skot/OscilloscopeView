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

@synthesize color = _color;
@synthesize thickness = _thickness;
@synthesize stride = _stride;

@synthesize data = _data;
@synthesize numFrames = _numFrames;
@synthesize numChannels = _numChannels;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.color = [UIColor greenColor];
    self.thickness = 2.0;
    self.stride = 1.0;
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

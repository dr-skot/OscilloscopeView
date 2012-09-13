//
//  OscilloscopePath.m
//  OscilloscopeView
//
//  Created by Scott Shepherd on 9/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OscilloscopePath.h"

@interface OscilloscopePath ()

@property (nonatomic) float *data;
@property (nonatomic) UInt32 numFrames;
@property (nonatomic) UInt32 numChannels;

@end

@implementation OscilloscopePath

@synthesize size = _size;
@synthesize data = _data;
@synthesize numFrames = _numFrames;
@synthesize numChannels = _numChannels;

- (id)initWithSize:(CGSize)size
{
  self = [super init];
  if (self) self.size = size;
  return self;
}

- (void)setData:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels
{
  self.data = data;
  self.numFrames = numFrames;
  self.numChannels = numChannels;
}

// you are responsible for release this path after using it
- (CGPathRef)path
{
  float w = _size.width;
  float h = _size.height; 
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


@end

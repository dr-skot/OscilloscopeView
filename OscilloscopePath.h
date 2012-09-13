//
//  OscilloscopePath.h
//  OscilloscopeView
//
//  Created by Scott Shepherd on 9/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OscilloscopePath : NSObject

@property (nonatomic) CGSize size;
@property (readonly) CGPathRef path;

- (id)initWithSize:(CGSize)size;
- (void)setData:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels;

@end

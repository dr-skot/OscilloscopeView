//
//  OscilloscopeView.h
//  OscilloscopeView
//
//  Created by Scott Shepherd on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OscilloscopeView : UIView

@property (strong, nonatomic) UIColor *color;
@property (nonatomic) float thickness;
@property (nonatomic) float stride;

- (void)refreshWithData:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels;

@end

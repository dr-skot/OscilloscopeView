//
//  OscilloscopeView.h
//  OscilloscopeView
//
//  Created by Scott Shepherd on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OscilloscopeView : UIView

@property (strong, nonatomic) UIColor *bgColor;
@property (strong, nonatomic) UIColor *gridColor;
@property (strong, nonatomic) UIColor *waveColor;

- (void)refreshWithData:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels;

@end

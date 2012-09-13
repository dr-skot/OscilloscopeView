//
//  ViewController.h
//  OscilloscopeView
//
//  Created by Scott Shepherd on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Novocaine.h"
#import "RingBuffer.h"
#import "AudioFileReader.h"
#import "AudioFileWriter.h"


@interface ViewController : UIViewController
{
  RingBuffer *ringBuffer;
  Novocaine *audioManager;
  AudioFileReader *fileReader;
  AudioFileWriter *fileWriter;
  CAShapeLayer *oscilloscope;
}
@end

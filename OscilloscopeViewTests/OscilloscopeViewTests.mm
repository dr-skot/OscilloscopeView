//
//  OscilloscopeViewTests.m
//  OscilloscopeViewTests
//
//  Created by Scott Shepherd on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OscilloscopeViewTests.h"

@implementation OscilloscopeViewTests

- (void)setUp
{
  controller = [[ViewController alloc] init];
  [controller viewDidLoad];
  [controller viewWillAppear:YES];
}

- (void)tearDown
{
  [controller viewWillDisappear:YES];
  [controller viewDidUnload];
  [controller release];
  controller = nil;
}

- (void)testCanMakeController
{
  STAssertNotNil(controller, @"can make a controller");
}

- (void)testHasNotRecordedAnything
{
  STAssertFalse(controller.hasRecordedSomething, @"has not recorded anything");
}

- (void)testHasNoFile
{
  NSURL *url = controller.recordURL;
  STAssertNotNil(url, @"url is not null");
  STAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:[url path]], @"has no file at record url");
}

- (void)testIsRecordingWhileRecording
{
  [controller startRecording];
  [controller stopRecording];
}

- (void)testCanRecordWhileControllerIsWorking
{
}

@end

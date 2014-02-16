//
//  JMAppDelegate.m
//  JMTimerBeamExample
//
//  Created by Andreas Katzian on 16/02/14.
//  Copyright (c) 2014 JadeMind. All rights reserved.
//

#import "JMAppDelegate.h"

@implementation JMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
}

- (void) showTimerBeam:(JMTimerBeamOrientation) orientation
{
    if(self.timerBeam)
    {
        [self.timerBeam stop];
        self.timerBeam = nil;
    }

    self.timerBeam = [[JMTimerBeam alloc] initWithDuration:5 * 60
                                               orientation:orientation
                                                 thickness:3
                                                     color:[NSColor blueColor]];
    [self.timerBeam start];
}

- (IBAction)actionTop:(id)sender {
    [self showTimerBeam:JMTimerBeamOrientationTop];
}

- (IBAction)actionLeft:(id)sender {
    [self showTimerBeam:JMTimerBeamOrientationLeft];
}

- (IBAction)actionRight:(id)sender {
    [self showTimerBeam:JMTimerBeamOrientationRight];
}

- (IBAction)actionBottom:(id)sender {
    [self showTimerBeam:JMTimerBeamOrientationBottom];
}

@end

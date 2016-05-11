//
//  JMTimerBeam.m
//  Timebox
//
//  Created by Andreas Katzian on 15/02/14.
//  Copyright (c) 2014 JadeMind. All rights reserved.
//

#import "JMTimerBeam.h"
#import "JMBeamView.h"

@interface JMTimerBeam()

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) JMTimerBeamOrientation orientation;
@property (nonatomic, assign) NSInteger thickness;
@property (nonatomic, assign) BOOL reverse;
@property (nonatomic, retain) NSColor *color;

@property (nonatomic, retain) NSScreen *beamScreen;
@property (nonatomic, retain) NSWindow *beamWindow;
@property (nonatomic, retain) JMBeamView *beamView;

@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSTimer *timer;

@property (atomic, assign) BOOL running;

@end



@implementation JMTimerBeam

#pragma mark - Initializer methods

- (id) initWithDuration:(NSTimeInterval) duration
            orientation:(JMTimerBeamOrientation) orientation
              thickness:(NSInteger) thickness
                reverse:(BOOL)reverse
                  color:(NSColor*) color
{
    if(self = [super init])
    {
        // Store parameters
        self.duration = duration;
        self.orientation = orientation;
        self.color = color;
        self.thickness = thickness;
        self.reverse = reverse;
        
        // Set default values
        self.startTime = nil;
        self.running = NO;
        
        // Select the screen
        self.beamScreen = [[NSScreen screens] firstObject];
        
        // Get the initial rect
        NSRect beamWindowRect = [self beamWindowRect];
        
        // Create the beam window
        NSWindow *window = [[NSWindow alloc] initWithContentRect:beamWindowRect
                                                       styleMask:NSBorderlessWindowMask
                                                         backing:NSBackingStoreBuffered
                                                           defer:NO
                                                          screen:self.beamScreen];
        [window setBackgroundColor:[self.color colorWithAlphaComponent:0.2]];
        [window setOpaque:NO];
        [window setLevel:NSStatusWindowLevel];
        [window setReleasedWhenClosed:NO];
        
        self.beamWindow = window;
        
        // Create the beam view
        NSRect beamRect = [self beamRectForProgress:self.reverse ? 0 : 1];

        JMBeamView *view = [[JMBeamView alloc] initWithFrame:beamRect color:self.color];
        [self.beamWindow.contentView addSubview:view];
        
        self.beamView = view;
    }
    
    return self;
}

- (id) initWithDuration:(NSTimeInterval) duration
{
    // Decent green beam color
    NSColor *beamColor = [NSColor colorWithCalibratedRed:46.f/255.f green:204.f/255.f blue:113.f/255.f alpha:1.f];
    
    return [self initWithDuration:duration
                      orientation:JMTimerBeamOrientationLeft
                        thickness:2
                          reverse:NO
                            color:beamColor];
}


#pragma mark - Timer methods

- (void) start
{
    if(self.running == YES) return;
    
    // Show the beam window
    [self.beamWindow makeKeyAndOrderFront:NSApp];

    self.running = YES;
    self.startTime = [NSDate date];
    
    // Start a periodic timer with framerate
    NSTimeInterval framerate = 1.f/15.f;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:framerate target:self selector:@selector(update) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void) stop
{
    if(self.running == NO) return;

    self.running = NO;
    self.startTime = nil;

    // Hide the window
    [self.beamWindow resignKeyWindow];
    [self.beamWindow close];
    self.beamWindow = nil;

    // Destroy the timer
    [self.timer invalidate];
}

- (void) update
{
    if(self.running == NO) return;
    
    // Calculate elapsed time
    NSTimeInterval elapsed = [[NSDate date] timeIntervalSinceDate:self.startTime];
    
    if(elapsed >= self.duration)
    {
        // Stop the timer
        [self stop];
        
        // Notifiy the delegate
        if(self.delegate && [self.delegate respondsToSelector:@selector(didFinishTimerBeam:)])
        {
            [self.delegate didFinishTimerBeam:self];
        }
    }
    else
    {
        // Calculate progress of new beam rectangle and udpate the beam view
        CGFloat progress;
        if(self.reverse) {
            progress = elapsed / self.duration;
        }
        else {
            progress = (self.duration - elapsed) / self.duration;
        }
        NSRect rect = [self beamRectForProgress:progress];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.beamView setFrame:rect];
            [self.beamView setNeedsDisplay:YES];
        });
        
    }
}


#pragma mark - Helper methods

// Returns the basic length of the beam in pixels depending
// on the screen size
- (CGFloat) beamBaseLength
{
    NSSize screenSize = self.beamScreen.frame.size;
    switch (self.orientation)
    {
        case JMTimerBeamOrientationBottom:
        case JMTimerBeamOrientationTop:
        {
            return screenSize.width;
        }
        case JMTimerBeamOrientationLeft:
        case JMTimerBeamOrientationRight:
        {
            return screenSize.height;
        }
    }
}

// Returns the beam rectangle for given progress within the beam window
// depending on the screen size
- (NSRect) beamRectForProgress:(CGFloat) progress
{
    NSRect rect;
    NSSize screenSize = self.beamScreen.frame.size;

    // ensure progress between 0 and 1
    progress = fmin(1.f, progress);
    progress = fmax(0.f, progress);

    // Calculate length of beam
    CGFloat beamLength = [self beamBaseLength] * progress;
    
    switch (self.orientation)
    {
        case JMTimerBeamOrientationBottom:
        case JMTimerBeamOrientationTop:
        {
            CGFloat x = screenSize.width-beamLength;
//            if(self.reverse) x = 0;
            rect = NSMakeRect(x, 0, beamLength, self.thickness);
            break;
        }
        case JMTimerBeamOrientationLeft:
        case JMTimerBeamOrientationRight:
        {
            CGFloat y = 0;
//            if(self.reverse) y += screenSize.height-beamLength;
            rect = NSMakeRect(0, y, self.thickness, beamLength);
            break;
        }
    }
    
    return rect;
}


// Returns the main frame rectangle for the beam window
- (NSRect) beamWindowRect
{
    NSRect rect;
    NSSize screenSize = self.beamScreen.frame.size;
    
    switch (self.orientation)
    {
        case JMTimerBeamOrientationBottom:
        {
            rect = NSMakeRect(0, 0, screenSize.width, self.thickness);
            break;
        }
        case JMTimerBeamOrientationTop:
        {
            rect = NSMakeRect(0, screenSize.height - self.thickness, screenSize.width, self.thickness);
            break;
        }
        case JMTimerBeamOrientationLeft:
        {
            rect = NSMakeRect(0, 0, self.thickness, screenSize.height);
            break;
        }
        case JMTimerBeamOrientationRight:
        {
            rect = NSMakeRect(screenSize.width - self.thickness, 0, self.thickness,  screenSize.height);
            break;
        }
    }
    
    return rect;
}


@end

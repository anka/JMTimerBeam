//
//  JMBeamView.m
//  Timebox
//
//  Created by Andreas Katzian on 16/02/14.
//  Copyright (c) 2014 JadeMind. All rights reserved.
//

#import "JMBeamView.h"

@interface JMBeamView()

@property (nonatomic, retain) NSColor *color;

@end


@implementation JMBeamView

- (id) initWithFrame:(NSRect)frameRect color:(NSColor*) color
{
    self = [super initWithFrame:frameRect];
    self.color = color;
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Simply draw a clean recatangle
    NSBezierPath *rectanglePath = [NSBezierPath bezierPathWithRect:dirtyRect];
    [self.color setFill];
    [rectanglePath fill];
}

@end

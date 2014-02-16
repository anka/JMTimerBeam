//
//  JMAppDelegate.h
//  JMTimerBeamExample
//
//  Created by Andreas Katzian on 16/02/14.
//  Copyright (c) 2014 JadeMind. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <JMTimerBeam.h>

@interface JMAppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic,strong) JMTimerBeam *timerBeam;

@end

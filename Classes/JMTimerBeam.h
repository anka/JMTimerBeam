//
//  JMTimerBeam.h
//  Timebox
//
//  Created by Andreas Katzian on 15/02/14.
//  Copyright (c) 2014 JadeMind. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum JMTimerBeamOrientations {
    JMTimerBeamOrientationTop,
    JMTimerBeamOrientationLeft,
    JMTimerBeamOrientationRight,
    JMTimerBeamOrientationBottom
} JMTimerBeamOrientation;


@class JMTimerBeam;

@protocol JMTimerBeamDelegate <NSObject>

@optional
- (void) didFinishTimerBeam:(JMTimerBeam*) timerBeam;

@end



@interface JMTimerBeam : NSObject

@property (nonatomic, assign) id<JMTimerBeamDelegate> delegate;

/// Init new timer beam with given duration, orientation, thichkness and color
- (id) initWithDuration:(NSTimeInterval) duration
            orientation:(JMTimerBeamOrientation) orientation
              thickness:(NSInteger) thickness
                  color:(NSColor*) color;


/// Initialize a new JMTimerBeam positioned on the left of the screen 
/// with decent thickness and green color
- (id) initWithDuration:(NSTimeInterval) duration;


/// Show the timer beam on screen and start the timer
- (void) start;

/// Dismiss the timer beam and stop the timer
- (void) stop;

@end

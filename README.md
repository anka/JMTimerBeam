# JMTimerBeam

[![Version](http://cocoapod-badges.herokuapp.com/v/JMTimerBeam/badge.png)](http://cocoadocs.org/docsets/JMTimerBeam)
[![Platform](http://cocoapod-badges.herokuapp.com/p/JMTimerBeam/badge.png)](http://cocoadocs.org/docsets/JMTimerBeam)

JMTimerBeam enables you to show a decent beam on your OSX screen for visualizing a timing event. The beam will be attached to the top, right, bottom or left side of your screen and decreases steadily depending on the amount of time already elapsed.


## Screenshots

![JMTimerBeam Top](/jmtimerbeam_top.jpg "Screenshot Top")

![JMTimerBeam Left](/jmtimerbeam_left.jpg "Screenshot Left")


## Usage

To create a new timer beam on your screen simply crete a new instance of `JMTimerBeam` with one of the following two methods:

	/// Init new timer beam with given duration, orientation, thichkness and color
	- (id) initWithDuration:(NSTimeInterval) duration
	            orientation:(JMTimerBeamOrientation) orientation
	              thickness:(NSInteger) thickness
	                  color:(NSColor*) color;

	/// Initialize a new JMTimerBeam positioned on the left of the screen 
	/// with decent thickness and green color
	- (id) initWithDuration:(NSTimeInterval) duration;

After that use the `start` and `stop` method to start/stop the beam respectively. For positioning the beam on the screen use one of the following orientations:

	typedef enum JMTimerBeamOrientations {
	    JMTimerBeamOrientationTop,
	    JMTimerBeamOrientationLeft,
	    JMTimerBeamOrientationRight,
	    JMTimerBeamOrientationBottom
	} JMTimerBeamOrientation;

To get notified after the given duration elapsed and the beam ended implement the `JMTimerBeamDelegate` protocol with the method `didFinishTimerBeam:`.



To run the example project; clone the repo, and run `pod install` from the Project directory first.

## Installation

JMTimerBeam is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "JMTimerBeam"

## Author

Andreas Katzian, andreas.katzian@jademind.com

## License

JMTimerBeam is available under the MIT license. See the LICENSE file for more info.


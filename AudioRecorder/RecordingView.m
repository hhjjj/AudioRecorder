//
//  RecordingView.m
//  AudioRecorder
//
//  Created by songhojun on 11/14/13.
//  Copyright (c) 2013 songhojun. All rights reserved.
//

#import "RecordingView.h"

@implementation RecordingView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect:dirtyRect];
    [[NSColor redColor] set];
    //[NSBezierPath fillRect:NSMakeRect(10, 10, 30, 30)];
    
     NSBezierPath* thePath = [NSBezierPath bezierPath];
    
    [thePath appendBezierPathWithOvalInRect:NSMakeRect(10, 10, 30, 30)];
    [thePath fill];
    //NSRect *rect = NSMakeRect(10, 10, 30, 30);
}

@end

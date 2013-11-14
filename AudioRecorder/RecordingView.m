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
    [NSBezierPath fillRect:[self bounds]];
}

@end

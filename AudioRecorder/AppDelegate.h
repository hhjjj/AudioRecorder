//
//  AppDelegate.h
//  AudioRecorder
//
//  Created by songhojun on 11/13/13.
//  Copyright (c) 2013 songhojun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AVAudioRecorder;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSButton *recButton;
@property (weak) IBOutlet NSTextField *timeLabel;
@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (weak) IBOutlet NSLevelIndicator *L_AudioLevel;
@property (weak) IBOutlet NSLevelIndicator *R_AudioLevel;

//@property (assign) NSDate *startTime;
//@property (assign) NSTimer *recTimer;

- (IBAction)recButtonPressed:(id)sender;

- (BOOL)setupRecorder;
- (BOOL)loadSound;
- (void)recStart;
- (void)recStop;
- (void)updateTimer;

@end

//
//  AppDelegate.h
//  AudioRecorder
//
//  Created by songhojun on 11/13/13.
//  Copyright (c) 2013 songhojun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AVAudioRecorder;
@class RecordingView;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSButton *recButton;
@property (weak) IBOutlet NSTextField *timeLabel;
@property (weak) IBOutlet NSTextField *folderLabel;
@property (weak) IBOutlet NSTextField *fileLabel;

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (weak) IBOutlet NSLevelIndicator *L_AudioLevel;
@property (weak) IBOutlet NSLevelIndicator *R_AudioLevel;

@property (weak) IBOutlet NSLevelIndicator *recordIndicator;
@property (weak) IBOutlet NSView *drawView;

@property (strong) RecordingView *recordingView;

- (IBAction)recButtonPressed:(id)sender;
- (IBAction)folderButtonPressed:(id)sender;

- (void)selectSaveFolder;
- (void)setupRecorder;
- (void)recStart;
- (void)recStop;
- (void)countDownStart;
- (void)updateCountDown;
- (void)updateTimer;



@end

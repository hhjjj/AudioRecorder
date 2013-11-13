//
//  AppDelegate.m
//  AudioRecorder
//
//  Created by songhojun on 11/13/13.
//  Copyright (c) 2013 songhojun. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVAudioRecorder.h>
#import <AVFoundation/AVAudioSettings.h>
#import <CoreAudio/CoreAudio.h>

@implementation AppDelegate {
    NSDate *startTime;
    NSTimer *recTimer;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    [self setupRecorder];
    
    [self.timeLabel setFloatValue:0.0];
    [self.timeLabel setStringValue:@"00:00:0"];
    
    if([self loadSound]){
        NSLog(@"Sound Loaded");
    }
    else{
        NSLog(@"Sound Not Loaded");
    }
}

- (IBAction)recButtonPressed:(id)sender {
    [self recStart];
}

- (BOOL)setupRecorder{
    
    NSString *tempDir;
    NSURL *soundFile;
    NSDictionary *soundSetting;
    
    tempDir = @"/Users/songhojun/Documents/";
    soundFile = [NSURL fileURLWithPath: [tempDir stringByAppendingString:@"hojunb.wav"]];
    NSLog(@"soundFile: %@",soundFile);
    
    soundSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithFloat: 44100.0],AVSampleRateKey,
                    [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                    [NSNumber numberWithInt: 2],AVNumberOfChannelsKey,
                    [NSNumber numberWithInt: AVAudioQualityMax],AVEncoderAudioQualityKey, nil];
    
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL: soundFile settings: soundSetting error: nil];
    [self.audioRecorder setMeteringEnabled:YES];
    
    return NO;
}

- (BOOL)loadSound{
    return NO;
}

- (void)recStart{
    [recTimer invalidate];
    startTime = [NSDate date];
    recTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    [self.recButton setEnabled:NO];
    [self.audioRecorder record];
    NSLog(@"Rec Started");
}

- (void)recStop{
    [self.recButton setState:NSOffState];
    [self.recButton setEnabled:YES];
    [self.audioRecorder stop];
    NSLog(@"Rec Stopped");
}

- (void)updateTimer{
    
    NSTimeInterval interval = [startTime timeIntervalSinceNow];
    double intpart;
    double fractional = modf(interval, &intpart);
    NSUInteger hundredth = ABS((int)(fractional*10));
    NSUInteger seconds = ABS((int)interval);
    NSUInteger minutes = seconds/60;
    
    
    [self.timeLabel setStringValue:[NSString stringWithFormat:@"%02d:%02d:%01d", (int)(minutes)%60, (int)seconds%60, (int)hundredth]];
    
    [self.audioRecorder updateMeters];
    [self.L_AudioLevel setFloatValue:[self.audioRecorder averagePowerForChannel:0]];
    [self.R_AudioLevel setFloatValue:[self.audioRecorder averagePowerForChannel:1]];
    

    // stop the timer at 2.0 secs
    if (seconds > 20) {
        [recTimer invalidate];
        [self recStop];
    }
    
}

@end

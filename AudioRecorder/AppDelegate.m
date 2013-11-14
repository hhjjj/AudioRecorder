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
#import "RecordingView.h"

@implementation AppDelegate {
    NSDate *startTime;
    NSTimer *recTimer;
    NSURL *saveFolder;
    NSString *saveFolderPath;
    NSInteger fileName;
    BOOL isFolderOK;
    BOOL isRecorderSet;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    //[self setupRecorder];
    
    RecordingView *aView = [[RecordingView alloc] initWithFrame:[self.drawView bounds]];
    self.recordingView = aView;
    [self.drawView addSubview:self.recordingView];
    
    
    [self.timeLabel setStringValue:@"00:00:0"];
    [self.recordIndicator setIntegerValue:0];
    fileName = 1;
    [self.fileLabel setIntegerValue:fileName];
    
    isFolderOK = NO;
    isRecorderSet = NO;
    [self.recButton setEnabled:NO];
}

- (IBAction)recButtonPressed:(id)sender {
    [self countDownStart];
}

- (IBAction)folderButtonPressed:(id)sender {
    [self selectSaveFolder];

}

- (void)selectSaveFolder{
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES];
    [panel setCanCreateDirectories:YES];
    
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSArray* urls = [panel URLs];
            for (NSURL *url in urls) {
                //here how to judge the url is a directory or a file
                saveFolder = url;
                if([saveFolder isFileURL]){
                    NSLog([saveFolder path]);
                    BOOL isDir = NO;
                    [[NSFileManager defaultManager] fileExistsAtPath:[saveFolder path] isDirectory:&isDir];
                    if (isDir) {
                        NSLog(@"Directory");
                        isFolderOK = YES;
                        saveFolderPath = [saveFolder.path stringByAppendingString:@"/temp.wav"];
                        [self.folderLabel setStringValue:[saveFolder path]];
                        
                        [self setupRecorder];
                        [self.audioRecorder prepareToRecord];
                        
                        [self.recButton setEnabled:YES];
                    }
                    else{
                        NSLog(@"Not Directory");
                        isFolderOK = NO;
                    }

                }
                else{
                    NSLog(@"Not File URL");
                    isFolderOK = NO;
                }
           }
        }
    }];
}

- (void)setupRecorder{
    isRecorderSet = NO;

    //NSString *tempDir;
    NSURL *soundFile;
    NSDictionary *soundSetting;
    
    //tempDir = [saveFolder.path stringByAppendingString:@"/"];
//    soundFile = [NSURL fileURLWithPath: [[tempDir stringByAppendingString:[NSString stringWithFormat:@"%d",(int)fileName]] stringByAppendingString:@".wav"]];
    soundFile = [NSURL fileURLWithPath:saveFolderPath];
    NSLog(@"soundFile: %@",soundFile);
    
    soundSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithFloat: 44100.0],AVSampleRateKey,
                    [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                    [NSNumber numberWithInt: 2],AVNumberOfChannelsKey,
                    [NSNumber numberWithInt: AVAudioQualityMax],AVEncoderAudioQualityKey, nil];
    
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL: soundFile settings: soundSetting error: nil];
    [self.audioRecorder setMeteringEnabled:YES];
    isRecorderSet = YES;
}


- (void)recStart{
    [self.recButton setImage:[self.recButton alternateImage]];
    [self.audioRecorder record];
    [recTimer invalidate];
    startTime = [NSDate date];
    recTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    [self.recordIndicator setIntegerValue:3];
    NSLog(@"Rec Started");
}

- (void)recStop{
    [self.recButton setState:NSOffState];
    [self.recButton setEnabled:YES];
    [self.audioRecorder stop];
    NSLog(@"Rec Stopped");
    [self.recordIndicator setIntegerValue:0];

    [self.L_AudioLevel setFloatValue:[self.L_AudioLevel minValue]];
    [self.R_AudioLevel setFloatValue:[self.R_AudioLevel minValue]];

    [self.recButton setImage:[NSImage imageNamed:@"recstandby.png"]];
    
    NSString *newPath = [[saveFolderPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.wav",(int)fileName]];
    NSLog(newPath);
    [[NSFileManager defaultManager] moveItemAtPath:saveFolderPath toPath:newPath error:nil];    
    
    // prepare for next
    fileName++;
    [self.fileLabel setIntegerValue:fileName];
    
    
    
    [self setupRecorder];
    [self.recButton setEnabled:YES];
    
}

- (void)countDownStart{
    [self.recButton setEnabled:NO];
    startTime = [NSDate date];
    recTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCountDown) userInfo:nil repeats:YES];
    [self.recordIndicator setIntegerValue:1];

}

- (void)updateCountDown{
    NSTimeInterval interval = [startTime timeIntervalSinceNow];
    NSUInteger seconds = ABS((int)interval);
    [self.recordIndicator setIntegerValue:2];
    if (seconds > 1) {
        NSLog(@"CountDown Done");
        [recTimer invalidate];
        [self recStart];
    }
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
//    if ([self.audioRecorder averagePowerForChannel:0] != [self.audioRecorder averagePowerForChannel:1]) {
//        NSLog(@"difference: %f", [self.audioRecorder averagePowerForChannel:0] - [self.audioRecorder averagePowerForChannel:1]);
//    }
    

    // stop the timer at 2.0 secs
    if (seconds == 1) {
        [self.recordIndicator setIntegerValue:4];

    }
    if (seconds == 2) {
        [recTimer invalidate];
        [self recStop];
    }
    
}

@end

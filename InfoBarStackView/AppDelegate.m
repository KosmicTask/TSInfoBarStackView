/*
     File: AppDelegate.m
 Abstract: This sample's application delegate.
  Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 */

#import "AppDelegate.h"
#import "ShapeViewController.h"
#import "OtherViewController.h"
#import "ImagePickerViewController.h"

@interface AppDelegate ()

// the top-most view in the stack view
@property (weak) IBOutlet NSView *header;

// view controllers for each individual stack view
@property (weak) IBOutlet ShapeViewController *shapeDisclosureViewController;
@property (weak) IBOutlet OtherViewController *otherDisclosureViewController;
@property (weak) IBOutlet ImagePickerViewController *imagePickerDisclosureViewController;
@property (weak) IBOutlet NSScrollView *contentScrollView;
@property (weak) IBOutlet NSStackView *stackView;
@property (strong) NSArray *stackViewConstraints;
@property BOOL horizontalConstraintsApplied;
@end


@implementation AppDelegate

// -------------------------------------------------------------------------------
//	applicationDidFinishLaunching:aNotification
//
//  App has finished launching, setup it's stack view as the window's content view.
// -------------------------------------------------------------------------------
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSStackView *stackView = [NSStackView stackViewWithViews:@[self.header,
                                                               self.shapeDisclosureViewController.view,
                                                               self.imagePickerDisclosureViewController.view,
                                                               self.otherDisclosureViewController.view]];
    
    // use the size of this view as an minimum.
    // once the minimum is hit allow the
    CGFloat minWidth = self.otherDisclosureViewController.disclosedView.frame.size.width;
    
    // vertical centered stack
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.alignment = NSLayoutAttributeCenterX;
    stackView.spacing = 0;
    
    // do not hug horizontally.
    // let the fixed width subviews float centrally
    [stackView setHuggingPriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
    
    // do not resist clipping horizontally.
    // NSScrollView wrapper allow the clipped view to be scrolled into view.
    if (YES) {
        
        [stackView setClippingResistancePriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
    } else {
        
        // resist horizontal clipping.
        // stackview min width will match subview min width.
        [stackView setClippingResistancePriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
    }
    
    // hug vertically
    [stackView setHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];
    
    // do not resist clipping vertically
    [stackView setClippingResistancePriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationVertical];
    
    // add it to the scroll view
    self.window.contentView = self.contentScrollView;
    [self.contentScrollView setDocumentView:stackView];
    
    // stack view width is constrained to match the scrollview width.
    // Note: this arrangement will not not show the horizontal scroller when clippng as the stackview width matches the scrollvew width.
    // to show the horiz scroller remove these constraints when the view size hits the minWidth limit.
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(stackView);
    self.stackViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[stackView]-0-|" options:0 metrics:nil views:viewsDict];
    [self.contentScrollView addConstraints:self.stackViewConstraints];
    self.horizontalConstraintsApplied = YES;
    
    // observe the scroll view frame and update the horizontal constraint as required
    [[NSNotificationCenter defaultCenter] addObserverForName:NSViewFrameDidChangeNotification
                                                      object:self.contentScrollView queue:nil
                                                  usingBlock:^(NSNotification *note)
    {
        if (self.contentScrollView.frame.size.width < minWidth) {
            
            if (self.horizontalConstraintsApplied) {
                [self.contentScrollView removeConstraints:self.stackViewConstraints];
                self.horizontalConstraintsApplied = NO;
            }
            
        } else {
            
            if (!self.horizontalConstraintsApplied) {
                [self.contentScrollView addConstraints:self.stackViewConstraints];
                self.horizontalConstraintsApplied = YES;
            }
        }
    }];
}

// -------------------------------------------------------------------------------
//	applicationShouldTerminateAfterLastWindowClosed:sender
//
//	NSApplication delegate method placed here so the sample conveniently quits
//	after we close the window.
// -------------------------------------------------------------------------------
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
	return YES;
}

@end
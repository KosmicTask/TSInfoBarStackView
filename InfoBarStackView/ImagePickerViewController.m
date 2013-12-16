/*
     File: ImagePickerViewController.m
 Abstract: The "image picker" view section on the NSStackView.
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

#import "ImagePickerViewController.h"

@import Quartz;

@implementation MyBrowserItem

- (id)initWithName:(NSString *)name
{
	if (self = [super init])
    {
		_image = [NSImage imageNamed:name];
		_imageID = name;
	}
	return self;
}

#pragma mark - IKImageBrowserDataSource

// (required Methods IKImageBrowserItem Informal Protocol)

- (NSString *)imageUID
{
	return _imageID;
}

- (NSString *)imageRepresentationType
{
	return IKImageBrowserNSImageRepresentationType;
}

- (id)imageRepresentation
{
	return _image;
}

// (optional Methods IKImageBrowserItem Informal Protocol)

- (NSString *)imageTitle
{
	return _imageID;
}

@end


#pragma mark -

@interface ImagePickerViewController ()
@property (strong) NSArray *images;
@end


#pragma mark -

@implementation ImagePickerViewController

- (void)awakeFromNib
{
    _images = @[[[MyBrowserItem alloc] initWithName:@"scene1"],
                [[MyBrowserItem alloc] initWithName:@"scene2"],
                [[MyBrowserItem alloc] initWithName:@"scene3"]];
}

- (void)setDisclosedView:(NSView *)disclosedView
{
    [super setDisclosedView:disclosedView];
    
    IKImageBrowserView *browserView = [[IKImageBrowserView alloc] initWithFrame:NSZeroRect];
    browserView.dataSource = self;
    
    [browserView setCellSize:CGSizeMake(94.0,94.0)];    // each image will be 94x94
    
    [browserView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // make the image browser always be 120 pixels high (the width will be
    // computed for us to snap to the width of the window
    //
    [browserView addConstraint:[NSLayoutConstraint constraintWithItem:browserView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:0
                                                           multiplier:0
                                                             constant:120]];
    [self.disclosedView addSubview:browserView];
    
    // make the browserView snap to the width and height of our parent view (but keeping the height at 200)
    //
    [self.disclosedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[browserView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(browserView)]];
    [self.disclosedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[browserView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(browserView)]];
}

#pragma mark - IKImageBrowserDataSource

// implement image-browser's datasource protocol - our datasource representation is a simple array

- (NSUInteger)numberOfItemsInImageBrowser:(IKImageBrowserView *)view
{
    return [self.images count];
}

- (id)imageBrowser:(IKImageBrowserView *)view itemAtIndex:(NSUInteger)index
{
    return [self.images objectAtIndex:index];
}

@end

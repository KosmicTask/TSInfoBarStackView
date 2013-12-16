/*
     File: ShapeViewController.m
 Abstract: The "Shapes" view section on the NSStackView.
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

#import "ShapeViewController.h"

@interface ShapeViewController ()
@property (nonatomic, assign, readwrite) NSUInteger selectedShape;
@end


#pragma mark -

@implementation ShapeViewController

- (NSImageView *)imageWithName:(NSString *)name
{
    NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSZeroRect];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.image = [NSImage imageNamed:name];
    
    // always make the image view size 54x54
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:0
                                                         multiplier:0
                                                           constant:54]];
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:0
                                                         multiplier:0
                                                           constant:54]];
    return imageView;
}

- (NSString *)imageNameForTag:(NSUInteger)tag
{
    NSString *imageName = nil;
    switch (tag)
    {
        case 0:
            imageName = @"arrow";
            break;
        case 1:
            imageName = @"circle";
            break;
        case 2:
            imageName = @"pentagon";
            break;
        case 3:
            imageName = @"square";
            break;
        case 4:
            imageName = @"triangle";
            break;
        case 5:
            imageName = @"star";
            break;
    }
    return imageName;
}

// A disclosed view is being associated with this view controller,
// this is a good time to setup the content for the NSStackView:
//
- (void)setDisclosedView:(NSView *)disclosedView
{
    [super setDisclosedView:disclosedView];
    
    ShapePaletteView *shapeView = (ShapePaletteView *)self.disclosedView;
    
    shapeView.delegate = self;  // let us be notified when a shape was clicked on
    
    NSStackView *stackView = [[shapeView subviews] objectAtIndex:0];
    assert(stackView != nil);
    
    // figure out the image names for each shape, and add them to our stack view
    for (NSUInteger index = 0; index < 6; index++)
    {
        NSString *imageName = [self imageNameForTag:index];
        NSImageView *imageView = [self imageWithName:imageName];
        [imageView setTag:index];  // tag this view so we can recognize it later
        [stackView addView:imageView inGravity:NSStackViewGravityLeading];
        [stackView setVisibilityPriority:(NSStackViewVisibilityPriorityDetachOnlyIfNecessary - index)
                                 forView:imageView];
    }
    
    // use the view tag to obtain the shape image
    NSImageView *selectedImage = [stackView viewWithTag:0];
    // inform ourselves of the initial selected shape image
    [self userSelectedShapeView:selectedImage];
    
    // add a minimum width constraint
    [stackView addConstraint:[NSLayoutConstraint constraintWithItem:stackView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                             toItem:nil
                                                          attribute:0
                                                         multiplier:0
                                                           constant:270]];
    
    // add a constraint not allowing the stackview to expand beyond the last view
    [stackView addConstraint:[NSLayoutConstraint constraintWithItem:stackView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationLessThanOrEqual
                                                             toItem:[stackView.views lastObject]
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:stackView.edgeInsets.right]];
}


#pragma mark - ShapesViewDelegate

// As a ShapesViewDelegate we are being asked to respond to shape selection,
// here we respond by changing the shape image to selected or de-selected.
//
- (void)userSelectedShapeView:(NSImageView *)selectedImage
{
    NSImageView *oldShapeView = [self.disclosedView viewWithTag:self.selectedShape];
    
    NSInteger viewTag = oldShapeView.tag;
    
    // set using the unselected image
    NSString *imageName = nil;
    imageName = [self imageNameForTag:viewTag];
    [oldShapeView setImage:[NSImage imageNamed:imageName]];
    
    // set using the selected image
    self.selectedShape = selectedImage.tag;
    viewTag = selectedImage.tag;
    imageName = [self imageNameForTag:viewTag];
    imageName = [imageName stringByAppendingString:@"-selected"];
    [selectedImage setImage:[NSImage imageNamed:imageName]];
    
    NSLog(@"shape %ld was selected", viewTag);
}

@end

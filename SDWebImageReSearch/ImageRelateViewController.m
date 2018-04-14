//
//  ImageRelateViewController.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/4/13.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "ImageRelateViewController.h"
#import "ImageProcessHelper.h"

@interface ImageRelateViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl1;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl2;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation ImageRelateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.slider.value = 0;
    
    [self.segmentedControl1 addTarget:self action:@selector(changed) forControlEvents:UIControlEventValueChanged];
    [self.segmentedControl2 addTarget:self action:@selector(changed) forControlEvents:UIControlEventValueChanged];
    [self.slider addTarget:self action:@selector(changed) forControlEvents:UIControlEventValueChanged];
    
}

- (void)changed {
    NSString *imageName;

    if (_segmentedControl1.selectedSegmentIndex == 0) {
        // JPEG
        if (_segmentedControl2.selectedSegmentIndex == 0) {
            //BaseLine
            imageName = @"mew_baseline.jpg";
        }else if (_segmentedControl2.selectedSegmentIndex == 1){
            // Interlaced
            // ***
            imageName = @"mew_progressive.jpg";
        }else {
            // Progressive
            imageName = @"mew_progressive.jpg";
        }
    }else if (_segmentedControl1.selectedSegmentIndex == 1){
        // PNG
        if (_segmentedControl2.selectedSegmentIndex == 0) {
            //BaseLine
            imageName = @"mew_baseline.png";
        }else if (_segmentedControl2.selectedSegmentIndex == 1){
            // Interlaced
            imageName = @"mew_interlaced.png";
        }else {
            // Progressive
            // ***
            imageName = @"mew_interlaced.png";
        }
    }else {
        // GIF
        // PNG
        if (_segmentedControl2.selectedSegmentIndex == 0) {
            //BaseLine
            imageName = @"mew_baseline.gif";
        }else if (_segmentedControl2.selectedSegmentIndex == 1){
            // Interlaced
            imageName = @"mew_interlaced.gif";
        }else {
            // Progressive
            // ***
            imageName = @"mew_interlaced.gif";
        }
    }
    NSString *filePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@""];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    CGFloat progress = _slider.value;
    if (progress > 1) progress = 1;
    
    NSData *subImageData = [imageData subdataWithRange:NSMakeRange(0, imageData.length * progress)];
    BOOL finalized = progress == 1 ?YES:NO;
    UIImage *image = PXYIncrementallyImageWithImageData(subImageData, finalized);
    self.imageView.image = image;
}

@end

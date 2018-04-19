//
//  LRUViewController.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/4/17.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "LRUViewController.h"
#import "LRUImplement.h"

@interface LRUViewController ()

@property (nonatomic , strong) LRUImplement *cache;
@property (weak, nonatomic) IBOutlet UITextField *cacheCapacityTextFlied;
@property (weak, nonatomic) IBOutlet UITextField *cacheOperationTextField;

@end

@implementation LRUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cache = [[LRUImplement alloc] initLRUMaxCapacityWithCapacity:[self.cacheCapacityTextFlied.text integerValue]];
    
    // Do any additional setup after loading the view.
}

- (IBAction)setAction:(id)sender {
    [self.cache putKey:self.cacheOperationTextField.text Value:self.cacheOperationTextField.text];
}

- (IBAction)getAction:(id)sender {
    NSLog(@"%@",[self.cache getValueWithKey:self.cacheOperationTextField.text]);
}

- (IBAction)clearAction:(id)sender {
    self.cache = [[LRUImplement alloc] initLRUMaxCapacityWithCapacity:[self.cacheCapacityTextFlied.text integerValue]];

}
@end

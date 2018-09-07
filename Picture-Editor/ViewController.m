//
//  ViewController.m
//  Picture-Editor
//
//  Created by Mac on 2018/8/6.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "PVTSelectPictureViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)buttonDidClicked:(UIButton *)btn {
    NSLog(@"tag = %ld ----- title = %@", btn.tag, btn.titleLabel.text);
    PVTSelectPictureViewController *selectVC = [[PVTSelectPictureViewController alloc] init];
    [self presentViewController:selectVC animated:YES completion:nil];
    
}

@end

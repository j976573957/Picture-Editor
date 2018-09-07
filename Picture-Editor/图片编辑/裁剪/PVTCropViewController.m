//
//  PVTCropViewController.m
//  Picture-Editor
//
//  Created by Mac on 2018/8/24.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTCropViewController.h"
#import "UIImage+PVTRotation.h"

@interface PVTCropViewController ()
{
    __weak IBOutlet UIView *contentView;
    __weak IBOutlet UIStackView *rotateMenu;
    __weak IBOutlet UIButton *btnReset;
    __weak IBOutlet UIButton *btnTurnLeft;
    __weak IBOutlet UIButton *btnTurnRight;
    __weak IBOutlet UIButton *btnHorizontal;
    __weak IBOutlet UIButton *btnVertical;
    __weak IBOutlet UIStackView *cropMenu;
    __weak IBOutlet UIButton *btnFree;
    __weak IBOutlet UIButton *btn11Style;
    __weak IBOutlet UIButton *btn34Style;
    __weak IBOutlet UIButton *btn43Style;
    __weak IBOutlet UIButton *btn916Style;
    
    TOCropViewController *_cropVC;
    NSArray *_styleBtns;
}

@property (nonatomic, strong) TOCropView *cropView;

@end

@implementation PVTCropViewController

- (id)init
{
    self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self.class)];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _styleBtns = @[btnFree, btn11Style, btn34Style, btn43Style, btn916Style];
    
    [self setupSubviews];
    [self layoutSubviews];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self->btnFree sendActionsForControlEvents:UIControlEventTouchUpInside];
    });
}

- (void)setupSubviews
{
    _cropVC = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:self.image];
    [self addChildViewController:_cropVC];
    _cropVC.delegate = self.delegate;
    _cropView = _cropVC.cropView;
    [_cropView performInitialSetup];
    [contentView addSubview:_cropView];
}

- (void)layoutSubviews
{
    [_cropView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    [rotateMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(ScreenWidth));
        make.height.equalTo(@60);
        make.top.equalTo(@0).priorityHigh();
        make.bottom.equalTo(@0).priorityLow();
        make.centerX.mas_equalTo(0);
    }];
    
    [cropMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(ScreenWidth));
        make.height.equalTo(@60);
        make.top.equalTo(@0).priorityLow();
        make.bottom.equalTo(@0).priorityHigh();
        make.centerX.mas_equalTo(0);
    }];
}


#pragma mark - 事件
- (IBAction)btnCancel:(id)sender {
    SEL cancel = NSSelectorFromString(@"cancelButtonTapped");
    if (cancel) {
        [_cropVC performSelector:cancel withObject:nil];
    }
}

- (IBAction)btnComplete:(id)sender {
    SEL done = NSSelectorFromString(@"doneButtonTapped");
    if (done) [_cropVC performSelector:done withObject:nil];
}
- (IBAction)cropButtonClicked:(id)sender {
    [UIView animateWithDuration:.25 animations:^{
        self->cropMenu.alpha = 1;
        self->rotateMenu.alpha = 0;
    }];
}
- (IBAction)rotationButtonClicked:(id)sender {
    [UIView animateWithDuration:.25 animations:^{
        self->cropMenu.alpha = 0;
        self->rotateMenu.alpha = 1;
    }];
}

- (void)setBtnSelected:(UIButton *)btn selected:(BOOL)selected {
    btn.selected = selected;
}

#pragma mark 裁剪
- (IBAction)freeStyleButtonClicked:(id)sender {
    _cropView.aspectRatio = CGSizeZero;
    _cropView.aspectRatioLockEnabled = NO;
}
- (IBAction)squareButtonClicked:(id)sender {
    _cropView.aspectRatio = CGSizeMake(1, 1);
    _cropView.aspectRatioLockEnabled = YES;
}
- (IBAction)style34ButtonClicked:(id)sender {
    _cropView.aspectRatio = CGSizeMake(3, 4);
    _cropView.aspectRatioLockEnabled = YES;
}
- (IBAction)style43ButtonClicked:(id)sender {
    _cropView.aspectRatio = CGSizeMake(4, 3);
    _cropView.aspectRatioLockEnabled = YES;
}
- (IBAction)style916ButtonClicked:(id)sender {
    _cropView.aspectRatio = CGSizeMake(9, 16);
    _cropView.aspectRatioLockEnabled = YES;
}

#pragma mark 旋转

- (IBAction)resetButtonClicked:(id)sender {
    [_cropVC performSelector:NSSelectorFromString(@"resetCropViewLayout") withObject:nil];

}
- (IBAction)turnLeftButtonClicked:(id)sender {
    [_cropVC performSelector:NSSelectorFromString(@"rotateCropViewCounterclockwise") withObject:nil];
}
- (IBAction)turnRightButtonClicked:(id)sender {
    [_cropVC performSelector:NSSelectorFromString(@"rotateCropViewClockwise") withObject:nil];
}
- (IBAction)horizontalButtonClicked:(id)sender {
    self.cropView.image = [self.cropView.backgroundImageView.image flipHorizontal];
    _cropVC.image = self.cropView.image;
    self.cropView.backgroundImageView.image = self.cropView.image;
    self.cropView.foregroundImageView.image = self.cropView.image;
}
- (IBAction)verticalButtonClicked:(id)sender {
    self.cropView.image = [self.cropView.backgroundImageView.image flipVertical];
    _cropVC.image = self.cropView.image;
    self.cropView.backgroundImageView.image = self.cropView.image;
    self.cropView.foregroundImageView.image = self.cropView.image;
}

@end

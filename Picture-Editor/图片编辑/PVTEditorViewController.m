//
//  PVTEditorViewController.m
//  Picture-Editor
//
//  Created by Mac on 2018/8/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTEditorViewController.h"
#import "PVTFilterMenuView.h"
#import "UIImage+PVTFilter.h"
#import "PVTCropViewController.h"
#import "PVTFrameMenuView.h"
#import "PVTFrameView.h"
#import "PVTArrowMenuView.h"
#import "PVTArrowView.h"
#import "PVTStickerView.h"
#import "PVTStickerMenuView.h"
#import "PVTMosicView.h"
#import "PVTMosicMenuView.h"
#import "PVTBrushView.h"
#import "PVTBrushMenuView.h"
#import "PVTBorderView.h"
#import "PVTBorderMenuView.h"

#import "PVTImageScrollView.h"


@interface PVTEditorToolsCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;


@end

@interface PVTEditorViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, TOCropViewControllerDelegate, PVTToolsBaseViewDelegate, UIGestureRecognizerDelegate>
{
    NSArray *_toolTitles;
    UIView *_contentView;
    NSMutableArray *_tempFrames;
    NSMutableArray *_tempArrows;
    NSMutableArray *_tempStickers;
    NSMutableArray *_tempMosaicPaths;
    NSMutableArray *_savedBrushPaths;
}

@property (weak, nonatomic) IBOutlet UICollectionView *toolCollectionView;
@property (weak, nonatomic) UIView *currMenuView;
@property (nonatomic, assign) PVTImageEditMode editMode;
@property (nonatomic, strong) PVTFilterMenuView *filterMenu;
@property (strong, nonatomic) PVTFrameMenuView *frameMenu;
@property (nonatomic, strong) PVTFrameStyle *frameStyle;
@property (strong, nonatomic) PVTArrowMenuView *arrowMenu;
@property (strong, nonatomic) PVTArrowStyle *arrowStyle;
@property (strong, nonatomic) PVTStickerMenuView *stickerMenu;
@property (strong, nonatomic) PVTMosicView *mosaicView;
@property (strong, nonatomic) PVTMosicMenuView *mosaicMenu;
@property (strong, nonatomic) PVTMosicStyle *mosaicStyle;
@property (strong, nonatomic) PVTBrushStyle *brushStyle;
@property (strong, nonatomic) PVTBrushView *brushView;
@property (strong, nonatomic) PVTBrushMenuView *brushMenu;
@property (strong, nonatomic) PVTBorderView *borderView;
@property (strong, nonatomic) PVTBorderStyle *borderStyle;
@property (strong, nonatomic) PVTBorderMenuView *borderMenu;

@property (nonatomic, strong) PVTImageScrollView *imageScrollView;

@end

@implementation PVTEditorViewController

- (instancetype)init
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([PVTEditorViewController class])];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupScrollView];
    [self initMainMenu];
}

#pragma mark - init
- (void)setupScrollView
{
    self.imageScrollView = [[PVTImageScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64 - 49-30)];
    self.imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.imageScrollView];
//    self.imageView = _imageScrollView.imageView;
    self.brushView = _imageScrollView.brushView;
    self.mosaicView = _imageScrollView.mosaicView;
    self.borderView = _imageScrollView.borderView;
    [_imageScrollView setImage:self.imageView.image];
    
    _brushStyle = [[PVTBrushStyle alloc] init];
    self.brushView.brushStyle = _brushStyle;
    
    _mosaicStyle = [[PVTMosicStyle defaultStyles] firstObject];
    self.mosaicView.mosaicStyle = _mosaicStyle;
}

- (void)initMainMenu
{
    _toolTitles = @[@"滤镜", @"编辑" ,@"线框" ,@"箭头" ,@"贴图", @"马赛克", @"画笔", @"边框"];
    NSMutableArray *subMenuViews = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    //滤镜
    self.filterMenu = [PVTFilterMenuView new];
    [subMenuViews addObject:self.filterMenu];
    [self.filterMenu setPreferredFilterID:^(NSInteger filterID) {
        [SVProgressHUD show];
        [weakSelf.image filter:filterID completion:^(UIImage *filterImage) {
            [SVProgressHUD dismiss];
            weakSelf.imageView.image = filterImage;
        }];
    }];
    
    //线框
    self.frameMenu = [PVTFrameMenuView new];
    [subMenuViews addObject:self.frameMenu];
    [self.frameMenu setPreferredStyle:^(PVTFrameStyle *preferredStyle){
        weakSelf.frameStyle = preferredStyle;
    }];
    self.frameStyle = self.frameMenu->frameStyle;
    
    //箭头
    self.arrowMenu = [PVTArrowMenuView new];
    [self.arrowMenu setPreferredStyle:^(PVTArrowStyle *preferredStyle){
        weakSelf.arrowStyle = preferredStyle;
    }];
    self.arrowStyle = self.arrowMenu->arrowStyle;
    [subMenuViews addObject:self.arrowMenu];
    
    //贴图
    self.stickerMenu = [PVTStickerMenuView new];
    [self.stickerMenu setPreferredStyle:^(PVTStickerStyle *preferredStyle) {
        [weakSelf addNewSticker:preferredStyle];
    }];
    [subMenuViews addObject:self.stickerMenu];
    
    //马赛克
    self.mosaicMenu = [PVTMosicMenuView new];
    [self.mosaicMenu setPreStep:^{
        [weakSelf.mosaicView revoke];
    }];
    [self.mosaicMenu setNextStep:^{
        [weakSelf.mosaicView recovery];
    }];
    [self.mosaicMenu setPreferredStyle:^(PVTMosicStyle *preferredStyle){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (!preferredStyle.image) {
                UIImage *image = [weakSelf.image gaussianBlur:20];
                CGFloat s = weakSelf.imageView.width/image.size.width;
                image = [UIImage imageWithCGImage:image.CGImage scale:1./s orientation:UIImageOrientationUp];
                preferredStyle.image = image;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.mosaicView.mosaicStyle = preferredStyle;
                [weakSelf.mosaicView setNeedsDisplay];
            });
        });
    }];
    [subMenuViews addObject:self.mosaicMenu];
    
    //画笔
    self.brushMenu = [PVTBrushMenuView new];
    [self.brushMenu setPreStep:^{
        [weakSelf.brushView revoke];
    }];
    [self.brushMenu setNextStep:^{
        [weakSelf.brushView recovery];
    }];
    [self.brushMenu setPreferredStyle:^(PVTBrushStyle *preferredStyle){
        weakSelf.brushView.brushStyle = preferredStyle;
        [weakSelf.brushMenu setNeedsDisplay];
    }];
    [subMenuViews addObject:self.brushMenu];
    
    //边框
    self.borderMenu = [PVTBorderMenuView new];
    [self.borderMenu setPreferredStyle:^(PVTBorderStyle *preferredStyle) {
        [weakSelf addNewBorder:preferredStyle];
    }];
    [subMenuViews addObject:self.borderMenu];
    
    //
    for (PVTToolsBaseView *view in subMenuViews) {
        view.delegate = self;
        if (ScreenHeight == 812) {
            view.top = CGRectGetMaxY(self.view.bounds);
        }else{
            view.top = CGRectGetMaxY(_contentView.bounds);
        }
        [_contentView addSubview:view];
    }
}

#pragma mark - setter & getter
- (void)setImageView:(UIImageView *)imageView
{
    _imageView = imageView;
    _imageView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    pan.delegate = self;
    [_imageView addGestureRecognizer:pan];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self.imageScrollView setImage:image];
    self.filterMenu.image = image;
    if (self.borderMenu.preferredStyle) {
        self.borderMenu.preferredStyle(_borderView.borderStyle);
    }
}

#pragma mark - event
- (void)showMenu:(UIView *)view
{
    view.hidden = NO;
    [self.view addSubview:view];
    self.toolCollectionView.hidden = NO;
    UIView *viewWillHide = self.toolCollectionView;
    if (view == self.toolCollectionView) {
//        viewWillHide = nil;
        self.editMode = PVTImageEditModeNone;
    } else {
        if (view == _filterMenu) {
            self.editMode = PVTImageEditModeFilter;
            self.image = self.imageView.image;
            self.filterMenu.image = self.image;
        } else if (view == _frameMenu) {
            self.editMode = PVTImageEditModeFrame;
        } else if (view == _arrowMenu) {
            self.editMode = PVTImageEditModeArrow;
        }else if (view == _stickerMenu) {
            self.editMode = PVTImageEditModeSticker;
        } else if (view == _mosaicMenu) {
            self.editMode = PVTImageEditModeMosaic;
        } else if (view == _brushMenu) {
            self.editMode = PVTImageEditModeBrush;
        } else if (view == _borderMenu) {
            self.editMode = PVTImageEditModeBorder;
        }
    }
    
    //
    CGFloat height = ScreenHeight;
    view.origin = CGPointMake(0, height);
    self.toolCollectionView.hidden = YES;
    [UIView animateWithDuration:.25 animations:^{
        [self.navigationController setNavigationBarHidden:viewWillHide != nil];
        self.currMenuView.origin = CGPointMake(0, height);
        view.origin = CGPointMake(0, height - view.height);
//        viewWillHide.origin = CGPointMake(0, height);
    } completion:^(BOOL finished) {
        self.currMenuView = view;
        viewWillHide.hidden = NO;
    }];
}

- (void)setEditMode:(PVTImageEditMode)editMode
{
    _editMode = editMode;
    self.brushView.userInteractionEnabled = (_editMode == PVTImageEditModeBrush);
    self.mosaicView.userInteractionEnabled = (_editMode == PVTImageEditModeMosaic);
}

- (IBAction)close:(id)sender {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要退出吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [controller addAction:cancel];
    [controller addAction:sure];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)done:(id)sender {
    
}

#pragma mark 手势
- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    if (self.editMode == PVTImageEditModeFrame) {
        [self framePan:pan];
    }else if (self.editMode == PVTImageEditModeArrow) {
        [self arrowPan:pan];
    }
}

- (void)framePan:(UIPanGestureRecognizer *)pan
{
    static CGPoint startPoint;
    UIView *view = pan.view;
    CGPoint point = [pan locationInView:view];
    static PVTFrameView *frameView;
    if (pan.state == UIGestureRecognizerStateBegan) {
        [frameView prepareToSaveStatus];
        [PVTBaseElementView setActiveElementView:nil];
        startPoint = point;
        frameView = [[PVTFrameView alloc] initWithFrame:CGRectMake(startPoint.x-15, startPoint.y, 30, 0)];
        frameView.frameStyle = self.frameStyle;
        frameView.startPoint = point;
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint newPoint = [pan translationInView:view];
        CGFloat s = sqrt(newPoint.x * newPoint.x + newPoint.y * newPoint.y);
        if (s > 30) {
            CGRect frame = [self rectWithPoint:startPoint p2:point];
            frameView.rect = frame;
            if (!frameView.superview) {
                [_imageView addSubview:frameView];
                [_tempFrames addObject:frameView];
            }
        }
    } else if (pan.state == UIGestureRecognizerStateCancelled) {
        frameView = nil;
        [frameView saveStatus];
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        [PVTFrameView setActiveElementView:frameView];
        frameView = nil;
        [frameView saveStatus];
    }
}

- (CGRect)rectWithPoint:(CGPoint)p1 p2:(CGPoint)p2
{
    CGFloat w = ABS(p2.x - p1.x);
    CGFloat h = ABS(p2.y - p1.y);
    return CGRectMake(MIN(p1.x, p2.x), MIN(p1.y, p2.y), w, h);
}

- (void)arrowPan:(UIPanGestureRecognizer *)pan
{
    static CGPoint startPoint;
    static PVTArrowView *arrowView;
    UIView *view = pan.view;
    CGPoint point = [pan locationInView:view];
    if (pan.state == UIGestureRecognizerStateBegan) {
        [arrowView prepareToSaveStatus];
        [PVTBaseElementView setActiveElementView:arrowView];
        startPoint = point;
        arrowView = [[PVTArrowView alloc] initWithFrame:CGRectMake(startPoint.x-15, startPoint.y, 30, 0)];
        arrowView.arrowStyle = self.arrowStyle;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint t = [pan translationInView:view];
        CGFloat s = sqrt((t.x*t.x+t.y*t.y));
        if (s > 30) {
            arrowView.h = s;
            CGFloat angle = 0;
            angle = atan((point.y-startPoint.y)/(point.x-startPoint.x));
            if (point.x > startPoint.x && point.y > startPoint.y) {
                angle = angle - M_PI_2;
                arrowView.angle = angle;
            } else if (point.x > startPoint.x && point.y < startPoint.y) {
                angle = angle + M_PI_2 * 3;
                arrowView.angle = angle;
            } else if (point.x < startPoint.x && point.y < startPoint.y) {
                angle = angle - M_PI_2 * 3;
                arrowView.angle = angle;
            } else if (point.x < startPoint.x && point.y > startPoint.y) {
                angle = angle + M_PI_2;
                arrowView.angle = angle;
            }
            if (!arrowView.superview) {
                [_imageView addSubview:arrowView];
                [_tempArrows addObject:arrowView];
            }
        }
        
    } else if (pan.state == UIGestureRecognizerStateCancelled) {
        arrowView = nil;
        [arrowView saveStatus];
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        arrowView = nil;
        [arrowView saveStatus];
    }
}

/** 增加贴图 */
- (void)addNewSticker:(PVTStickerStyle *)stickerStyle {
    PVTStickerView *sticker = [[PVTStickerView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    sticker.stickerStyle = stickerStyle;
    sticker.center = CGPointMake(_imageView.width/2., _imageView.height/2.);
    [_imageView addSubview:sticker];
    [_tempStickers addObject:sticker];
    [PVTBaseElementView setActiveElementView:sticker];
}

/** 边框 */
- (void)addNewBorder:(PVTBorderStyle *)style {
    _borderStyle = _borderView.borderStyle;
    _borderView.borderStyle = style;
}

#pragma mark - UIGestureDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer.view == _imageView && (_editMode == PVTImageEditModeArrow || _editMode == PVTImageEditModeFrame)) {
        return YES;
    }
    return NO;
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section 
{
    return _toolTitles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PVTEditorToolsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PVTEditorToolsCellID" forIndexPath:indexPath];
    cell.lbTitle.text = _toolTitles[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PVTEditorToolsCell *cell = (PVTEditorToolsCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"----------- 点击了 ----------- %@", cell.lbTitle.text);
    if (indexPath.row == 0) {
        [self showMenu:self.filterMenu];
    }else if (indexPath.row == 1) {
        PVTCropViewController *vc = [[PVTCropViewController alloc] init];
        vc.image = self.imageView.image;
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    } else if (indexPath.row == 2){
        [self showMenu:self.frameMenu];
    } else if (indexPath.row == 3) {
        [self showMenu:self.arrowMenu];
    } else if (indexPath.row == 4) {
        [self showMenu:self.stickerMenu];
    } else if (indexPath.row == 5) {
        [self showMenu:self.mosaicMenu];
    } else if (indexPath.row == 6) {
        [self showMenu:self.brushMenu];
    } else if (indexPath.row == 7) {
        [self showMenu:self.borderMenu];
    }
}


#pragma mark - TOCropViewControllerDelegate
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [cropViewController dismissViewControllerAnimated:YES completion:NULL];
    self.imageView.image = image;
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToCircularImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [cropViewController dismissViewControllerAnimated:YES completion:NULL];
    self.imageView.image = image;
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    [cropViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - PVTToolsBaseViewDelegate

- (void)cancel:(id)sender {
    _currMenuView = sender;
    [self showMenu:self.currMenuView];
    if (sender == _filterMenu) {
        self.imageView.image = self.image;
    }
    _currMenuView.hidden = YES;
    self.toolCollectionView.hidden = NO;
}

- (void)confirm:(id)sender {
    _currMenuView = sender;
    
}



@end

@implementation PVTEditorToolsCell

@end

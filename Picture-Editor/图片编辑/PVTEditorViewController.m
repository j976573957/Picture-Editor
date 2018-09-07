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

@interface PVTEditorToolsCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;


@end

@interface PVTEditorViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, TOCropViewControllerDelegate, PVTToolsBaseViewDelegate>
{
    NSArray *_toolTitles;
    UIView *_contentView;
    
}

@property (weak, nonatomic) IBOutlet UICollectionView *toolCollectionView;
@property (nonatomic, assign) PVTImageEditMode editMode;
@property (nonatomic, strong) PVTFilterMenuView *filterMenu;
@property (strong, nonatomic) PVTFrameMenuView *frameMenu;
@property (nonatomic, strong) PVTFrameStyle *frameStyle;
@property (weak, nonatomic) UIView *currMenuView;

@end

@implementation PVTEditorViewController

- (instancetype)init
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([PVTEditorViewController class])];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainMenu];
}

#pragma mark - init
- (void)initMainMenu
{
    _toolTitles = @[@"滤镜", @"编辑",@"线框"];
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
    }else if (indexPath.row == 2){
        [self showMenu:self.frameMenu];
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

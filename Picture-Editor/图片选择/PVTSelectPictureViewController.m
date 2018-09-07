//
//  PVTSelectPictureViewController.m
//  Picture-Editor
//
//  Created by Mac on 2018/8/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTSelectPictureViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "PVTEditorViewController.h"

@interface PVTSelectPictureCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *statusView;
@end

@interface PVTSelectPictureViewController ()
{
    ALAssetsLibrary *_library;
    NSMutableArray *_images;
    IBOutlet UICollectionView *collectionView;
}



@end

@implementation PVTSelectPictureViewController

- (id)init
{
    self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([PVTSelectPictureViewController class])];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *nv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 88)];
    nv.backgroundColor = [UIColor blackColor];
    [self.view addSubview:nv];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dismissVC:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 44, 44, 44);
    [nv addSubview:btn];
    
    _images = [NSMutableArray array];
    _library = [[ALAssetsLibrary alloc] init];
    [self selectPicture];
}
- (IBAction)dismissVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectPicture
{
    //iOS 9.0 之前
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//            if (group) {
//                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
//                    if (result) {
//                        ALAsset *asset = result;
//                        CGImageRef cimg = [asset aspectRatioThumbnail];
//                        UIImage *img = [UIImage imageWithCGImage:cimg];
//                        [_images addObject:result];
//                    }
//                }];
//                [collectionView reloadData];
//            }
//        } failureBlock:^(NSError *error) {
//            NSLog(@"%s ----- error = %@", __func__, error);
//        }];
//    });
    
    //iOS 9.0 之后
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusNotDetermined) {//用户没有作出选择
            NSLog(@"用户没有作出选择");
        } else if (status == PHAuthorizationStatusRestricted) {//不能修改 如：父母模式
            NSLog(@"不能修改 如：父母模式");
        } else if (status == PHAuthorizationStatusDenied) {//用户拒绝
            NSLog(@"用户拒绝");
        }else{//用户已授权
            NSLog(@"用户已授权");
            dispatch_async(dispatch_get_main_queue(), ^{
                _images = [self getFetchResult:[self getPhotoList].firstObject ascend:NO];
                [collectionView reloadData];
                if (self.selectType == PVTSelectTypeMultiple) {
                    collectionView.allowsMultipleSelection = YES;
                }
            });

        }
    }];
    
    
}

/** 获取相册 */
- (NSMutableArray<PHAssetCollection *> *)getPhotoList
{
    NSMutableArray *dataArray = [NSMutableArray array];
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [dataArray addObject:[result objectAtIndex:0]];
    PHFetchResult *smartAlbumsFetchResult1 = [PHAssetCollection fetchTopLevelUserCollectionsWithOptions:nil];
    for (PHAssetCollection *sub in smartAlbumsFetchResult1) {
        [dataArray addObject:sub];
    }
    return dataArray;
}

/** 获取某个相册的结果集 */
-(PHFetchResult<PHAsset *> *)getFetchResult:(PHAssetCollection *)assetCollection ascend:(BOOL)ascend
{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f) {
        options.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
    }
    //时间排序
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascend]];
    PHFetchResult *allPhotosResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    return allPhotosResult;
}

/** 获取缩略图 */
- (UIImage *)getThumbnail:(PHAsset *)asset width:(CGFloat)width
{
    CGSize targetSize;
     __block UIImage *thumbnail = nil;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    CGFloat pixW = asset.pixelWidth;
    CGFloat pixH = asset.pixelHeight;
    CGFloat aspectRatio = pixW / pixH;
    targetSize.width = width * aspectRatio;
    targetSize.height = width / aspectRatio;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) thumbnail = result;
    }];
    return thumbnail;
}


/** 获取高清图片 */
- (void)getOriginalImage:(PHAsset *)asset callBack:(void (^)(UIImage *originalImage))callBack
{
    __block UIImage *originalImage = nil;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        if (imageData) {
            originalImage = [UIImage imageWithData:imageData];
            callBack(originalImage);
        }
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"PVTSelectPictureCellID";
    PVTSelectPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (self.selectType == PVTSelectTypeMultiple) {
        cell.statusView.hidden = NO;
    }else{
        cell.statusView.hidden = YES;
    }
    PHAsset *asset = (PHAsset *)_images[indexPath.row];
    cell.imageView.image = [self getThumbnail:asset width:ScreenWidth];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectType == PVTSelectTypeMultiple) {
        
    } else{
        PHAsset *asset = (PHAsset *)_images[indexPath.row];
        PVTEditorViewController *editorVC = [[PVTEditorViewController alloc] init];
        [self presentViewController:editorVC animated:YES completion:nil];
        [self getOriginalImage:asset callBack:^(UIImage *originalImage) {
            editorVC.imageView.image = originalImage;
        }];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [self updateTitle];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([[collectionView indexPathsForSelectedItems] containsObject:indexPath]) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        [self collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
        return NO;
    }
    if ([collectionView indexPathsForSelectedItems].count >= 9) {
        return NO;
    }
    return YES;
}



@end

@implementation PVTSelectPictureCell

- (void)setSelected:(BOOL)selected
{
    [self.statusView setHighlighted:selected];
}

@end

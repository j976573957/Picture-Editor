//
//  PVTEqualSpaceFlowLayout.m
//  Picture-Editor
//
//  Created by Mac on 2018/9/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTEqualSpaceFlowLayout.h"

@implementation PVTEqualSpaceFlowLayout
{
    //在居中对齐的时候需要知道这行所有cell的宽度总和
    CGFloat _sumWidth ;
}

-(instancetype)init{
    self = [super init];
    if (self){
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = 5;
        self.minimumInteritemSpacing = 5;
        self.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _itemSpace = 5.0;
        _cellType = PVTAlignTypeLeft;
    }
    return self;
}

-(instancetype)initWthType:(PVTAlignType)cellType{
    self = [super init];
    if (self){
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = 5;
        self.minimumInteritemSpacing = 5;
        self.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _itemSpace = 5.0;
        _cellType = cellType;
    }
    return self;
}

- (CGSize)collectionViewContentSize
{
    if (_cellType == PVTAlignTypeNatural) {
        return self.collectionView.size;
    }
    return [super collectionViewContentSize];
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray * layoutAttributes_t = [super layoutAttributesForElementsInRect:rect];
    NSArray * layoutAttributes = [[NSArray alloc]initWithArray:layoutAttributes_t copyItems:YES];
    //用来临时存放一行的Cell数组
    NSMutableArray * layoutAttributesTemp = [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index < layoutAttributes.count ; index++) {
        
        UICollectionViewLayoutAttributes *currentAttr = layoutAttributes[index]; // 当前cell的位置信息
        UICollectionViewLayoutAttributes *previousAttr = index == 0 ? nil : layoutAttributes[index-1]; // 上一个cell 的位置信
        UICollectionViewLayoutAttributes *nextAttr = index + 1 == layoutAttributes.count ?
        nil : layoutAttributes[index+1];//下一个cell 位置信息
        
        //加入临时数组
        [layoutAttributesTemp addObject:currentAttr];
        _sumWidth += currentAttr.frame.size.width;
        
        CGFloat previousY = previousAttr == nil ? 0 : CGRectGetMaxY(previousAttr.frame);
        CGFloat currentY = CGRectGetMaxY(currentAttr.frame);
        CGFloat nextY = nextAttr == nil ? 0 : CGRectGetMaxY(nextAttr.frame);
        //如果当前cell是单独一行
        if (currentY != previousY && currentY != nextY){
            if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                [layoutAttributesTemp removeAllObjects];
                _sumWidth = 0.0;
            }else if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]){
                [layoutAttributesTemp removeAllObjects];
                _sumWidth = 0.0;
            }else{
                [self setCellFrameWith:layoutAttributesTemp];
            }
        }
        //如果下一个不cell在本行，则开始调整Frame位置
        else if( currentY != nextY) {
            [self setCellFrameWith:layoutAttributesTemp];
        }
    }
    return layoutAttributes;
}

-(void)setCellFrameWith:(NSMutableArray*)layoutAttributes{
    CGFloat nowWidth = 0.0;
    switch (_cellType) {
        case PVTAlignTypeLeft:
            nowWidth = self.sectionInset.left;
            for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
                CGRect nowFrame = attributes.frame;
                nowFrame.origin.x = nowWidth;
                attributes.frame = nowFrame;
                nowWidth += nowFrame.size.width + self.itemSpace;
            }
            _sumWidth = 0.0;
            [layoutAttributes removeAllObjects];
            break;
        case PVTAlignTypeCenter:
            nowWidth = (self.collectionView.frame.size.width - _sumWidth - ((layoutAttributes.count - 1) * _itemSpace)) / 2;
            for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
                CGRect nowFrame = attributes.frame;
                nowFrame.origin.x = nowWidth;
                attributes.frame = nowFrame;
                nowWidth += nowFrame.size.width + self.itemSpace;
            }
            _sumWidth = 0.0;
            [layoutAttributes removeAllObjects];
            break;
            
        case PVTAlignTypeRight:
            nowWidth = self.collectionView.frame.size.width - self.sectionInset.right;
            for (NSInteger index = layoutAttributes.count - 1 ; index >= 0 ; index-- ) {
                UICollectionViewLayoutAttributes * attributes = layoutAttributes[index];
                CGRect nowFrame = attributes.frame;
                nowFrame.origin.x = nowWidth - nowFrame.size.width;
                attributes.frame = nowFrame;
                nowWidth = nowWidth - nowFrame.size.width - _itemSpace;
            }
            _sumWidth = 0.0;
            [layoutAttributes removeAllObjects];
            break;
        case PVTAlignTypeNatural:
            nowWidth = self.sectionInset.left;
            if (layoutAttributes.count <= 1) {
                //以后再处理，来不及了。
                _sumWidth = 0.0;
                [layoutAttributes removeAllObjects];
                break;
            }
            CGFloat gap = (CGRectGetWidth(self.collectionView.frame) - _sumWidth - self.sectionInset.left - self.sectionInset.right)/ (layoutAttributes.count-1);
            for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
                CGRect nowFrame = attributes.frame;
                nowFrame.origin.x = nowWidth;
                attributes.frame = nowFrame;
                nowWidth += nowFrame.size.width + gap;
            }
            _sumWidth = 0.0;
            [layoutAttributes removeAllObjects];
            break;
    }
}

@end

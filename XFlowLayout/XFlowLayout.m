//
//  XFlowLayout.m
//  XFlowLayout
//
//  Created by Leo on 2019/10/10.
//  Copyright © 2019 Leo. All rights reserved.
//

#import "XFlowLayout.h"

@interface XFlowLayout()

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArray;
@property (nonatomic, strong) NSMutableArray *maxPositionArray;

@end

@implementation XFlowLayout

#pragma mark - 系统方法重写
- (instancetype)init
{
    self = [super init];
    if (self) {
        _rowCount = 1;
        _rowSpacing = 0;
        _columnCount = 1;
        _columnSpacing = 0;
        _sectionInset = UIEdgeInsetsZero;
        _scrollDirection = UICollectionViewScrollDirectionVertical;
        _attributesArray = [NSMutableArray array];
        _maxPositionArray = [NSMutableArray array];
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    // data source
    [self.attributesArray removeAllObjects];
    [self.maxPositionArray removeAllObjects];
    
    if (_scrollDirection == UICollectionViewScrollDirectionVertical) {
        for (int i = 0; i < _columnCount; i ++) {
            [_maxPositionArray addObject:@(0)];
        }
    } else if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        for (int i = 0; i < _rowCount; i ++) {
            [_maxPositionArray addObject:@(0)];
        }
    }
    
    // section
    NSInteger sCount = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < sCount; section++) {
        
        // header
        NSIndexPath *indexPath_h = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *attr_h = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath_h];
        if (attr_h) {
            [_attributesArray addObject:attr_h];
        }
        
        // cell
        NSInteger rCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger row = 0; row < rCount; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
            if (attr) {
                [_attributesArray addObject:attr];
            }
        }
        
        // footer
        NSIndexPath *indexPath_f = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *attr_f = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath_f];
        if (attr_f) {
            [_attributesArray addObject:attr_f];
        }
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesArray;
}

- (CGSize)collectionViewContentSize {
    CGFloat max = 0;
    for (NSInteger i = 0; i < _maxPositionArray.count; i++) {
        CGFloat position = [_maxPositionArray[i] doubleValue];
        max = MAX(position, max);
    }
    if (_scrollDirection == UICollectionViewScrollDirectionVertical) {
        return CGSizeMake(0, max);
    }else if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        return CGSizeMake(max, 0);
    }
    return CGSizeZero;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    CGRect frame = CGRectZero;
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        frame = [self frameOfHeaderInSection:indexPath.section];
    }else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        frame = [self frameOfFooterInSection:indexPath.section];
    }
    if (_scrollDirection == UICollectionViewScrollDirectionVertical && frame.size.height <= 0.1) {
        return nil;
    }
    if (_scrollDirection == UICollectionViewScrollDirectionHorizontal && frame.size.width <= 0.1) {
        return nil;
    }
    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    attr.frame = frame;
    return attr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame = [self frameOfItemAtIndexPath:indexPath];
    return attr;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}

- (BOOL)flipsHorizontallyInOppositeLayoutDirection {
    return YES;
}

#pragma mark - 工具方法
- (CGRect)frameOfItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect frame = CGRectZero;
    if (_scrollDirection == UICollectionViewScrollDirectionVertical) {
        CGFloat h = 0;
        if (self.delegate && [self.delegate respondsToSelector:@selector(xLayout:heightForItemAtIndexPath:)]) {
            h = [self.delegate xLayout:self heightForItemAtIndexPath:indexPath];
        }
        CGFloat w = (self.collectionView.frame.size.width - _sectionInset.left - _sectionInset.right - (_columnCount - 1) * _columnSpacing) / _columnCount;
        CGFloat minY = [_maxPositionArray.firstObject floatValue];
        NSInteger minYIndex = 0;
        for (int i = 0; i < _columnCount; i ++) {
            CGFloat y = [_maxPositionArray[i] floatValue];
            if (y < minY) {
                minY = y;
                minYIndex = i;
            }
        }
        CGFloat x = _sectionInset.left + (_columnSpacing + w) * minYIndex;
        CGFloat y = minY;
        frame = CGRectMake(x, y, w, h);
        _maxPositionArray[minYIndex] = @(CGRectGetMaxY(frame) + _rowSpacing);
        return frame;
    } else {
        CGFloat w = 0;
        if (self.delegate && [self.delegate respondsToSelector:@selector(xLayout:widthForItemAtIndexPath:)]) {
            w = [self.delegate xLayout:self widthForItemAtIndexPath:indexPath];
        }
        CGFloat h = (self.collectionView.frame.size.height - _sectionInset.top - _sectionInset.bottom - (_rowCount - 1) * _rowSpacing) / _rowCount;
        CGFloat minX = [_maxPositionArray.firstObject floatValue];
        NSInteger minRowIndex = 0;
        for (int i = 0; i < _maxPositionArray.count; i ++) {
            CGFloat x = [_maxPositionArray[i] floatValue];
            if (x < minX) {
                minX = x;
                minRowIndex = i;
            }
        }
        CGFloat x = minX;
        CGFloat y = _sectionInset.top + (_rowSpacing + h) * minRowIndex;
        frame = CGRectMake(x, y, w, h);
        _maxPositionArray[minRowIndex] = @(CGRectGetMaxX(frame) + _columnSpacing);
    }
    return frame;
}

- (CGRect)frameOfHeaderInSection:(NSInteger)section {
    CGRect frame = CGRectZero;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = 0;
    CGFloat height = 0;
    if (_scrollDirection == UICollectionViewScrollDirectionVertical) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(xLayout:heightForHeaderInSection:)]) {
            height = [self.delegate xLayout:self heightForHeaderInSection:section];
        }
        width = CGRectGetWidth(self.collectionView.frame);
        
        for (NSInteger i = 0; i < _maxPositionArray.count; i++) {
            CGFloat maxHeight = [_maxPositionArray[i] doubleValue];
            y = MAX(y, maxHeight);
        }
        
        frame = CGRectMake(x, y, width, height);
        for (NSInteger i = 0; i < _maxPositionArray.count; i++) {
            _maxPositionArray[i] = @(CGRectGetMaxY(frame) + _sectionInset.top);
        }
    }else if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(xLayout:widthForHeaderInSection:)]) {
            width = [self.delegate xLayout:self widthForHeaderInSection:section];
        }
        height = CGRectGetHeight(self.collectionView.frame);
        
        for (NSInteger i = 0; i < _maxPositionArray.count; i++) {
            CGFloat maxHeight = [_maxPositionArray[i] doubleValue];
            x = MAX(x, maxHeight);
        }
        
        frame = CGRectMake(x, y, width, height);
        for (NSInteger i = 0; i < _maxPositionArray.count; i++) {
            _maxPositionArray[i] = @(CGRectGetMaxX(frame) + _sectionInset.left);
        }
    }
    return frame;
}

- (CGRect)frameOfFooterInSection:(NSInteger)section {
    CGRect frame = CGRectZero;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = 0;
    CGFloat height = 0;
    if (_scrollDirection == UICollectionViewScrollDirectionVertical) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(xLayout:heightForFooterInSection:)]) {
            height = [self.delegate xLayout:self heightForFooterInSection:section];
        }
        width = CGRectGetWidth(self.collectionView.frame);
        for (NSInteger i = 0; i < _maxPositionArray.count; i++) {
            CGFloat max = [_maxPositionArray[i] doubleValue];
            y = MAX(y, max);
        }
        
        y = y - _rowSpacing + _sectionInset.bottom;
        
        frame = CGRectMake(x, y, width, height);
        for (NSInteger i = 0; i < _maxPositionArray.count; i++) {
            _maxPositionArray[i] = @(CGRectGetMaxY(frame));
        }
    }else if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(xLayout:widthForFooterInSection:)]) {
            width = [self.delegate xLayout:self widthForFooterInSection:section];
        }
        height = CGRectGetHeight(self.collectionView.frame);
        
        for (NSInteger i = 0; i < _maxPositionArray.count; i++) {
            CGFloat max = [_maxPositionArray[i] doubleValue];
            x = MAX(x, max);
        }
        
        x = x - _columnSpacing + _sectionInset.right;
        
        frame = CGRectMake(x, y, width, height);
        for (NSInteger i = 0; i < _maxPositionArray.count; i++) {
            _maxPositionArray[i] = @(CGRectGetMaxX(frame));
        }
    }
    return frame;
}

@end

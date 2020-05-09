//
//  XFlowLayout.h
//  XFlowLayout
//
//  Created by Leo on 2019/10/10.
//  Copyright © 2019 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XFlowLayout;

@protocol XFlowLayoutDelegate <NSObject>

@optional

// height is available on vertical scroll
- (CGFloat)xLayout:(XFlowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)xLayout:(XFlowLayout *)layout heightForHeaderInSection:(NSInteger)section;
- (CGFloat)xLayout:(XFlowLayout *)layout heightForFooterInSection:(NSInteger)section;

// width is available on horizontal scroll
- (CGFloat)xLayout:(XFlowLayout *)layout widthForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)xLayout:(XFlowLayout *)layout widthForHeaderInSection:(NSInteger)section;
- (CGFloat)xLayout:(XFlowLayout *)layout widthForFooterInSection:(NSInteger)section;

@end

@interface XFlowLayout : UICollectionViewLayout

@property (nonatomic, strong) id<XFlowLayoutDelegate> delegate;
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

// vertical scroll available
@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, assign) CGFloat columnSpacing;

// horizontal scroll available
@property (nonatomic, assign) NSInteger rowCount;
@property (nonatomic, assign) CGFloat rowSpacing;

// section edge inset
@property (nonatomic, assign) UIEdgeInsets sectionInset;

@end

NS_ASSUME_NONNULL_END

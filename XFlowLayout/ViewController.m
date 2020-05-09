//
//  ViewController.m
//  XFlowLayout
//
//  Created by Leo on 2019/10/10.
//  Copyright © 2019 Leo. All rights reserved.
//

#import "ViewController.h"
#import "XFlowLayout.h"
#import "CollectionViewCell.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, XFlowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // layout
    XFlowLayout *layout = [[XFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.delegate = self;
    layout.rowCount = 3;
    layout.columnCount = 3;
    layout.rowSpacing = 20;
    layout.columnSpacing = 20;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    // collection view
    CGFloat navHeight = [[UIApplication sharedApplication] statusBarFrame].size.height + 44.f;
    CGRect frame = CGRectMake(0, navHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - navHeight);
    self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeaderView"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"collectionFooterView"];
    [self.view addSubview:self.collectionView];
}

#pragma mark - XFlowLayoutDelegate
- (CGFloat)xLayout:(XFlowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
   return arc4random_uniform(150) + 100;
}

- (CGFloat)xLayout:(XFlowLayout *)layout widthForItemAtIndexPath:(NSIndexPath *)indexPath {
    return arc4random_uniform(150) + 100;
}

- (CGFloat)xLayout:(XFlowLayout *)layout heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)xLayout:(XFlowLayout *)layout heightForFooterInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)xLayout:(XFlowLayout *)layout widthForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)xLayout:(XFlowLayout *)layout widthForFooterInSection:(NSInteger)section {
    return 44;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    cell.titleLab.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"collectionHeaderView" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor redColor];
        return headerView;
    }else {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"collectionFooterView" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor greenColor];
        return headerView;
    }
}

@end

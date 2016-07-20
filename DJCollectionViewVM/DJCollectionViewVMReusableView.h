//
//  DJCollectionViewVMReusableView.h
//  DJComponentCollectionViewVM
//
//  Created by Dokay on 16/7/20.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DJCollectionViewVM;
@class DJCollectionViewVMSection;
@class DJCollectionViewVMReusable;

@protocol DJCollectionViewVMReusableViewProtocol <NSObject>
@property (weak, nonatomic  ) DJCollectionViewVM *collectionViewVM;
@property (weak, nonatomic  ) UICollectionView *parentCollectionView;
@property (weak, nonatomic  ) DJCollectionViewVMSection *sectionVM;
@property (strong, nonatomic) DJCollectionViewVMReusable *reusableVM;
@property (assign, nonatomic) NSInteger sectionIndex;
@property (nonatomic, assign) BOOL loaded;

- (void)viewDidLoad;
- (void)viewWillAppear;
- (void)viewDidDisappear;

@optional
+ (CGSize)sizeWithResuableVM:(DJCollectionViewVMReusable *)resuableVM collectionViewVM:(DJCollectionViewVM *)collectionViewVM;

@end

@interface DJCollectionViewVMReusableView : UICollectionReusableView<DJCollectionViewVMReusableViewProtocol>

@property (weak, nonatomic  ) DJCollectionViewVM *collectionViewVM;
@property (weak, nonatomic  ) UICollectionView *parentCollectionView;
@property (weak, nonatomic  ) DJCollectionViewVMSection *sectionVM;
@property (strong, nonatomic) DJCollectionViewVMReusable *reusableVM;
@property (assign, nonatomic) NSInteger sectionIndex;
@property (nonatomic, assign) BOOL loaded;

- (void)viewDidLoad;
- (void)viewWillAppear;
- (void)viewDidDisappear;

+ (CGSize)sizeWithResuableVM:(DJCollectionViewVMReusable *)resuableVM collectionViewVM:(DJCollectionViewVM *)collectionViewVM;

@end

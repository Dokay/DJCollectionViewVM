//
//  DJCollectionViewReusableTitleWithNibView.m
//  DJComponentCollectionViewVM
//
//  Created by Dokay on 16/7/20.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJCollectionViewReusableTitleWithNibView.h"

@interface DJCollectionViewReusableTitleWithNibView()

@property (nonatomic, weak) IBOutlet UILabel *contentLabel;

@end

@implementation DJCollectionViewReusableTitleWithNibView
@synthesize reusableVM = _reusableVM;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear
{
    [super viewWillAppear];
    
    self.contentLabel.text = self.reusableVM.title;
}

@end

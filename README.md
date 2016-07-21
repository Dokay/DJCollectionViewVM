# DJCollectionVM

__DJCollectionViewVM is a light ViewModel implementation for UICollectionView.__

##Features
* less code and more flexible to implement UICollectionView with UICollectionViewFlowLayout;
* dynamic cell and SupplementaryView size caculate;
* header and footer support like UITableView;
* prefetch for iOS 7.0+;

## Requirements
* Xcode 7 or higher
* Apple LLVM compiler
* iOS 7.0 or higher
* ARC

## Demo

Build and run the `DJComponentCollectionViewVM.xcodeproj` in Xcode.


## Installation

###  CocoaPods
Edit your Podfile and add DJCollectionViewVM:

``` bash
pod 'DJCollectionViewVM'
```

## Quickstart
* Sample code
```objc
- (void)testNormal
{
    [self.collectionVM removeAllSections];
    
    DJCollectionViewVMSection *contentSection = [DJCollectionViewVMSection sectionWithHeaderHeight:10];
    contentSection.minimumLineSpacing = 10.0f;
    contentSection.minimumInteritemSpacing = 10.0f;
    [self.collectionVM addSection:contentSection];
    for (NSInteger i = 0; i < 15; i ++) {
        NSInteger random = arc4random() % 10;
        DJCollectionViewVMRow *row = [DJCollectionViewVMRow new];
        row.itemSize = CGSizeMake(random * 20, 40);
        row.backgroundColor = [UIColor redColor];
        [row setSelectionHandler:^(DJCollectionViewVMRow *rowVM) {
            NSLog(@"tap %@",rowVM.indexPath);
        }];
        [contentSection addRow:row];
    }
    
    DJCollectionViewVMSection *contentBigSection = [DJCollectionViewVMSection sectionWithHeaderHeight:10];
    contentBigSection.minimumLineSpacing = 10.0f;
    contentBigSection.minimumInteritemSpacing = 10.0f;
    [self.collectionVM addSection:contentBigSection];
    for (NSInteger i = 0; i < 20; i ++) {
        NSInteger random = arc4random() % 5;
        DJCollectionViewVMRow *row = [DJCollectionViewVMRow new];
        row.itemSize = CGSizeMake(random * 20, random * 10);
        row.backgroundColor = [UIColor purpleColor];
        [row setSelectionHandler:^(DJCollectionViewVMRow *rowVM) {
            NSLog(@"tap %@",rowVM.indexPath);
        }];
        [contentBigSection addRow:row];
    }
    
    [self.collectionView reloadData];
}

- (void)testAutoLayoutWithNib
{
    self.collectionVM[@"DJCollectionViewTitleCellRow"] = @"DJCollectionViewLongTitleCell";
    [self.collectionVM removeAllSections];
    
    DJCollectionViewVMSection *contentSection = [DJCollectionViewVMSection sectionWithHeaderHeight:10];
    contentSection.minimumLineSpacing = 10.0f;
    contentSection.minimumInteritemSpacing = 10.0f;
    [self.collectionVM addSection:contentSection];
    
    NSArray *wordsArray = [kConstContent componentsSeparatedByString:@" "];
    for (NSInteger i = 0; i < wordsArray.count; i ++) {
        DJCollectionViewTitleCellRow *row = [DJCollectionViewTitleCellRow new];
        row.title = wordsArray[i];
        row.sizeCaculateType = DJCellSizeCaculateAutoLayout;
        [row setSelectionHandler:^(DJCollectionViewVMRow *rowVM) {
            NSLog(@"tap %@",rowVM.indexPath);
        }];
        [contentSection addRow:row];
    }
    [self.collectionView reloadData];
}

```

* API
<table>
  <tr><th colspan="2" style="text-align:center;">Key Classes</th></tr>
  <tr>
    <td>DJCollectionViewVM</td>
    <td>The ViewModel for <tt>UICollectionView</tt>, which has implemented UICollectionViewDelegate , UICollectionViewDataSource and UICollectionViewDelegateFlowLayout. It has multiple <tt>DJCollectionViewVMSection</tt> sections.</td>
  </tr>
  <tr>
    <td>DJCollectionViewVMSection</td>
    <td>The ViewModel for sections in <tt>DJCollectionViewVM</tt>, each section has multiple <tt>DJCollectionViewVMRow</tt> rows.</td>
  </tr>
  <tr>
    <td>DJCollectionViewVMRow</td>
    <td>The ViewModel for rows in section,it is the root class of all <tt>DJCollectionViewVM</tt> row hierarchies.<br />
        You should subclass <tt>DJCollectionViewVMRow</tt> to obtain cell characteristics specific to your application's needs.
        Through <tt>DJCollectionViewVMRow</tt>, rows inherit a basic interface that communicates with <tt>DJCollectionViewVM</tt> and <tt>DJCollectionViewVMSection</tt>.</td>
  </tr>
  <tr>
    <td>DJCollectionViewVMCell</td>
    <td>The View for DJCollectionViewVMRow(ViewModel),it defines the attributes and behavior of the cells that appear in <tt>UICollectionView</tt> objects.
        You should subclass <tt>DJCollectionViewVMCell</tt> to obtain cell characteristics and behavior specific to your application's needs.
        By default, it is being mapped with <tt>DJCollectionViewVMRow</tt>.</td>
  </tr>
  <tr>
    <td>DJCollectionViewVMReusable</td>
    <td>The ViewModel for supplementary view in section header and footer,it is the root class of all <tt>DJCollectionViewVM</tt> supplementary view hierarchies.<br />
        You should subclass <tt>DJCollectionViewVMReusable</tt> to obtain supplementary view characteristics specific to your application's needs.
        Through <tt>DJCollectionViewVMReusable</tt>, supplementary views inherit a basic interface that communicates with <tt>DJCollectionViewVM</tt> and <tt>DJCollectionViewVMSection</tt>.</td>
  </tr>
  <tr>
    <td>DJCollectionViewVMReusableView</td>
    <td>The View for DJCollectionViewVMReusable(ViewModel),it defines the attributes and behavior of the supplementary views that appear in <tt>UICollectionView</tt> objects.
        You should subclass <tt>DJCollectionViewVMReusableView</tt> to obtain supplementary view characteristics and behavior specific to your application's needs.
        By default, it is being mapped with <tt>DJCollectionViewVMReusable</tt>.</td>
  </tr>
</table>

* For exsist cells in your project
    1.If the super class of your cell is UICollectionViewCell ,just change it to DJCollectionViewVMCell.
    2.If tht super class of your cell is your custom class ,you need to implement the protocol DJCollectionViewVMCellDelegate or change it to DJCollectionViewVMCell.


##UITableView

ViewModel for UITableView: [DJTableViewVM](http://github.com/Dokay/DJTableViewVM)


## Contact

Dokay Dou

- https://github.com/Dokay
- http://www.douzhongxu.com
- dokay_dou@163.com

## License

DJCollectionViewVM is available under the MIT license.

Copyright © 2016 Dokay Dou.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

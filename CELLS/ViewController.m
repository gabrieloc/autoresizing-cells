//
//  ViewController.m
//  CELLS
//
//  Created by Gabriel O'Flaherty-Chan on 2016-02-03.
//  Copyright © 2016 Gabrieloc. All rights reserved.
//


#import "ViewController.h"

#define color (arc4random() % 255) / 255.0f

NSString *const khalid = @"Lorem Khaled Ipsum is a major key to success. You see the hedges, how I got it shaped up? It’s important to shape up your hedges, it’s like getting a haircut, stay fresh. Special cloth alert. Mogul talk. Eliptical talk. I told you all this before, when you have a swimming pool, do not use chlorine, use salt water, the healing, salt water is the healing. The key to success is to keep your head above the water, never give up. Major key, don’ fall for the trap, stay focused. It’s the ones closest to you that want to see you fail.";

@interface Cell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@end

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) NSMutableDictionary *data;
@property (readonly) UICollectionViewFlowLayout *collectionViewFlowLayout;
@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.data = [NSMutableDictionary dictionary];
	self.collectionViewFlowLayout.estimatedItemSize = CGSizeMake(100, 100);
	[self.slider addTarget:self action:@selector(sliderUpdated:) forControlEvents:UIControlEventValueChanged];
	self.slider.value = 0.2;
	[self sliderUpdated:self.slider];
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout
{
	return (id)self.collectionViewLayout;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSNumber *key = @(indexPath.item);
	if ([self.data objectForKey:key] == nil) {
		if (arc4random() % 2 == 0) {
			self.data[key] = [NSString stringWithFormat:@"khalid%@", @((arc4random() % 5) + 1)];
		} else {
			self.data[key] = @[[khalid substringToIndex:arc4random() % khalid.length], [UIColor colorWithRed:color green:color blue:color alpha:1]];
		}
	}
	
	Cell *cell;
	if ([self.data[key] isKindOfClass:[NSString class]]) {
		cell = (id)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
		cell.imageView.image = [UIImage imageNamed:self.data[key]];
		
		CGFloat imageRatio = cell.imageView.image.size.height / cell.imageView.image.size.width;
		
		CGRect frame = UIEdgeInsetsInsetRect(collectionView.bounds, cell.layoutMargins);
		frame = UIEdgeInsetsInsetRect(frame, self.collectionViewFlowLayout.sectionInset);
		cell.imageViewWidthConstraint.constant = CGRectGetWidth(frame) - 1;
		cell.imageViewHeightConstraint.constant = cell.imageViewWidthConstraint.constant * imageRatio;
		
		cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
		
	} else {
		cell = (id)[collectionView dequeueReusableCellWithReuseIdentifier:@"TextCell" forIndexPath:indexPath];
		cell.label.text = self.data[key][0];
		cell.backgroundColor = self.data[key][1];
		
		CGRect frame = UIEdgeInsetsInsetRect(collectionView.bounds, cell.layoutMargins);
		frame = UIEdgeInsetsInsetRect(frame, self.collectionViewFlowLayout.sectionInset);
		cell.label.preferredMaxLayoutWidth = CGRectGetWidth(frame) - 1;
	}

	
	return cell;
}

- (void)sliderUpdated:(UISlider *)sender
{
	// Prevent cells from going into 2 columns
	CGFloat inset = sender.value * (CGRectGetMidX(self.collectionView.bounds) * 0.5);
	self.collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
	[self.collectionView reloadData];
}

@end


@implementation Cell

- (void)prepareForReuse
{
	[super prepareForReuse];
	
	self.label.text = nil;
	self.imageView.image = nil;
}

@end
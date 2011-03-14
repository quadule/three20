//
//  TTTableStyledMessageItemCell.h
//  Three20UI
//
//  Created by Milo on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TTTableLinkedItemCell.h"
#import "TTTableStyledMessageItem.h"
#import "TTImageView.h"
#import "TTStyledTextLabel.h"


@interface TTTableStyledMessageItemCell : TTTableLinkedItemCell {
    UILabel*      _titleLabel;
    UILabel*      _timestampLabel;
    TTStyledTextLabel *_detailedTextLabel;
    TTImageView*  _imageView2;
}

@property (nonatomic, readonly, retain) UILabel*      titleLabel;
@property (nonatomic, readonly)         UILabel*      captionLabel;
@property (nonatomic, readonly, retain) UILabel*      timestampLabel;
@property (nonatomic, readonly, retain) TTImageView*  imageView2;
@property (nonatomic, readonly, retain) TTStyledTextLabel* detailedTextLabel;

@end

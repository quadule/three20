//
//  TTTableStyledMessageItemCell.m
//  Three20UI
//
//  Created by Milo on 3/10/11.
//  Copyright 2011 Artexpo. All rights reserved.
//

#import "TTTableStyledMessageItemCell.h"

#import "Three20UICommon/TTGlobalUICommon.h"

// Style
#import "Three20Style/TTGlobalStyle.h"
#import "Three20Style/TTDefaultStyleSheet.h"
#import "Three20Style/TTStyledText.h"
#import "Three20Style/UIFontAdditions.h"

#import "Three20UI/UIViewAdditions.h"
#import "Three20Core/NSDateAdditions.h"

// Core
#import "Three20Core/TTCorePreprocessorMacros.h"

static const CGFloat kDefaultMessageImageWidth  = 34;
static const CGFloat kDefaultMessageImageHeight = 34;
static const CGFloat kMargin                    = 10;

@implementation TTTableStyledMessageItemCell

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableStyledMessageItemCell class public

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    TTTableStyledMessageItem* item = object;
    CGFloat left = 0.0;

    if (item.imageURL) left += kTableCellSmallMargin + kDefaultMessageImageHeight + kTableCellSmallMargin;
    item.text.width = tableView.width - left - kTableCellSmallMargin;

    CGFloat height = item.text.height + kTableCellSmallMargin*2;
    
    if (height < ttkDefaultRowHeight) {
        return ttkDefaultRowHeight;

    } else {
        return height;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if ((self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier])) {
		_titleLabel = nil;
		_timestampLabel = nil;
		_imageView2 = nil;
		_detailedTextLabel = nil;

		self.textLabel.font = TTSTYLEVAR(font);
		self.textLabel.textColor = TTSTYLEVAR(textColor);
		self.textLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
		self.textLabel.textAlignment = UITextAlignmentLeft;
		self.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
		self.textLabel.adjustsFontSizeToFitWidth = YES;
		self.textLabel.contentMode = UIViewContentModeLeft;
    }
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_titleLabel);
	TT_RELEASE_SAFELY(_timestampLabel);
	TT_RELEASE_SAFELY(_imageView2);
    TT_RELEASE_SAFELY(_detailedTextLabel);
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)prepareForReuse {
    [super prepareForReuse];
    [_imageView2 unsetImage];
    _titleLabel.text = nil;
    self.captionLabel.text = nil;
    _detailedTextLabel.text = nil;
    _timestampLabel.text = nil;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	CGFloat left = 0;
	if (_imageView2) {
		_imageView2.frame = CGRectMake(kTableCellSmallMargin, kTableCellSmallMargin,
                                       kDefaultMessageImageWidth, kDefaultMessageImageHeight);
		left += kTableCellSmallMargin + kDefaultMessageImageHeight + kTableCellSmallMargin;

    } else {
		left = kMargin;
	}

	CGFloat width = self.contentView.width - left - kTableCellSmallMargin;
	CGFloat top = kTableCellSmallMargin-3;

    if (_timestampLabel.text.length) {
		[_timestampLabel sizeToFit];
        _timestampLabel.left = self.contentView.width - (_timestampLabel.width + kTableCellSmallMargin);
		_timestampLabel.top = top;
        //_timestampLabel.width -= _titleLabel.width + kTableCellSmallMargin*2;

	} else {
		_titleLabel.frame = CGRectZero;
	}

	if (_titleLabel.text.length) {
		_titleLabel.frame = CGRectMake(left, top, width, _titleLabel.font.ttLineHeight);
		top += _titleLabel.height;

	} else {
		_titleLabel.frame = CGRectZero;
	}

	if (self.captionLabel.text.length) {
		self.captionLabel.frame = CGRectMake(left, top, width, self.captionLabel.font.ttLineHeight);
		top += self.captionLabel.height;

	} else {
		self.captionLabel.frame = CGRectZero;
	}

	if ([self.detailedTextLabel text] != nil) {
		//CGFloat textHeight = [[self.detailedTextLabel font] ttLineHeight] * (kMessageTextLineCount + (self.captionLabel.text.length ? 0 : 1));
		//self.detailedTextLabel.frame = CGRectMake(left, top, width, self.detailedTextLabel.text.height);
        [_detailedTextLabel sizeToFit];
        _detailedTextLabel.left = left;
        _detailedTextLabel.top = top;

	} else {
		self.detailedTextLabel.frame = CGRectZero;
	}
}

- (void)didMoveToSuperview {
	[super didMoveToSuperview];
	if (self.superview) {
		_imageView2.backgroundColor = self.backgroundColor;
		_titleLabel.backgroundColor = self.backgroundColor;
		_timestampLabel.backgroundColor = self.backgroundColor;
		_detailedTextLabel.backgroundColor = self.backgroundColor;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewCell

- (void)setObject:(id)object {
	if (_item != object) {
		[super setObject:object];

		TTTableStyledMessageItem* item = object;
		if (item.title.length) {
			self.titleLabel.text = item.title;
		}
		if (item.caption.length) {
			self.captionLabel.text = item.caption;
		}
		if (item.text.rootFrame != nil) {
			[self.detailedTextLabel setText: item.text];
		}
		if (item.timestamp) {
			self.timestampLabel.text = [item.timestamp formatShortTime];
		}
		if (item.imageURL) {
			self.imageView2.urlPath = item.imageURL;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// public

- (UILabel*)titleLabel {
	if (!_titleLabel) {
		_titleLabel = [[UILabel alloc] init];
		_titleLabel.textColor = [UIColor blackColor];
		_titleLabel.highlightedTextColor = [UIColor whiteColor];
		_titleLabel.font = TTSTYLEVAR(tableFont);
		_titleLabel.contentMode = UIViewContentModeLeft;
		[self.contentView addSubview:_titleLabel];
	}
	return _titleLabel;
}

- (UILabel*)captionLabel {
	return self.textLabel;
}

- (UILabel*)timestampLabel {
	if (!_timestampLabel) {
		_timestampLabel = [[UILabel alloc] init];
		_timestampLabel.font = TTSTYLEVAR(tableTimestampFont);
		_timestampLabel.textColor = TTSTYLEVAR(timestampTextColor);
		_timestampLabel.highlightedTextColor = [UIColor whiteColor];
		_timestampLabel.contentMode = UIViewContentModeLeft;
		[self.contentView addSubview:_timestampLabel];
	}
	return _timestampLabel;
}

- (TTImageView*)imageView2 {
	if (!_imageView2) {
		_imageView2 = [[TTImageView alloc] init];
		//    _imageView2.defaultImage = TTSTYLEVAR(personImageSmall);
		//    _imageView2.style = TTSTYLE(threadActorIcon);
		[self.contentView addSubview:_imageView2];
	}
	return _imageView2;
}

- (TTStyledTextLabel*)detailedTextLabel {
	if(!_detailedTextLabel) {
		_detailedTextLabel = [[TTStyledTextLabel alloc] init];
		[self.contentView addSubview:_detailedTextLabel];
	}
	return _detailedTextLabel;
}

@end

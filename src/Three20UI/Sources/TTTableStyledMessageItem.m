//
//  TTTableStyledMessageItem.m
//  Three20UI
//
//  Created by Milo on 3/10/11.
//  Copyright 2011 Artexpo. All rights reserved.
//

#import "TTTableStyledMessageItem.h"

//Core
#import "Three20Core/TTCorePreprocessorMacros.h"

@implementation TTTableStyledMessageItem

@synthesize title = _title, caption = _caption, timestamp = _timestamp, imageURL = _imageURL;

///////////////////////////////////////////////////////////////////////////////////////////////////
// class public

+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(TTStyledText*)text
          timestamp:(NSDate*)timestamp URL:(NSString*)URL {
	TTTableStyledMessageItem* item = [[[self alloc] init] autorelease];
	item.title = title;
	item.caption = caption;
	item.text = text;
	item.timestamp = timestamp;
	item.URL = URL;
	return item;
}

+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(TTStyledText*)text
          timestamp:(NSDate*)timestamp imageURL:(NSString*)imageURL URL:(NSString*)URL {
	TTTableStyledMessageItem* item = [[[self alloc] init] autorelease];
	item.title = title;
	item.caption = caption;
	item.text = text;
	item.timestamp = timestamp;
	item.imageURL = imageURL;
	item.URL = URL;
	return item;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
	if (self = [super init]) {
		_title = nil;
		_caption = nil;
		_timestamp = nil;
		_imageURL = nil;
	}
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_title);
	TT_RELEASE_SAFELY(_caption);
	TT_RELEASE_SAFELY(_timestamp);
	TT_RELEASE_SAFELY(_imageURL);
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSCoding

- (id)initWithCoder:(NSCoder*)decoder {
	if (self = [super initWithCoder:decoder]) {
		self.title = [decoder decodeObjectForKey:@"title"];
		self.caption = [decoder decodeObjectForKey:@"caption"];
		self.timestamp = [decoder decodeObjectForKey:@"timestamp"];
		self.imageURL = [decoder decodeObjectForKey:@"imageURL"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder {
	[super encodeWithCoder:encoder];
	if (self.title) {
		[encoder encodeObject:self.title forKey:@"title"];
	}
	if (self.caption) {
		[encoder encodeObject:self.caption forKey:@"caption"];
	}
	if (self.timestamp) {
		[encoder encodeObject:self.timestamp forKey:@"timestamp"];
	}
	if (self.imageURL) {
		[encoder encodeObject:self.imageURL forKey:@"imageURL"];
	}
}

@end

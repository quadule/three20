//
//  TTTableStyledMessageItem.h
//  Three20UI
//
//  Created by Milo on 3/10/11.
//  Copyright 2011 Artexpo. All rights reserved.
//

#import "Three20UI/TTTableStyledTextItem.h"


@interface TTTableStyledMessageItem : TTTableStyledTextItem {
    NSString* _title;
    NSString* _caption;
    NSDate* _timestamp;
    NSString* _imageURL;
}

@property (nonatomic,copy) NSString* title;
@property (nonatomic,copy) NSString* caption;
@property (nonatomic,retain) NSDate* timestamp;
@property (nonatomic,copy) NSString* imageURL;

+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(TTStyledText*)text
          timestamp:(NSDate*)timestamp URL:(NSString*)URL;
+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(TTStyledText*)text
          timestamp:(NSDate*)timestamp imageURL:(NSString*)imageURL URL:(NSString*)URL;

@end

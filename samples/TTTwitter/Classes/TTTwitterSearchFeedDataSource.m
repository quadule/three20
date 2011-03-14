//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Three20UI/Three20UI.h>

#import "TTTwitterSearchFeedDataSource.h"

#import "TTTwitterSearchFeedModel.h"
#import "TTTwitterTweet.h"

// Three20 Additions
#import <Three20Core/NSDateAdditions.h>


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTTwitterSearchFeedDataSource


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithSearchQuery:(NSString*)searchQuery {
  if (self = [super init]) {
    _searchFeedModel = [[TTTwitterSearchFeedModel alloc] initWithSearchQuery:searchQuery];
    
    self.items = [NSMutableArray arrayWithObjects:[self headerItems], [self artHighlightItems], [self twitterItems], nil];
    self.sections = [NSMutableArray arrayWithObjects:@"", @"Art Highlight", @"Twitter", nil];
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  TT_RELEASE_SAFELY(_searchFeedModel);

  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<TTModel>)model {
  return _searchFeedModel;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 3;
}

- (NSArray*)headerItems {
  TTTableImageItem *image = [TTTableImageItem itemWithText:nil imageURL:@"bundle://home-header.png"];
  TTImageStyle *style = [[[TTImageStyle alloc] init] autorelease];
  style.size = CGSizeMake(320.0, 70.0);
  image.imageStyle = style;
  image.URL = @"http://artexponewyork.com";
  return [NSMutableArray arrayWithObject:image];
}

- (NSArray*)artHighlightItems {
  return [NSMutableArray array];
}

- (NSArray*)twitterItems {
  TTTableSummaryItem *headerItem = [TTTableSummaryItem itemWithText:
                                    [NSString stringWithFormat:
                                     @"Tweet with #%@ to see your posts here",
                                     _searchFeedModel.searchQuery]];
  return [NSMutableArray arrayWithObject:headerItem];
}

- (void)showLoading:(BOOL)show {
  NSMutableArray *twitterItems = [self.items objectAtIndex:2];
  if (show) {
    TTTableActivityItem *loading = [TTTableActivityItem itemWithText:@"Loading..."];
    [twitterItems addObject:loading];
  } else {
    for (id item in twitterItems) {
      if ([item isMemberOfClass:[TTTableActivityItem class]]) {
        [twitterItems removeObjectIdenticalTo:item];
        break;
      }
    }
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableViewDidLoadModel:(UITableView*)tableView {
  NSMutableArray* items = [[NSMutableArray alloc] init];

  for (TTTwitterTweet* tweet in _searchFeedModel.tweets) {
    NSString *url = [NSString stringWithFormat:@"http://twitter.com/%@",
                     [tweet.username stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSString *link = [NSString stringWithFormat:@"<a href='%@'>%@</a>", url, tweet.username];
    
    TTStyledText* styledText = [TTStyledText textFromXHTML:
                                [NSString stringWithFormat:@"%@\n<b>%@</b>",
                                 [[tweet.text stringByReplacingOccurrencesOfString:@"&"
                                                                        withString:@"&amp;"]
                                  stringByReplacingOccurrencesOfString:@"<"
                                  withString:@"&lt;"],
                                 [tweet.created formatRelativeTime]]
                                                lineBreaks:YES URLs:YES];
    // If this asserts, it's likely that the tweet.text contains an HTML character that caused
    // the XML parser to fail.
    TTDASSERT(nil != styledText);
    
    TTTableStyledMessageItem *item = [TTTableStyledMessageItem itemWithText:styledText];
    item.timestamp = tweet.created;
    item.imageURL = tweet.imageUrl;
    [items addObject:item];
  }
  
  
  if (!_searchFeedModel.finished) {
    [items addObject:[TTTableMoreButton itemWithText:@"more…"]];
  }

  NSMutableArray *twitterItems = [self.items objectAtIndex:2];
  [twitterItems addObjectsFromArray:items];
    
  TT_RELEASE_SAFELY(items);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//- (NSString*)titleForLoading:(BOOL)reloading {
//  if (reloading) {
//    return NSLocalizedString(@"Updating Twitter feed...", @"Twitter feed updating text");
//  } else {
//    return NSLocalizedString(@"Loading Twitter feed...", @"Twitter feed loading text");
//  }
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (NSString*)titleForEmpty {
//  return NSLocalizedString(@"No tweets found.", @"Twitter feed no results");
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (NSString*)subtitleForError:(NSError*)error {
//  return NSLocalizedString(@"Sorry, there was an error loading the Twitter stream.", @"");
//}


@end


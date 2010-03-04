//
// Copyright 2009-2010 Facebook
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

#import "TTTwitterSearchFeedDataSource.h"

#import "TTTwitterSearchFeedModel.h"
#import "TTTwitterTweet.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTTwitterSearchFeedDataSource


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithSearchQuery:(NSString*)searchQuery {
  if (self = [super init]) {
    _searchFeedModel = [[TTTwitterSearchFeedModel alloc] initWithSearchQuery:searchQuery];
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


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableViewDidLoadModel:(UITableView*)tableView {
  NSMutableArray* items = [[NSMutableArray alloc] init];

  for (TTTwitterTweet* tweet in _searchFeedModel.tweets) {
    NSString *username = @"Username";
    NSString *url = [NSString stringWithFormat:@"http://twitter.com/%@",
                     [username stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSString *link = [NSString stringWithFormat:@"<a href='%@'>%@</a>", url, username];
    
    TTStyledText* styledText = [TTStyledText textFromXHTML:
                                [NSString stringWithFormat:@"<b>%@</b><br />%@", link,
                                 [tweet.text stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]]
                               lineBreaks:YES URLs:YES];
    TTDASSERT(nil != styledText);
    
    TTTableStyledMessageItem *item = [TTTableStyledMessageItem itemWithText:styledText];
    item.timestamp = tweet.created;
    item.imageURL = tweet.imageUrl;
    [items addObject:item];
  }
  
  self.items = items;
  TT_RELEASE_SAFELY(items);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForLoading:(BOOL)reloading {
  if (reloading) {
    return NSLocalizedString(@"Updating Twitter feed...", @"Twitter feed updating text");
  } else {
    return NSLocalizedString(@"Loading Twitter feed...", @"Twitter feed loading text");
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForEmpty {
  return NSLocalizedString(@"No tweets found.", @"Twitter feed no results");
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitleForError:(NSError*)error {
  return NSLocalizedString(@"Sorry, there was an error loading the Twitter stream.", @"");
}


@end


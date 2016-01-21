#import "JCPostsItem.h"
#import "NSObject+PNCast.h"

@interface JCPostsItem ()

// Private interface goes here.

@end

@implementation JCPostsItem

- (void)parseNode:(NSDictionary *)node {
    self.itemId = [NSNumber cast:node[@"id"]];
    self.title = [NSString cast:node[@"title"]];
    self.content = [NSString cast:node[@"content"][@"rendered"]];
}

@end

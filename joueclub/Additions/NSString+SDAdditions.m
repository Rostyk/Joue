//
//  NSString+SDAdditions.m
//  

#import "NSString+SDAdditions.h"


static NSUInteger MLLimitedFileNameFirstPartLength = 40;
static NSUInteger MLLimitedFileNameLastPartLength = 8;


@implementation NSString (SDStringAdditions)

- (BOOL)isEmailAddress
{
    NSString *emailRegex = @"[[A-Z0-9a-z~._%+-][}{?|/'=`*&!#$^]]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidName
{
    return [self rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\\/:*?<>|"]].location == NSNotFound;
}

- (NSString *)URLEncodedString
{
    NSString *encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                           (__bridge CFStringRef)self,
                                                                                           NULL,
                                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                           kCFStringEncodingUTF8);
    NSString *result = [encodedString copy];
    CFRelease((__bridge CFStringRef)(encodedString));
    
	return result;
}

- (NSString*)URLDecodedString
{
	NSString *decodedString = (__bridge NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                           (__bridge CFStringRef)self,
                                                                                                           CFSTR(""),
                                                                                                           kCFStringEncodingUTF8);
    
    NSString *result = [decodedString copy];
    CFRelease((__bridge CFStringRef)(decodedString));
    
	return result;
}

- (NSString *)JSONEncodedString
{
    NSMutableString *outputString = [[NSMutableString alloc] init];
    
    for (int i = 0; i < [self length]; i ++) 
    {
        
        unichar symbol;
        
        [self getCharacters:&symbol range:NSMakeRange(i, 1)];
        
        switch (symbol) 
        {
            case '\\': 
                    [outputString appendString:@"\\\\"];
                    break;
            case '\"': 
                    [outputString appendString:@"\\\""];
                    break;
            /*
            case '/': 
                    [outputString appendString:@"%x2F"];
                    break;
            case '\n': 
                    [outputString appendString:@"%x6E"];
                    break;
            case '\t': 
                    [outputString appendString:@"%x74"];
                    break;
            case '\b': 
                    [outputString appendString:@"%x62"];
                    break;
            case '\r': 
                    [outputString appendString:@"%x72"];
                    break;
            case '\f': 
                    [outputString appendString:@"%x66"];
                    break;
            */
            default:
                [outputString appendFormat:@"%C",symbol];
                break;
        }
    }
    
    return [outputString copy];
}

- (BOOL)isRestrictedFileName
{
    static NSSet *restrictedNames = nil;
    
    if (restrictedNames == nil)
    {
        @synchronized (self)
        {
            restrictedNames = [[NSSet alloc] initWithObjects:@"CON", @"PRN", @"AUX", @"CLOCK$", @"NUL",
                               @"COM0", @"COM1", @"COM2", @"COM3", @"COM4", @"COM5", @"COM6",
                               @"COM7", @"COM8", @"COM9", @"LPT0", @"LPT1", @"LPT2", @"LPT3",
                               @"LPT4", @"LPT5", @"LPT6", @"LPT7", @"LPT8", @"LPT9", nil];
        }
    }
    
    return [restrictedNames containsObject:[[self stringByDeletingPathExtension] uppercaseString]];
}

- (NSString *)trimedString 
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)limitedLengthFileName
{
    NSString *result = self;
    if (self.length > MLLimitedFileNameFirstPartLength + MLLimitedFileNameLastPartLength)
    {
        result = [NSString stringWithFormat:@"%@...%@", [self substringToIndex:MLLimitedFileNameFirstPartLength], [self substringFromIndex:self.length - MLLimitedFileNameLastPartLength]];
    }
    
    return result;
}

@end

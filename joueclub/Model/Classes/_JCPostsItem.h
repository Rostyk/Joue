// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JCPostsItem.h instead.

#import <CoreData/CoreData.h>

extern const struct JCPostsItemAttributes {
	__unsafe_unretained NSString *content;
	__unsafe_unretained NSString *itemId;
	__unsafe_unretained NSString *title;
} JCPostsItemAttributes;

@interface JCPostsItemID : NSManagedObjectID {}
@end

@interface _JCPostsItem : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) JCPostsItemID* objectID;

@property (nonatomic, strong) NSString* content;

//- (BOOL)validateContent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* itemId;

@property (atomic) int64_t itemIdValue;
- (int64_t)itemIdValue;
- (void)setItemIdValue:(int64_t)value_;

//- (BOOL)validateItemId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@end

@interface _JCPostsItem (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveContent;
- (void)setPrimitiveContent:(NSString*)value;

- (NSNumber*)primitiveItemId;
- (void)setPrimitiveItemId:(NSNumber*)value;

- (int64_t)primitiveItemIdValue;
- (void)setPrimitiveItemIdValue:(int64_t)value_;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

@end

@interface ECQuery : NSObject

@property NSFetchRequestResultType resultType;
@property(strong) NSArray *propertiesToFetch;
@property(strong) NSArray *propertiesToGroupBy;
@property NSUInteger offset;
@property NSUInteger limit;

+ (ECQuery *) queryForEntity:(NSString *) entity;
+ (ECQuery *) queryForEntity:(NSString *) entity predicate:(NSString *) predicate, ...;
+ (ECQuery *) queryForEntity:(NSString *) entity limit:(NSUInteger) limit;
+ (ECQuery *) queryForEntity:(NSString *) entity limit:(NSUInteger) limit offset:(NSUInteger) offset;
+ (ECQuery *) queryForEntity:(NSString *) entity limit:(NSUInteger) limit predicate:(NSString *) predicate, ...;
+ (ECQuery *) queryForEntity:(NSString *) entity limit:(NSUInteger) limit offset:(NSUInteger) offset predicate:(NSString *) predicate, ...;

- (NSFetchRequest *) fetchRequest;

- (void) addSort:(NSString *) property ascending:(BOOL) ascending;

@end
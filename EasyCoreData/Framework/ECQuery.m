#import "ECQuery.h"

@implementation ECQuery {
    NSString *entityName;
    NSPredicate *predicate;
    NSMutableArray *sortDescriptors;
}

- (id) init {
    self = [super init];
    if (self) {
        sortDescriptors = [NSMutableArray new];
        _resultType = NSManagedObjectResultType;
    }
    return self;
}

+ (ECQuery *) queryForEntity:(NSString *) entity {
    return [self queryForEntity:entity predicate:nil];
}

+ (ECQuery *) queryForEntity:(NSString *) entity limit:(NSUInteger) limit {
    return [self queryForEntity:entity limit:limit offset:0 predicate:nil];
}

+ (ECQuery *) queryForEntity:(NSString *) entity limit:(NSUInteger) limit offset:(NSUInteger) offset {
    return [self queryForEntity:entity limit:limit offset:offset predicate:nil];
}

+ (ECQuery *) queryForEntity:(NSString *) entity predicate:(NSString *) format, ... {
    ECQuery *easyQuery = [ECQuery new];
    easyQuery->entityName = entity;

    if (format) {
        va_list arguments;
        va_start(arguments, format);
        easyQuery->predicate = [NSPredicate predicateWithFormat:format arguments:arguments];
        va_end(arguments);
    }

    return easyQuery;
}

+ (ECQuery *) queryForEntity:(NSString *) entity limit:(NSUInteger) limit predicate:(NSString *) predicate, ... {
    va_list arguments;
    va_start(arguments, predicate);
    ECQuery *query = [self queryForEntity:entity predicate:predicate, arguments];
    va_end(arguments);

    query->_limit = limit;

    return query;
}

+ (ECQuery *) queryForEntity:(NSString *) entity limit:(NSUInteger) limit offset:(NSUInteger) offset predicate:(NSString *) predicate, ... {
    va_list arguments;
    va_start(arguments, predicate);
    ECQuery *query = [self queryForEntity:entity predicate:predicate, arguments];
    va_end(arguments);

    query->_limit = limit;
    query->_offset = offset;

    return query;
}

- (NSFetchRequest *) fetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = sortDescriptors;
    if (_limit > 0) {
        fetchRequest.fetchLimit = _limit;
    }
    if (_offset > 0) {
        fetchRequest.fetchOffset = _offset;
    }
    fetchRequest.resultType = _resultType;
    fetchRequest.propertiesToGroupBy = _propertiesToGroupBy;
    fetchRequest.propertiesToFetch = _propertiesToFetch;
    return fetchRequest;
}

- (void) addSort:(NSString *) property ascending:(BOOL) ascending {
    [sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:property ascending:ascending]];
}
@end
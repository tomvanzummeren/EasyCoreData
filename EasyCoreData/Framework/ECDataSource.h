@class ECQuery;

@interface ECDataSource : NSObject

@property (readonly) NSURL *modelUrl;
@property (readonly) NSURL *storeUrl;

@property(readonly) NSManagedObjectContext *managedObjectContext;
@property(readonly) NSManagedObjectModel *managedObjectModel;
@property(readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (ECDataSource *) instance;

+ (void) configureModelName:(NSString *) modelName storeFileName:(NSString *) storeFileName;

- (void) saveContext;

- (NSArray *) fetchMultiple:(ECQuery *) query;

- (NSArray *) fetchSingle:(ECQuery *) query;

- (id) createEntity:(NSString *) entity;
@end
#import "ECDataSource.h"
#import "ECQuery.h"
#import "ECErrorAlertView.h"

@implementation ECDataSource {
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

+ (ECDataSource *) instance {
    static ECDataSource *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

+ (void) configureModelName:(NSString *) modelName storeFileName:(NSString *) storeFileName {
    [ECDataSource instance]->_modelUrl = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
    [ECDataSource instance]->_storeUrl = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:storeFileName];
}

+ (NSURL *) applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        managedObjectContext = [NSManagedObjectContext new];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

- (NSManagedObjectModel *) managedObjectModel {
    if (!_modelUrl) {
        NSLog(@"ERROR: The [EasyCoreData instance].modelUrl property is not set");
        abort();
    }
    if (managedObjectModel) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:_modelUrl];
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
    if (!_storeUrl) {
        NSLog(@"ERROR: The [EasyCoreData instance].storeUrl property is not set");
        abort();
    }
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:_storeUrl
                                                        options:nil
                                                          error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return persistentStoreCoordinator;
}

- (void) saveContext {
    NSError *error = nil;
    NSManagedObjectContext *context = [self managedObjectContext];
    if ([context hasChanges] && ![context save:&error]) {
        [ECErrorAlertView showOnError:error];
    }
}

- (NSArray *) fetchMultiple:(ECQuery *) query {
    NSFetchRequest *request = [query fetchRequest];
    NSError *queryError = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&queryError];
    [ECErrorAlertView showOnError:queryError];
    return results;
}

- (NSManagedObject *) fetchSingle:(ECQuery *) query {
    NSArray *results = [self fetchMultiple:query];
    if (results.count > 1) {
        NSLog(@"WARNING: Fetching single result matches multiple");
    }
    if (results.count == 0) {
        return nil;
    }
    return results[0];
}

- (id) createEntity:(NSString *) entity {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entity
                                                         inManagedObjectContext:self.managedObjectContext];

    return [[NSManagedObject alloc] initWithEntity:entityDescription
                    insertIntoManagedObjectContext:self.managedObjectContext];
}

@end
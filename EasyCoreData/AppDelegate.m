
#import "AppDelegate.h"
#import "ECDataSource.h"

@implementation AppDelegate

- (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
    [ECDataSource configureModelName:@"EasyCoreData"
                       storeFileName:@"EasyCoreData.sqlite"];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
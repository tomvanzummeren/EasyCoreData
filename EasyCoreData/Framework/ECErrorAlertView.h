#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface ECErrorAlertView : UIAlertView
- (id) initWithError:(NSError *) error;

+ (void) showOnError:(NSError *) error;
@end
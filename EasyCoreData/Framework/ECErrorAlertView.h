
@interface ECErrorAlertView : UIAlertView
- (id) initWithError:(NSError *) error;

+ (void) showOnError:(NSError *) error;
@end
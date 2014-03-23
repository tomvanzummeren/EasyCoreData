
#import "ECErrorAlertView.h"

@implementation ECErrorAlertView {

}

- (id) initWithError:(NSError *) error {
    self = [super initWithTitle:[error localizedDescription]
                        message:[error localizedFailureReason]
                       delegate:nil
              cancelButtonTitle:NSLocalizedString(@"OK", nil)
              otherButtonTitles:nil];
    if (self) {
    }
    return self;
}

+ (void) showOnError:(NSError *) error {
    if (error) {
        [[[ECErrorAlertView alloc] initWithError:error] show];
    }
}
@end
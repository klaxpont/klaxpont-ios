//
//  KlaxAlertView.h
//  klaxpont
//
//  Created by François Benaiteau on 9/12/12.
//
//

#import "MBProgressHUD.h"

@interface KlaxAlertView : MBProgressHUD

-(id)initWithError:(NSString*)errorMessage;
@end

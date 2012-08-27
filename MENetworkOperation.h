//
//  MENetworkOperation.h
//
//  Created by Michael Enriquez on 8/24/12.
//
//

#import <Foundation/Foundation.h>
#import "MEDataOperation.h"

@interface MENetworkOperation : NSOperation
- (id)initWithRequest:(NSURLRequest *)request;
- (void)addToGlobalQueueManager;
@property (strong, nonatomic) MEDataOperation *processResponseOperation;
@property (strong, readonly, nonatomic) NSMutableData *responseData;
@property (strong, readonly, nonatomic) NSURLResponse *response;
@property (strong, readonly, nonatomic) NSError *error;
@end

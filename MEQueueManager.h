//
//  MEQueueManager.h
//
//  Created by Michael Enriquez on 8/24/12.
//
//

#import <Foundation/Foundation.h>

@interface MEQueueManager : NSObject
+ (MEQueueManager *)sharedInstance;
- (void)addOperation:(NSOperation *)operation;
- (void)cancelAllOperations;
@end

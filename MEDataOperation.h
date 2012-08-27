//
//  MEDataOperation.h
//
//  Created by Michael Enriquez on 8/24/12.
//
//

#import <Foundation/Foundation.h>

@class MEDataOperation;

typedef void (^ECExecutionBlock)(MEDataOperation *operation, NSData *data, NSURLResponse *urlResponse);

@interface MEDataOperation : NSOperation
- (void)addToGlobalQueueManager;
@property (copy, nonatomic) NSData *data;
@property (strong, nonatomic) id output;
@property (copy, nonatomic) NSURLResponse *response;
@property (strong, readonly, nonatomic) NSError *error;
@property (copy, nonatomic) ECExecutionBlock executionBlock;
@end

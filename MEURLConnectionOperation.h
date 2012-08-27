//
//  MEURLConnection.h
//
//  Created by Michael Enriquez on 8/25/12.
//
//

#import <Foundation/Foundation.h>
#import "MEQueueManager.h"
#import "MEDataOperation.h"

typedef void (^ECConnectionSuccessBlock)(id result);
typedef void (^ECConnectionFailureBlock)(NSError *error);


@interface MEURLConnectionOperation : NSOperation
- (id)initWithRequest:(NSURLRequest *)request;
@property (copy, nonatomic) ECExecutionBlock dataProcessBlock;
@property (copy, nonatomic) ECConnectionSuccessBlock onSuccess;
@property (copy, nonatomic) ECConnectionFailureBlock onFailure;
@end

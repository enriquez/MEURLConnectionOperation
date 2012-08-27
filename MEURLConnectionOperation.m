//
//  MEURLConnection.m
//
//  Created by Michael Enriquez on 8/25/12.
//
//

#import "MEURLConnectionOperation.h"
#import "MENetworkOperation.h"

@interface MEURLConnectionOperation()
- (void)start;
- (void)cancel;
@property (assign, nonatomic) BOOL isConcurrent;
@property (assign, nonatomic) BOOL isExecuting;
@property (assign, nonatomic) BOOL isFinished;
@property (strong, nonatomic) NSURLRequest *request;
@property (strong, nonatomic) MEDataOperation *dataOperation;
@property (strong, nonatomic) MENetworkOperation *networkOperation;
@end

@implementation MEURLConnectionOperation

#pragma mark - NSObject

- (id)initWithRequest:(NSURLRequest *)request {
  self = [super init];
  if (self) {
    self.request = request;
  }
  return self;
}

#pragma mark - NSOperation

- (void)start {
  if (self.isReady) {
    self.isExecuting = YES;
    
    if (self.isCancelled) {
      self.isExecuting = NO;
      self.isFinished = YES;
    } else {
      self.networkOperation = [[MENetworkOperation alloc] initWithRequest:self.request];
      self.networkOperation.processResponseOperation = self.dataOperation;
      
      self.dataOperation.completionBlock = ^{
        if (self.networkOperation.error) {
          self.onFailure(self.networkOperation.error);
        } else if (self.dataOperation.error) {
          self.onFailure(self.dataOperation.error);
        } else if (!self.networkOperation.isCancelled && !self.dataOperation.isCancelled && !self.isCancelled){
          self.onSuccess(self.dataOperation.output);
        } else {
          // operation was cancelled.
        }
        
        self.isExecuting = NO;
        self.isFinished = YES;
      };
      
      [self.networkOperation addToGlobalQueueManager];
      [self.dataOperation addToGlobalQueueManager];
    }
  }
}


- (void)cancel {
  [self.networkOperation cancel];
  [self.dataOperation cancel];
  [super cancel];
}


- (BOOL)isConcurrent {
  return YES;
}


- (void)setIsExecuting:(BOOL)isExecuting {
  [self willChangeValueForKey:@"isExecuting"];
  _isExecuting = isExecuting;
  [self didChangeValueForKey:@"isExecuting"];
}


- (void)setIsFinished:(BOOL)isFinished {
  [self willChangeValueForKey:@"isFinished"];
  _isFinished = isFinished;
  [self didChangeValueForKey:@"isFinished"];
}


#pragma mark - Properties

- (void)setDataProcessBlock:(ECExecutionBlock)dataProcessBlock {
  _dataProcessBlock = dataProcessBlock;
  self.dataOperation = [[MEDataOperation alloc] init];
  self.dataOperation.executionBlock = _dataProcessBlock;
}

@end

//
//  MEDataOperation.m
//
//  Created by Michael Enriquez on 8/24/12.
//
//

#import "MEDataOperation.h"
#import "MEQueueManager.h"

@interface MEDataOperation()
- (void)start;
@property (assign, nonatomic) BOOL isConcurrent;
@property (assign, nonatomic) BOOL isExecuting;
@property (assign, nonatomic) BOOL isFinished;
@end

@implementation MEDataOperation

#pragma mark - Public

- (void)addToGlobalQueueManager {
  [[MEQueueManager sharedInstance] addOperation:self];
}


#pragma mark - NSOperation

- (void)start {
  if (self.isReady) {
    self.isExecuting = YES;
    
    if (self.isCancelled) {
      self.isExecuting = NO;
      self.isFinished = YES;
    } else {
      self.executionBlock(self, self.data, self.response);
      self.isExecuting = NO;
      self.isFinished = YES;
    }
  }
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

@end

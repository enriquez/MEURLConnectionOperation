//
//  MEQueueManager.m
//
//  Created by Michael Enriquez on 8/24/12.
//
//

#import "MEQueueManager.h"
#import "MENetworkOperation.h"

@interface MEQueueManager()
@property (strong, nonatomic) NSOperationQueue *networkQueue;
@property (strong, nonatomic) NSOperationQueue *cpuQueue;
@end

@implementation MEQueueManager

#pragma mark - Singleton

+ (MEQueueManager *)sharedInstance {
	static MEQueueManager *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}


#pragma mark - NSObject

- (id)init {
  self = [super init];
  if (self) {
    self.networkQueue = [[NSOperationQueue alloc] init];
    self.cpuQueue = [[NSOperationQueue alloc] init];
    
    self.networkQueue.maxConcurrentOperationCount = 4;
    self.cpuQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
  }
  return self;
}


#pragma mark - Public

- (void)addOperation:(NSOperation *)operation {
  if ([operation isKindOfClass:MENetworkOperation.class]) {
    [self.networkQueue addOperation:operation];
  } else {
    [self.cpuQueue addOperation:operation];
  }
}


- (void)cancelAllOperations {
  [self.networkQueue cancelAllOperations];
  [self.cpuQueue cancelAllOperations];
}

@end

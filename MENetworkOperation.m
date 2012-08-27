//
//  MENetworkOperation.m
//
//  Created by Michael Enriquez on 8/24/12.
//
//

#import "MENetworkOperation.h"
#import "MEQueueManager.h"

@interface MENetworkOperation()
- (void)start;
- (void)startConnection;
@property (copy, nonatomic) NSURLRequest *request;
@property (assign, nonatomic) BOOL isConcurrent;
@property (assign, nonatomic) BOOL isExecuting;
@property (assign, nonatomic) BOOL isFinished;
@end

@implementation MENetworkOperation

#pragma mark - Network Thread

+ (void)networkRequestThreadEntryPoint:(id)object {
  do {
    [[NSRunLoop currentRunLoop] run];
  } while (YES);
}


+ (NSThread *)networkRequestThread {
  static NSThread *_networkRequestThread = nil;
  static dispatch_once_t oncePredicate;
  
  dispatch_once(&oncePredicate, ^{
    _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
    _networkRequestThread.name = @"Network Request Thread";
    [_networkRequestThread start];
  });
  
  return _networkRequestThread;
}


#pragma mark - NSObject

- (id)initWithRequest:(NSURLRequest *)theRequest {
  self = [super init];
  if (self) {
    self.request = theRequest;
    _responseData = [NSMutableData data];
  }
  
  return self;
}


#pragma mark - Public

- (void)addToGlobalQueueManager {
  [[MEQueueManager sharedInstance] addOperation:self];  
}


#pragma mark - Properties

- (void)setProcessResponseOperation:(MEDataOperation *)processResponseOperation {
  _processResponseOperation = processResponseOperation;
  [_processResponseOperation addDependency:self];
}


#pragma mark - NSOperation

- (void)start {
  if (self.isReady) {
    self.isExecuting = YES;
    
    if (self.isCancelled) {
      self.isExecuting = NO;
      self.isFinished = YES;
    } else {
      [self performSelector:@selector(startConnection) onThread:[self.class networkRequestThread] withObject:self waitUntilDone:NO];
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


#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  if (self.isCancelled) {
    [connection cancel];
    self.isExecuting = NO;
    self.isFinished = YES;
  } else {
    _response = response;
    self.processResponseOperation.response = _response;
    [_responseData setLength:0];
  }
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  if (self.isCancelled) {
    [connection cancel];
    self.isExecuting = NO;
    self.isFinished = YES;
  } else {
    [_responseData appendData:data];
  }
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  _error = error;
  [self cancel];
  self.isExecuting = NO;
  self.isFinished = YES;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  self.processResponseOperation.data = _responseData;
  self.isExecuting = NO;
  self.isFinished = YES;
}


#pragma mark - Private

- (void)startConnection {
  NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
  [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
  [connection start];
}

@end

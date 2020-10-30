//
// 
//

#import <Foundation/Foundation.h>

// The protocol that this service will vend as its API.
// This header file will also need to be visible to the process hosting the service.
@protocol SandboxBreakerProtocol

- (void)getTextOfFile:(NSString *)path withReply:(void (^)(NSString *))reply;

- (void)setSocket:(NSString *)path done:(void (^)(void))done;

- (void)send:(NSData *)data response:(void (^)(NSData *))response;
    
@end

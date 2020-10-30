//
// 
//

#import "SandboxBreaker.h"

@implementation SandboxBreaker

- (void)getTextOfFile:(NSString *)path withReply:(void (^)(NSString *))reply {
    NSData* data = [NSFileManager.defaultManager contentsAtPath:path];
    if (data == nil) {
        return reply([[NSString alloc] initWithFormat:@"Got no data from %@", path]);
    }
    NSString* text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (text == nil) {
        reply([[NSString alloc] initWithFormat:@"Could not read file %@", path]);
    }
    reply(text);
}

@end

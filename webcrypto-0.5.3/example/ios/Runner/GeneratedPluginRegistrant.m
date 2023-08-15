//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<webcrypto/WebcryptoPlugin.h>)
#import <webcrypto/WebcryptoPlugin.h>
#else
@import webcrypto;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [WebcryptoPlugin registerWithRegistrar:[registry registrarForPlugin:@"WebcryptoPlugin"]];
}

@end

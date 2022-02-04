#import "FxenditPlugin.h"
#if __has_include(<fxendit/fxendit-Swift.h>)
#import <fxendit/fxendit-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "fxendit-Swift.h"
#endif

@implementation FxenditPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFxenditPlugin registerWithRegistrar:registrar];
}
@end

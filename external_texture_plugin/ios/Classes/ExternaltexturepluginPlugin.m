#import "ExternaltexturepluginPlugin.h"
#if __has_include(<externaltextureplugin/externaltextureplugin-Swift.h>)
#import <externaltextureplugin/externaltextureplugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "externaltextureplugin-Swift.h"
#endif

@implementation ExternaltexturepluginPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftExternaltexturepluginPlugin registerWithRegistrar:registrar];
}
@end

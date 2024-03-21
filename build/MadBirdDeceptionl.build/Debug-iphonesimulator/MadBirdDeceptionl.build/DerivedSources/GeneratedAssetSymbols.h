#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "background" asset catalog image resource.
static NSString * const ACImageNameBackground AC_SWIFT_PRIVATE = @"background";

/// The "bird" asset catalog image resource.
static NSString * const ACImageNameBird AC_SWIFT_PRIVATE = @"bird";

/// The "brick" asset catalog image resource.
static NSString * const ACImageNameBrick AC_SWIFT_PRIVATE = @"brick";

/// The "tree" asset catalog image resource.
static NSString * const ACImageNameTree AC_SWIFT_PRIVATE = @"tree";

#undef AC_SWIFT_PRIVATE

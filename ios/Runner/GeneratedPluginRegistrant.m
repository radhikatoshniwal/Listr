//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<cloud_firestore/CloudFirestorePlugin.h>)
#import <cloud_firestore/CloudFirestorePlugin.h>
#else
@import cloud_firestore;
#endif

#if __has_include(<firebase_auth/FirebaseAuthPlugin.h>)
#import <firebase_auth/FirebaseAuthPlugin.h>
#else
@import firebase_auth;
#endif

#if __has_include(<firebase_core/FLTFirebaseCorePlugin.h>)
#import <firebase_core/FLTFirebaseCorePlugin.h>
#else
@import firebase_core;
#endif

#if __has_include(<flutter_keyboard_visibility/FlutterKeyboardVisibilityPlugin.h>)
#import <flutter_keyboard_visibility/FlutterKeyboardVisibilityPlugin.h>
#else
@import flutter_keyboard_visibility;
#endif

#if __has_include(<image_picker/FLTImagePickerPlugin.h>)
#import <image_picker/FLTImagePickerPlugin.h>
#else
@import image_picker;
#endif

#if __has_include(<phone_number/PhoneNumberPlugin.h>)
#import <phone_number/PhoneNumberPlugin.h>
#else
@import phone_number;
#endif

#if __has_include(<shared_preferences/FLTSharedPreferencesPlugin.h>)
#import <shared_preferences/FLTSharedPreferencesPlugin.h>
#else
@import shared_preferences;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FLTCloudFirestorePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTCloudFirestorePlugin"]];
  [FLTFirebaseAuthPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseAuthPlugin"]];
  [FLTFirebaseCorePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseCorePlugin"]];
  [FlutterKeyboardVisibilityPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterKeyboardVisibilityPlugin"]];
  [FLTImagePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTImagePickerPlugin"]];
  [PhoneNumberPlugin registerWithRegistrar:[registry registrarForPlugin:@"PhoneNumberPlugin"]];
  [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
}

@end